import 'dart:io';

import 'package:disko_001/common/utils/utils.dart';
import 'package:disko_001/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/user_model.dart';

class ProfileEditPage extends ConsumerStatefulWidget {
  static const String routeName = 'profile-edit-screen';
  final UserDataModel user;

  const ProfileEditPage({
    required this.user,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends ConsumerState<ProfileEditPage> {
  String test = 'test';
  File? image;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController keywordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.user.displayName;
    descriptionController.text = widget.user.description;
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    descriptionController.dispose();
    keywordController.dispose();
  }

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void storeUserData() async {
    String name = nameController.text.trim();
    String description = descriptionController.text.trim();

    if (name.isNotEmpty) {
      ref.read(authControllerProvider).saveProfileDataToFirebase(
            context,
            name,
            image,
            widget.user.countryCode,
            widget.user.tag,
            description,
            widget.user.follow,
            widget.user.email,
            widget.user.diskoPoint,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("프로필 수정"),
        actions: <Widget>[
          TextButton(
            onPressed: storeUserData,
            child: const Text("완료"),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 130,
                child: GestureDetector(
                  child: image == null
                      ? CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(widget.user.profilePic),
                        )
                      : CircleAvatar(
                          radius: 60,
                          backgroundImage: FileImage(
                            image!,
                          ),
                        ),
                  onTap: () {},
                ),
              ),
              TextButton(
                onPressed: selectImage,
                child: const Text("사진변경"),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textField("   2~8자 이내여야 합니다.", "사용자 이름", 1, nameController),
                  textField("   40자 이내여야 합니다.", "자기소개", 10, descriptionController),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget textField(String hint, String title, int size, TextEditingController controller) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: TextFormField(
            controller: controller,
            cursorColor: Colors.black54,
            maxLines: size,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 5),
              hintText: hint,
              hintStyle: const TextStyle(
                color: Colors.black54,
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black54,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                color: Colors.black54,
              )),
            ),
          ),
        ),
      ],
    );
  }
}
