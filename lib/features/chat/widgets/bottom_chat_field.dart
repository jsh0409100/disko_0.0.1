import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../common/enums/message_enum.dart';
import '../../../common/utils/utils.dart';
import '../controller/chat_controller.dart';
import 'message_category_card.dart';

class BottomChatField extends ConsumerStatefulWidget {
  const BottomChatField({Key? key, required this.receiverUid})
      : super(key: key);
  final String receiverUid;

  @override
  ConsumerState<BottomChatField> createState() => _SendMessageState();
}

class _SendMessageState extends ConsumerState<BottomChatField> {
  final controller = TextEditingController();
  bool isShowSendButton = true;
  FlutterSoundRecorder? _soundRecorder;
  bool isRecorderInit = false;
  bool isShowEmojiContainer = false;
  bool isRecording = false;
  FocusNode focusNode = FocusNode();
  final user = FirebaseAuth.instance.currentUser;

  var _userEnterMessage = '';
  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic permission not allowed!');
    }
    await _soundRecorder!.openRecorder();
    isRecorderInit = true;
  }

  void _sendMessage() async {
    // if (isShowSendButton) {
    ref.read(chatControllerProvider).sendTextMessage(
          context,
          _userEnterMessage,
          widget.receiverUid,
        );
    setState(() {
      controller.text = '';
    });
    // } else {
    //   var tempDir = await getTemporaryDirectory();
    //   var path = '${tempDir.path}/flutter_sound.aac';
    //   if (!isRecorderInit) {
    //     return;
    //   }
    //   if (isRecording) {
    //     await _soundRecorder!.stopRecorder();
    //     sendFileMessage(File(path), MessageEnum.audio);
    //   } else {
    //     await _soundRecorder!.startRecorder(
    //       toFile: path,
    //     );
    //   }
    //
    //   setState(() {
    //     isRecording = !isRecording;
    //   });
    // }
  }

  void sendFileMessage(
    File file,
    MessageEnum messageEnum,
  ) {
    ref.read(chatControllerProvider).sendFileMessage(
          context,
          file,
          widget.receiverUid,
          messageEnum,
        );
  }

  void selectImage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  void selectVideo() async {
    File? video = await pickVideoFromGallery(context);
    if (video != null) {
      sendFileMessage(video, MessageEnum.video);
    }
  }

  // void selectGIF() async {
  //   final gif = await pickGIF(context);
  //   if (gif != null) {
  //     ref.read(chatControllerProvider).sendGIFMessage(
  //           context,
  //           gif.url,
  //           widget.receiverUid,
  //         );
  //   }
  // }

  void hideEmojiContainer() {
    setState(() {
      isShowEmojiContainer = false;
    });
  }

  void showEmojiContainer() {
    setState(() {
      isShowEmojiContainer = true;
    });
  }

  void showKeyboard() => focusNode.requestFocus();
  void hideKeyboard() => focusNode.unfocus();

  void toggleEmojiKeyboardContainer() {
    if (isShowEmojiContainer) {
      showKeyboard();
      hideEmojiContainer();
    } else {
      hideKeyboard();
      showEmojiContainer();
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    // _soundRecorder!.closeRecorder();
    isRecorderInit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {},
            ),
            Expanded(
              child: TextField(
                // focusNode: focusNode,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                controller: controller,
                maxLines: null,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  hintText: "메세지 보내기",
                ),
                onChanged: (value) {
                  setState(() {
                    _userEnterMessage = value.trim();
                  });
                },
              ),
            ),
            IconButton(
              onPressed: (_userEnterMessage.trim().isEmpty ||
                      _userEnterMessage.trim() == '')
                  ? null
                  : _sendMessage,
              icon: Icon(
                Icons.send,
                color: _userEnterMessage.trim().isEmpty
                    ? Theme.of(context).colorScheme.outline
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: selectImage,
                        child: const MessageCategoryCard(
                            categoryIcon: Icons.add_photo_alternate_outlined,
                            categoryName: '사진 보내기'),
                      ),
                      const MessageCategoryCard(
                          categoryIcon: Icons.camera_alt_outlined,
                          categoryName: '카메라'),
                      const MessageCategoryCard(
                          categoryIcon: Icons.mic, categoryName: '음성메세지'),
                    ]),
                SizedBox(height: 27),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    MessageCategoryCard(
                        categoryIcon: Icons.location_on_outlined,
                        categoryName: '위치 보내기'),
                    MessageCategoryCard(
                        categoryIcon: Icons.calendar_month_outlined,
                        categoryName: '약속하기'),
                  ],
                ),
              ]),
        )
      ],
    );
  }
}
