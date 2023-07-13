import 'package:disko_001/features/profile/screens/profile_page.dart';
import 'package:disko_001/features/profile/screens/setting_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../common/utils/utils.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUserDataByUid(FirebaseAuth.instance.currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData == false) {
            return const Center(child: CircularProgressIndicator());
          }
          return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, SettingScreen.routeName);
                    },
                    icon: const Icon(
                      Icons.settings_outlined,
                      color: Colors.black,
                    )),
              ],
            ),
            body: ProfilePage(
              user: snapshot.data,
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
