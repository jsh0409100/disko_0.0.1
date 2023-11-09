
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

import '../../../common/enums/country_enum.dart';
import '../../../common/utils/utils.dart';
import '../../../models/post_card_model.dart';
import '../../../models/user_model.dart';

final writePostRepositoryProvider = Provider(
  (ref) => WritePostRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref : ref,
  ),
);

class WritePostRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef<Object?> ref;

  WritePostRepository({
    required this.firestore,
    required this.auth,
    required this.ref,
  });

  String getCode(){
    final UserDataModel user = ref.watch(userDataProvider);
    final String countryCode = user.countryCode;
    return countryCode;
  }

  void _savePost({
    required String text,
    required Timestamp time,
    required String postId,
    required String username,
    required String postTitle,
    required String category,
    required List<String> imagesUrl,
    required List<String> likes,
    required int commentCount,
    required bool isQuestion,
    required WidgetRef ref,
  }) async {
    final message = PostCardModel(
      uid: auth.currentUser!.uid,
      postText: text,
      time: time,
      userName: username,
      postTitle: postTitle,
      likes: likes,
      imagesUrl: imagesUrl,
      postId: postId,
      commentCount: commentCount,
      isQuestion: isQuestion,
      category: category,
      isAnnouncement: false,
    );
    final UserDataModel user = ref.watch(userDataProvider);
    final String countryCode = user.countryCode;

    await firestore.collection('posts').doc(countries[countryCode]).collection(countries[countryCode]!).doc(postId).set(
          message.toJson(),
        );
  }

  void uploadPost({
    required BuildContext context,
    required String text,
    required String category,
    required UserDataModel userData,
    required String postTitle,
    required List<String> imagesUrl,
    required String postId,
    required int commentCount,
    required bool isQuestion,
    required WidgetRef ref
  }) async {
    try {
      var time = Timestamp.now();

      _savePost(
        postId: postId,
        postTitle: postTitle,
        imagesUrl: imagesUrl,
        likes: [],
        text: text,
        time: time,
        username: userData.displayName,
        commentCount: commentCount,
        isQuestion: isQuestion,
          category:category,
        ref:ref,
      );
    } catch (e) {
      // showSnackBar(context: context, content: e.toString());
    }
  }

  Stream<List<PostCardModel>> searchPost(String query) {
    final postTitleQuery = _posts
        .where(
          'postTitle',
          isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
          isLessThan: query.isEmpty
              ? null
              : query.substring(0, query.length - 1) +
                  String.fromCharCode(
                    query.codeUnitAt(query.length - 1) + 1,
                  ),
        )
        .snapshots();
    final postTextQuery = _posts
        .where(
          'postText',
          isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
          isLessThan: query.isEmpty
              ? null
              : query.substring(0, query.length - 1) +
                  String.fromCharCode(
                    query.codeUnitAt(query.length - 1) + 1,
                  ),
        )
        .snapshots();
    return Rx.combineLatest2(postTitleQuery, postTextQuery,
        (QuerySnapshot titleSnapshot, QuerySnapshot textSnapshot) {
      final List<PostCardModel> postCards = [];

      for (var post in titleSnapshot.docs) {
        postCards
            .add(PostCardModel.fromJson(post.data() as Map<String, dynamic>));
      }
      for (var post in textSnapshot.docs) {
        postCards
            .add(PostCardModel.fromJson(post.data() as Map<String, dynamic>));
      }

      return postCards;
    });
  }

  Stream<List<PostCardModel>> searchMyPost(String query) {
    final postUidQuery = _posts
        .where('uid', isEqualTo: query)
        .snapshots();

    final commentUidQuery = _comment
        .where('uid', isEqualTo: query)
        .snapshots();

    return commentUidQuery.switchMap((realSnapshot) {
      if (realSnapshot.docs.isEmpty) {
        print("No comments found");
        return postUidQuery.map((event) {
          List<PostCardModel> postcard = [];
          for (var post in event.docs) {
            postcard.add(PostCardModel.fromJson(post.data() as Map<String, dynamic>));
          }
          print("Query without comments");
          return postcard;
        });
      } else {
        final postStreams = <Stream<QuerySnapshot>>[];

        for (final doc in realSnapshot.docs) {
          final postId = doc.get('postId');
          final postStream = _posts.where('postId', isEqualTo: postId).snapshots();
          postStreams.add(postStream);
        }

        return Rx.combineLatest2(
          postUidQuery,
          Rx.combineLatestList(postStreams),
              (QuerySnapshot titleSnapshot, List<QuerySnapshot> postSnapshotsList) {
            final List<PostCardModel> postCards = [];

            for (var post in titleSnapshot.docs) {
              postCards.add(PostCardModel.fromJson(post.data() as Map<String, dynamic>));
            }
            for (var postSnapshots in postSnapshotsList) {
              for (var post in postSnapshots.docs) {
                postCards.add(PostCardModel.fromJson(post.data() as Map<String, dynamic>));
              }
            }
            return postCards;
          },
        );
      }
    });
  }


  Stream<List<PostCardModel>> search_My_Scrap(String query) {
    return _posts
        .where(
          'postId',
          isEqualTo: query,
        )
        .snapshots()
        .map((event) {
      List<PostCardModel> postcard = [];
      for (var post in event.docs) {
        postcard
            .add(PostCardModel.fromJson(post.data() as Map<String, dynamic>));
      }
      return postcard;
    });
  }


  CollectionReference get _posts => firestore.collection('posts').doc(countries[getCode()]).collection(countries[getCode()]!);

  Query<Map<String, dynamic>> get _comment =>
      firestore.collectionGroup('comment');
}
