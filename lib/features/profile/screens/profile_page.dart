import 'dart:io';

import 'package:disko_001/common/utils/utils.dart';
import 'package:disko_001/features/auth/controller/auth_controller.dart';
import 'package:disko_001/features/profile/screens/profile_edit_page.dart';
import 'package:disko_001/features/profile/screens/tag_edit_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends ConsumerStatefulWidget {
  final String displayName, country, description, imageURL;
  final List<String> tag;

  const ProfilePage({
    Key? key,
    required this.displayName,
    required this.country,
    required this.description,
    required this.imageURL,
    required this.tag,
  }) : super(key: key);

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  String test = 'test';
  File? image;
  final TextEditingController nameController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
      key: _scaffoldKey,
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
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            FutureBuilder(
                future:
                getUserDataByUid(FirebaseAuth.instance.currentUser!.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Wrap(
                      spacing: MediaQuery.of(context).size.width * 0.03,
                      runSpacing: MediaQuery.of(context).size.width * 0.001,
                      children: List.generate(widget.tag.length, (index) {
                        return index + 1 == widget.tag.length
                            ? Wrap(
                          children: [
                            mChip(widget.tag[index]),
                            IconButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TagEditPage(
                                    displayName: widget.displayName,
                                    country: widget.country,
                                    description: widget.description,
                                    imageURL: widget.imageURL,
                                    tag: widget.tag,
                                  ),
                                ),
                              ),
                              icon: const Icon(Icons.add_circle_outline),
                            ),
                          ],
                        )
                            : mChip(widget.tag[index]);
                      }),
                    );
                  }
                  return size();
                }),
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
            ElevatedButton(
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              child: const Text(
                  '설정'
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget mChip(String text) {
    return Chip(
      label: Text(text),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(
          color: Colors.black,
          width: 1,
        ),
      ),
    );
  }

  Widget size() {
    return SizedBox(width: MediaQuery.of(context).size.width * 0.03);
  }
}
