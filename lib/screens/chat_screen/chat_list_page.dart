import 'package:disko_001/screens/chat_screen/screens/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        GestureDetector(
          onTap: () {
            Get.to(() => const ChatPage());
          },
          child: Container(
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(
              color: Color(0xFF767676),
              width: 0.2,
            ))),
            padding: const EdgeInsets.all(15.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.92,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: const Image(
                        image: NetworkImage(
                            'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                        height: 43,
                        width: 43,
                        fit: BoxFit.scaleDown,
                      )),
                  const SizedBox(
                    width: 11,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              '나는야 아창 똑순이',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              '오후 12:05',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '안녕하세요! 게시글 보고 연락드립니다!',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF767676)),
                            ),
                            CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              radius: 15,
                              child: Text(
                                '1',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
//
// class PostsDatabase {
//   Future<List<PostCardModel>> fetchPosts(PostCardModel? message) async {
//     final postsCollectionRef = FirebaseFirestore.instance.collection('posts');
//
//     if (message == null) {
//       final documentSnapshot = await postsCollectionRef
//           .orderBy('postTimeStamp', descending: true)
//           .limit(5)
//           .get();
//       return documentSnapshot.docs
//           .map((doc) => PostCardModel.fromJson(doc.data()))
//           .toList();
//     } else {
//       final documentSnapshot = await postsCollectionRef
//           .orderBy('postTimeStamp', descending: true)
//           .startAfter([message.postTimeStamp])
//           .limit(5)
//           .get();
//       return documentSnapshot.docs
//           .map((doc) => PostCardModel.fromJson(doc.data()))
//           .toList();
//     }
//   }
// }
