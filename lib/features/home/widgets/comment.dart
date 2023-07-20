import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disko_001/features/home/widgets/nestedcomment_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../common/utils/utils.dart';
import 'bottom_nestedcomment_field.dart';

class Comment extends StatefulWidget {
  final String userName, text, uid, postId, commentId;
  final List<String> likes;
  final Timestamp time;
  final int commentCount;

  const Comment({
    Key? key,
    required this.uid,
    required this.userName,
    required this.text,
    required this.likes,
    required this.time,
    required this.postId,
    required this.commentId,
    required this.commentCount,
  }) : super(key: key);

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  final user = FirebaseAuth.instance.currentUser;
  CollectionReference postsCollection = FirebaseFirestore.instance.collection('posts');
  bool _isLiked = false;
  Color likeColor = Colors.black;
  Icon likeIcon = const Icon(
    Icons.favorite_border,
    size: 20,
  );

  @override
  Widget build(BuildContext context) {
    if (widget.likes.contains(user!.uid)) {
      likeColor = Theme.of(context).colorScheme.primary;
      likeIcon = const Icon(
        Icons.favorite,
        size: 20,
      );
    } else {
      likeColor = Colors.black;
      likeIcon = const Icon(
        Icons.favorite_border,
        size: 20,
      );
    }

    void commentBottomsheet() {
      showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: [
                      IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_ios_new)),
                      const Text(
                        '댓글',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  Expanded(
                    child: NestedCommentList(
                      postId: widget.postId,
                      commentId: widget.commentId,
                    ),
                  ),
                  BottomNestedCommentField(
                    postId: widget.postId,
                    commentId: widget.commentId,
                    likes: widget.likes,
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return FutureBuilder(
        future: getUserDataByUid(widget.uid),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData == false) {
            return Card(
              color: Colors.grey.shade300,
              child: Column(children: [
                SizedBox(
                  height: 70,
                  width: MediaQuery.of(context).size.width * 0.9,
                ),
                const SizedBox(
                  height: 11,
                )
              ]),
            );
          }
          return Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: SizedBox(
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image(
                                image: NetworkImage(snapshot.data.profilePic),
                                height: 36,
                                width: 36,
                                fit: BoxFit.scaleDown,
                              )),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  children: [
                                    Text(
                                      widget.userName,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      readTimestamp(widget.time),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                child: SizedBox(
                                  width: 300,
                                  child: Text(
                                    widget.text,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      FirebaseFirestore.instance
                                          .collection('posts')
                                          .doc(widget.postId)
                                          .collection('comment')
                                          .doc(widget.commentId)
                                          .get();
                                      if (widget.likes.contains(user!.uid)) {
                                        widget.likes.remove(user!.uid);
                                        setState(() {
                                          _isLiked = false;
                                        });
                                      } else {
                                        widget.likes.add(user!.uid);
                                        setState(() {
                                          _isLiked = true;
                                        });
                                      }
                                      await postsCollection
                                          .doc(widget.postId)
                                          .collection('comment')
                                          .doc(widget.commentId)
                                          .update({
                                        'likes': widget.likes,
                                      });
                                    },
                                    icon: likeIcon,
                                    color: likeColor,
                                    style: IconButton.styleFrom(
                                      minimumSize: Size.zero,
                                      padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  ),
                                  Text(
                                    widget.likes.length.toString(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          commentBottomsheet();
                                        },
                                        icon: Icon(Symbols.chat_add_on),
                                        iconSize: 20,
                                        style: IconButton.styleFrom(
                                          minimumSize: Size.zero,
                                          padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 40,
                                child: TextButton(
                                  onPressed: () {
                                    commentBottomsheet();
                                  },
                                  style: TextButton.styleFrom(
                                    minimumSize: Size.zero,
                                    padding: EdgeInsets.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    '답글 ${widget.commentCount}개',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
