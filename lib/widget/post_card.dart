import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/chat_screen/screens/chat_page.dart';
import '../screens/profile_screen/other_user_profile_page.dart';

class PostCard extends StatelessWidget {
  final String uid, userName, postCategory, postTitle, postText;
  final List<String> likes;
  const PostCard(
      {Key? key,
      required this.uid,
      required this.userName,
      required this.postCategory,
      required this.postTitle,
      required this.postText,
      required this.likes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    void handleClick(String value) {
      switch (value) {
        case '메세지 보내기':
          Get.to(() => const ChatPage(),
              arguments: {'peerUid': uid, 'peerDisplayName': userName});
          break;
        case '신고하기':
          break;
      }
    }

    return Card(
      color: Theme.of(context).colorScheme.onPrimary,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              GestureDetector(
                child: Row(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: const Image(
                          image: AssetImage('assets/user.png'),
                          height: 43,
                          width: 43,
                          fit: BoxFit.scaleDown,
                        )),
                    const SizedBox(
                      width: 12,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(postCategory,
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w800)),
                      ],
                    )
                  ],
                ),
                onTap: () {
                  Get.to(() => OtherUserProfilePage(), arguments: uid);
                },
              ),
              PopupMenuButton<String>(
                onSelected: handleClick,
                itemBuilder: (BuildContext context) {
                  return {'메세지 보내기', '신고하기'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: choice == '신고하기'
                          ? Text(
                              choice,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.error),
                            )
                          : Text(choice),
                    );
                  }).toList();
                },
              ),
            ]),
            const SizedBox(
              height: 10,
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                postTitle,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.92 - 29,
                child: Text(postText),
              ),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite_border),
                ),
                const Text('5'),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.chat_outlined,
                    color: Colors.black,
                  ),
                ),
                const Text('20'),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.bookmark_border,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
