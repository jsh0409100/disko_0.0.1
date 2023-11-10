import 'package:disko_001/models/post_card_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/controller/auth_controller.dart';
import '../repository/write_post_repository.dart';

final writePostControllerProvider = Provider((ref) {
  final writePostRepository = ref.watch(writePostRepositoryProvider);
  return WritePostController(
    writePostRepository: writePostRepository,
    ref: ref,
  );
});

final searchPostProvider = StreamProvider.family((ref, String query) {
  return ref.watch(writePostRepositoryProvider).searchPost(query);
  //Todo 나중에 검증하기
});

final searchMyPostProvider = StreamProvider.family((ref, String query) {
  return ref.watch(writePostRepositoryProvider).searchMyPost(query);
});

final searchMyScrapProvider = StreamProvider.family((ref, String query) {
  return ref.watch(writePostRepositoryProvider).search_My_Scrap(query);
});

class WritePostController {
  final WritePostRepository writePostRepository;
  final ProviderRef ref;
  WritePostController({
    required this.writePostRepository,
    required this.ref,
  });


  void uploadPost(BuildContext context, String text, String postTitle, List<String> imagesUrl,
      String postId, int commentCount, bool isQuestion, String category, WidgetRef ref) {
    ref.read(userDataAuthProvider).whenData(
          (value) => writePostRepository.uploadPost(
            context: context,
            text: text,
            userData: value!,
            postId: postId,
            postTitle: postTitle,
            imagesUrl: imagesUrl,
            commentCount: commentCount,
            isQuestion: isQuestion,
              category:category,
            ref:ref,
          ),
        );
  }

  Stream<List<PostCardModel>> searchPost(String query) {
    return writePostRepository.searchPost(query);
  }

  Stream<List<PostCardModel>> searchMyPost(String query) {
    return writePostRepository.searchMyPost(query);
  }
}
