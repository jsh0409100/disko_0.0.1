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
            Container(
              height: 130,
              child: GestureDetector(
                child: Stack(children: [
                  image == null
                      ? CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(widget.imageURL),
                        )
                      : CircleAvatar(
                          radius: 60,
                          backgroundImage: FileImage(
                            image!,
                          ),
                        ),
                  Positioned(
                    left: 80,
                    top: 95,
                    child: CircleAvatar(
                      backgroundColor: Color(0xffEFEFEF),
                      radius: 15,
                      child: IconButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileEditPage(
                              displayName: widget.displayName,
                              country: widget.country,
                              description: widget.description,
                              imageURL: widget.imageURL,
                              tag: widget.tag,
                            ),
                          ),
                        ),
                        icon: const Icon(
                          Icons.add_a_photo,
                        ),
                        color: Colors.black,
                      ),
                    ),
                  )
                ]),
                onTap: () {},
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.displayName,
                  style: const TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                Text(
                  widget.country,
                  style: const TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Text(
                  widget.description,
                  style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Container(
                  height: MediaQuery.of(context).size.height/1.8,
                  child: myPost(context),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget myPost(BuildContext context){
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
                }
            );
          }
      ), error:(error, stackTrace) => ErrorText(
      error: error.toString(),
    ),
      loading: () => const LoadingScreen(),
    );
  }

  Widget size() {
    return SizedBox(width: MediaQuery.of(context).size.width * 0.03);
  }
}
