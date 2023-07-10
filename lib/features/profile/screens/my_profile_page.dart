import 'package:disko_001/features/profile/screens/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../common/utils/utils.dart';
import '../../../common/widgets/common_app_bar.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
        future: getUserDataByUid(FirebaseAuth.instance.currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData == false) {
            return const Center(child: CircularProgressIndicator());
          }
          return Scaffold(
            appBar: CommonAppBar(
              title: '내 프로필',
              appBar: AppBar(),
            ),
            body: ProfilePage(
              displayName: snapshot.data.displayName,
              country: '한국',
              description: '안녕하세요! 반가워요!',
              imageURL: snapshot.data.profilePic,
              tag: snapshot.data.tag,
              uid: FirebaseAuth.instance.currentUser!.uid,
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
