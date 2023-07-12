import 'dart:io';

import 'package:disko_001/common/utils/utils.dart';
import 'package:disko_001/features/auth/controller/auth_controller.dart';
import 'package:disko_001/features/profile/screens/profile_edit_page.dart';
import 'package:disko_001/features/profile/screens/tag_edit_page.dart';
import 'package:disko_001/features/write_post/controller/write_post_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/widgets/error_text.dart';
import '../../../common/widgets/loading_screen.dart';
import '../../home/widgets/post.dart';

class ProfilePage extends ConsumerStatefulWidget {
  final String displayName, country, description, imageURL, uid;
  final List<String> tag;

  const ProfilePage({
    Key? key,
    required this.displayName,
    required this.country,
    required this.description,
    required this.imageURL,
    required this.tag,
    required this.uid,
  }) : super(key: key);

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  String test = 'test';
  File? image;
  final TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void storeUserData() async {
    String name = nameController.text.trim();

    if (name.isNotEmpty) {
      ref.read(authControllerProvider).saveProfileDataToFirebase(
            context,
            name,
            image,
            widget.country,
            widget.tag,
            widget.description,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            topWidget(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Container(
                  height: MediaQuery.of(context).size.height / 1.8,
                  child: myPost(context),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget myPost(BuildContext context) {
    return ref.watch(searchMyPostProvider(widget.uid)).when(
          data: (posts) => ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return FutureBuilder(
                    future: getUserDataByUid(posts[index].uid),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData == false) {
                        return Card(
                          color: Colors.grey.shade300,
                          child: Column(children: [
                            SizedBox(
                              height: 180,
                              width: MediaQuery.of(context).size.width * 0.9,
                            ),
                            const SizedBox(
                              height: 11,
                            )
                          ]),
                        );
                      } else {
                        return Post(
                          post: posts[index],
                        );
                      }
                    });
              }),
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
          loading: () => const LoadingScreen(),
        );
  }

  Widget size() {
    return SizedBox(width: MediaQuery.of(context).size.width * 0.03);
  }

  Widget topWidget(){
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                image == null
                    ? CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(widget.imageURL),
                )
                    : CircleAvatar(
                  radius: 35,
                  backgroundImage: FileImage(
                    image!,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.2, left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      profileNameText(widget.displayName),
                      verEmailText(),
                    ],
                  ),
                ),
                followChip(),
              ],
            ),
            descriptionText(),
          ],
        ),
      ),
    );
  }

  Widget profileText(String name){
    return Text(
      name,
      style: const TextStyle(
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w500,
        fontSize: 12,
      ),
    );
  }

  Widget verEmailText(){
    return const Text(
      '개인정보인증 완료',
      style: TextStyle(
        color: Color(0xFFC4C4C4),
        fontSize: 12,
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget profileNameText(String name){
    return Text(
      name,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 17,
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget descriptionText() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        widget.description,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 12,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget followChip(){
    return ElevatedButton(
        onPressed: (){

        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white54),
          shape : MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            )
          )
        ),
        child: const Text(
          '수정',
          style: TextStyle(color: Colors.black),
        )
    );
  }

}
