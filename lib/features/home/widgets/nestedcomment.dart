import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../common/enums/notification_enum.dart';
import '../../../common/utils/utils.dart';
import '../../profile/screens/other_user_profile_page.dart';
import '../controller/post_controller.dart';
import 'bottom_nestedcomment_field.dart';

class NestedComment extends StatefulWidget {
  final String userName, text, uid, postId, commentId, nestedcommentId;
  final List<String> likes;
  final Timestamp time;

  const NestedComment({
    Key? key,
    required this.uid,
    required this.userName,
    required this.text,
    required this.likes,
    required this.time,
    required this.postId,
    required this.commentId,
    required this.nestedcommentId,
  }) : super(key: key);

  @override
  State<NestedComment> createState() => _NestedCommentState();
}

class _NestedCommentState extends State<NestedComment> {
  final user = FirebaseAuth.instance.currentUser;
  CollectionReference postsCollection = FirebaseFirestore.instance.collection('posts');
  bool _isLiked = false;
  Color likeColor = Colors.black;
  Icon likeIcon = const Icon(Icons.favorite_border, size: 20,);

  @override
  Widget build(BuildContext context) {
    if (widget.likes.contains(user!.uid)) {
      likeColor = Theme.of(context).colorScheme.primary;
      likeIcon = const Icon(Icons.favorite, size: 20,);
    } else {
      likeColor = Colors.black;
      likeIcon = const Icon(Icons.favorite_border, size: 20,);
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
        return SizedBox(
          height: 100,
          child: Row(
            children: [
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image(
                              image: NetworkImage(snapshot.data.profilePic),
                              height: 36,
                              width: 36,
                              fit: BoxFit.scaleDown,
                            )
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            OtherUserProfilePage.routeName,
                            arguments: {
                              'uid': widget.uid,
                            },
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                child: Text(
                                  widget.userName,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    OtherUserProfilePage.routeName,
                                    arguments: {
                                      'uid': widget.uid,
                                    },
                                  );
                                },
                              ),
                              const SizedBox(width: 5),
                              Text(
                                readTimestamp(widget.time),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 200,
                            child: Text(
                              widget.text,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      FirebaseFirestore.instance
                                          .collection('posts')
                                          .doc(widget.postId)
                                          .collection('comment')
                                          .doc(widget.commentId)
                                          .collection('nestedcomment')
                                          .doc(widget.nestedcommentId)
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
                                          .collection('nestedcomment')
                                          .doc(widget.nestedcommentId)
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
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      }
    );
  }
}
