import 'dart:io';

import 'package:disko_001/common/utils/utils.dart';
import 'package:disko_001/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TagEditPage extends ConsumerStatefulWidget {
  final String displayName, country, description, imageURL;
  final List<String> tag;

  const TagEditPage({
    Key? key,
    required this.displayName,
    required this.country,
    required this.description,
    required this.imageURL,
    required this.tag,
  }) : super(key: key);

  @override
  ConsumerState<TagEditPage> createState() => _TagEditPageState();
}

class _TagEditPageState extends ConsumerState<TagEditPage> {

  final TextEditingController ImojiController = TextEditingController();
  final TextEditingController tagController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    ImojiController.dispose();
    tagController.dispose();
  }

  void storeUserData() async {

    File? image;

    if (widget.displayName.isNotEmpty) {
      ref.read(authControllerProvider).saveProfileDataToFirebase(
        context,
        widget.displayName,
        image,
        widget.country,
        widget.tag,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("키워드 선택하기"),
      ),
      body: Column(
        children: [
          Text("새로 추가할 키워드를 입력해보세요."),
          Row(
            children: [

            ],
          ),
        ],
      ),
    );
  }
}
