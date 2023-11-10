import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disko_001/features/profile/screens/profile_page.dart';
import 'package:disko_001/features/profile/screens/settings/setting_page.dart';
import 'package:disko_001/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/utils/utils.dart';

class MyProfilePage extends ConsumerStatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends ConsumerState<MyProfilePage> {
  Future signOut() async{
    try {
      print('sign out complete!');
      return
        await FirebaseAuth.instance.signOut();
    } catch (e) {
      print('sign out failed');
      print(e.toString());
      return null;
    }
  }

  void deleteUser() async{
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users.doc(FirebaseAuth.instance.currentUser!.uid).delete();
    FirebaseAuth.instance.currentUser?.delete();
    await signOut();
    print(FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    final UserDataModel user = ref.watch(userDataProvider);
    return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, SettingScreen.routeName,
                          arguments: {'user': user});
                    },
                    icon: const Icon(
                      Icons.settings_outlined,
                      color: Colors.black,
                    )),
              ],
            ),
            body: ProfilePageFrame(
              user: user,
              uid: FirebaseAuth.instance.currentUser!.uid,
            ),
          );
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
