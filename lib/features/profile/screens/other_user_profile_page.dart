import 'package:disko_001/common/utils/utils.dart';
import 'package:disko_001/features/profile/screens/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/common_app_bar.dart';

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
        future: getUserDataByUid(uid),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData == false) {
            return const Center(child: CircularProgressIndicator());
          }
          return Scaffold(
            appBar: CommonAppBar(
              title: '',
              appBar: AppBar(),
            ),
            body: ProfilePage(
              displayName: snapshot.data.displayName,
              country: '한국',
              description: '안녕하세요! 반가워요!',
              imageURL: snapshot.data.profilePic,
              tag: snapshot.data.tag,
              uid: uid,
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
