import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disko_001/features/profile/screens/profile_page.dart';
import 'package:disko_001/features/starting/start_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../common/utils/utils.dart';
import '../../../common/widgets/common_app_bar.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
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
                    onPressed:(){},
                    icon: const Icon(
                      Icons.settings_outlined,
                      color: Colors.black,
                    )
                ),
              ],
            ),
            body: ProfilePage(
              displayName: snapshot.data.displayName,
              country: '한국',
              description: snapshot.data.description,
              imageURL: snapshot.data.profilePic,
              tag: snapshot.data.tag,
              uid: FirebaseAuth.instance.currentUser!.uid,
              follow : snapshot.data.follow,

            ),
            drawer: Drawer(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text('로그아웃'),
                    onTap: () async{
                      await signOut();
                      Navigator.pushAndRemoveUntil(
                          context, MaterialPageRoute(
                          builder: (BuildContext context) =>
                              StartPage(itisSignUp: false,)), (route) => false
                      );
                    },
                    trailing: Icon(
                      Icons.arrow_forward_sharp,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text('탈퇴하기'),
                    onTap: () async{
                      showDialog(
                        context: context,
                        barrierDismissible: true, //바깥 영역 터치시 닫을지 여부 결정
                        builder: ((context) {
                          return AlertDialog(
                            title: Text("탈퇴"),
                            content: Text("정말로 탈퇴하시겠습니까?"),
                            actions: <Widget>[
                              Container(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); //창 닫기
                                  },
                                  child: Text("아니요"),
                                ),
                              ),
                              Container(
                                child: ElevatedButton(
                                  onPressed: () {
                                    deleteUser();
                                    Navigator.pushAndRemoveUntil(
                                        context, MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            StartPage(itisSignUp: false,)), (route) => false
                                    ); //창 닫기
                                  },
                                  child: Text("네"),
                                ),
                              ),
                            ],
                          );
                        }),
                      );
                    },
                    trailing: Icon(
                      Icons.arrow_forward_sharp,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
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
