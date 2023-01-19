import 'package:disko_001/screens/profile_screen/profile_page.dart';
import 'package:disko_001/src/tools.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtherUserProfilePage extends StatefulWidget {
  const OtherUserProfilePage({Key? key}) : super(key: key);

  @override
  State<OtherUserProfilePage> createState() => _OtherUserProfilePageState();
}

class _OtherUserProfilePageState extends State<OtherUserProfilePage> {
  String uid = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getDisplayNameByUid(uid),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData == false) {
            return const Center(child: CircularProgressIndicator());
          }
          return Scaffold(
            body: ProfilePage(
              displayName: snapshot.data.toString(),
              country: '이스라엘',
              description: '안녕하세요! 이스라엘 거주중 엥뿌삐 올리비아 입니다',
            ),
          );
        });
  }

  Widget mirrorballbuilder() {
    return Container(
      child: const Text('mirrorball'),
    );
  }

  Widget Mypost() {
    return Container(
      child: const Text('My post'),
    );
  }

  Widget QandA() {
    return Container(
      child: const Text('Q and A'),
    );
  }

  Widget Followings() {
    return const Text('Followings');
  }
}
