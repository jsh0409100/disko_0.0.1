import 'dart:io';

import 'package:disko_001/common/utils/utils.dart';
import 'package:disko_001/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileEditPage extends ConsumerStatefulWidget {
  final String displayName, country, description, imageURL;
  final List<String> tag;
  final List<String> follow;

  const ProfileEditPage({
    Key? key,
    required this.displayName,
    required this.country,
    required this.description,
    required this.imageURL,
    required this.tag,
    required this.follow,
  }) : super(key: key);

  @override
  ConsumerState<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends ConsumerState<ProfileEditPage> {
  String test = 'test';
  File? image;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController keywordController = TextEditingController();



  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    descriptionController.dispose();
    countryController.dispose();
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
            widget.country,
            widget.tag,
            description,
            widget.follow,
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
                          backgroundImage: NetworkImage(widget.imageURL),
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
                  textField("   나라 선택.", "국가", 1, countryController),
                  textField(
                      "   40자 이내여야 합니다.", "자기소개", 10, descriptionController),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget textField(
      String hint, String title, int size, TextEditingController controller) {
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
