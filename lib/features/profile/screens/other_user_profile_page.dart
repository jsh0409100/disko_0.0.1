import 'package:disko_001/common/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../../common/widgets/common_app_bar.dart';
import 'Other_Profile_page.dart';

class OtherUserProfilePage extends StatefulWidget {
  final String uid;

  const OtherUserProfilePage({Key? key, required this.uid}) : super(key: key);

  static const String routeName = 'other-user-profile-screen';

  @override
  State<OtherUserProfilePage> createState() => _OtherUserProfilePageState();
}

class _OtherUserProfilePageState extends State<OtherUserProfilePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUserDataByUid(widget.uid),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData == false) {
            return const Center(child: CircularProgressIndicator());
          }
          return Scaffold(
            appBar: CommonAppBar(
              title: '',
              appBar: AppBar(),
            ),
            body: Other_ProfilePage(
              user: snapshot.data,
              uid: widget.uid,
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
