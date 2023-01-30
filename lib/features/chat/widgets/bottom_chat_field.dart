import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';

import '../../../common/enums/message_enum.dart';
import '../../../common/utils/utils.dart';
import '../controller/chat_controller.dart';

class BottomChatField extends ConsumerStatefulWidget {
  const BottomChatField({Key? key, required this.receiverUid})
      : super(key: key);
  final String receiverUid;

  @override
  ConsumerState<BottomChatField> createState() => _SendMessageState();
}

class _SendMessageState extends ConsumerState<BottomChatField> {
  final controller = TextEditingController();
  bool isShowSendButton = false;
  FlutterSoundRecorder? _soundRecorder;
  bool isRecorderInit = false;
  bool isShowEmojiContainer = false;
  bool isRecording = false;
  FocusNode focusNode = FocusNode();
  final user = FirebaseAuth.instance.currentUser;

  var _userEnterMessage = '';

  void _sendMessage() async {
    if (isShowSendButton) {
      ref.read(chatControllerProvider).sendTextMessage(
            context,
            _userEnterMessage,
            widget.receiverUid,
          );
      controller.clear();
    } else {
      var tempDir = await getTemporaryDirectory();
      var path = '${tempDir.path}/flutter_sound.aac';
      if (!isRecorderInit) {
        return;
      }
      if (isRecording) {
        await _soundRecorder!.stopRecorder();
        sendFileMessage(File(path), MessageEnum.audio);
      } else {
        await _soundRecorder!.startRecorder(
          toFile: path,
        );
      }

      setState(() {
        isRecording = !isRecording;
      });
    }
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

  void selectGIF() async {
    final gif = await pickGIF(context);
    if (gif != null) {
      ref.read(chatControllerProvider).sendGIFMessage(
            context,
            gif.url,
            widget.receiverUid,
          );
    }
  }

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
    _soundRecorder!.closeRecorder();
    isRecorderInit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {},
        ),
        Expanded(
          child: TextField(
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            controller: controller,
            maxLines: null,
            decoration: const InputDecoration(
              isDense: true,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              // suffixIcon: Container(
              //   padding: const EdgeInsets.all(0.0),
              //   width: 24,
              //   child: IconButton(
              //     constraints: const BoxConstraints(),
              //     padding: EdgeInsets.zero,
              //     onPressed: () {},
              //     icon: const Icon(
              //       Icons.emoji_emotions_outlined,
              //     ),
              //   ),
              // ),
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
          onPressed: _userEnterMessage.trim().isEmpty ? null : _sendMessage,
          icon: Icon(
            Icons.send,
            color: _userEnterMessage.trim().isEmpty
                ? Theme.of(context).colorScheme.outline
                : Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
