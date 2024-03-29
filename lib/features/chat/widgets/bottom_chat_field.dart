import 'dart:io';

import 'package:animate_icons/animate_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../common/enums/message_enum.dart';
import '../../../common/utils/local_notification.dart';
import '../../../common/utils/utils.dart';
import '../../../models/user_model.dart';
import '../../call/controller/call_controller.dart';
import '../controller/chat_controller.dart';
import '../screens/make_appointment_screen.dart';
import '../screens/send_location_screen.dart';
import 'message_category_card.dart';

class BottomChatField extends ConsumerStatefulWidget {
  BottomChatField({
    Key? key,
    required this.receiverUid,
    required this.profilePic,
    required this.receiverDisplayName,
    required this.user,
    // required this.isUploading,
    required this.uploadedFileURL,
    // required this.saveisUploading,
    required this.scrollToBottom,
  }) : super(key: key);
  final String receiverUid, profilePic, receiverDisplayName;
  final UserDataModel user;
  // final Function(bool) saveisUploading;
  final Function() scrollToBottom;
  // bool isUploading = false;
  String uploadedFileURL = '';

  @override
  ConsumerState<BottomChatField> createState() => _SendMessageState();
}

class _SendMessageState extends ConsumerState<BottomChatField> {
  final controller = TextEditingController();
  bool isShowSendButton = true;
  FlutterSoundRecorder? _soundRecorder;
  bool isRecorderInit = false;
  bool isShowOptionsContainer = false;
  bool isRecording = false;
  FocusNode focusNode = FocusNode();
  late AnimateIconController animatedController;
  late final NotificationService notificationService;

  var _userEnterMessage = '';

  @override
  void initState() {
    animatedController = AnimateIconController();
    focusNode.addListener(onFocusChange);
    notificationService = NotificationService();
    notificationService.initializePlatformNotifications();
    super.initState();
  }

  void onFocusChange() {
    if (focusNode.hasFocus) hideOptionsContainer();
  }

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
    notificationService.sendChatNotification(
      senderDisplayName: widget.user.displayName,
      receiverId: widget.receiverUid,
      notificationBody: _userEnterMessage,
    );
    setState(() {
      controller.clear();
      _userEnterMessage = '';
    });
  }

  void sendFileMessage(
    File file,
    MessageEnum messageEnum,
  ) {
    showSnackBar(context: context, content: "file is being sent");
    ref.read(chatControllerProvider).sendFileMessage(
          context,
          file,
          widget.receiverUid,
          messageEnum,
          // widget.saveisUploading,
        );
    notificationService.sendChatNotification(
      senderDisplayName: widget.user.displayName,
      receiverId: widget.receiverUid,
      notificationBody: messageEnum.toString(),
    );
  }

  void selectImage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      // setState(() {
      //   widget.saveisUploading(true);
      // });
      sendFileMessage(image, MessageEnum.image);
    }
  }

  void selectVideo() async {
    File? video = await pickVideoFromGallery(context);
    if (video != null) {
      // setState(() {
      //   widget.saveisUploading(true);
      // });
      showSnackBar(context: context, content: "Image is being sent");

      sendFileMessage(video, MessageEnum.video);
    }
  }

  void takePhoto() async {
    File? image = await pickImageFromCamera(context);
    if (image != null) {
      // setState(() {
      //   widget.saveisUploading(true);
      // });
      showSnackBar(context: context, content: "Image is being sent");
      sendFileMessage(image, MessageEnum.image);
    }
  }

  void showMap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SendLocationMapScreen(
          receiverUid: widget.receiverUid,
        ),
      ),
    );
  }

  void makeAppointment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MakeAppointmentScreen(),
        fullscreenDialog: true,
      ),
    );
  }

  void hideOptionsContainer() {
    setState(() {
      isShowOptionsContainer = false;
    });
  }

  void showOptionsContainer() {
    setState(() {
      isShowOptionsContainer = true;
    });
  }

  void makeCall(WidgetRef ref, BuildContext context) {
    ref.read(callControllerProvider).makeCall(
          context,
          widget.receiverDisplayName,
          widget.receiverUid,
          widget.profilePic,
        );
  }

  void showKeyboard() => focusNode.requestFocus();

  void hideKeyboard() => focusNode.unfocus();

  void toggleOptionsContainer() {
    if (isShowOptionsContainer) {
      hideOptionsContainer();
    } else {
      hideKeyboard();
      showOptionsContainer();
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
              onPressed: () {
                toggleOptionsContainer();
              },
            ),
            Expanded(
              child: TextField(
                focusNode: focusNode,
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
        Visibility(
          visible: isShowOptionsContainer,
          child: Padding(
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
                        GestureDetector(
                          onTap: selectVideo,
                          child: const MessageCategoryCard(
                              categoryIcon: Icons.video_file_outlined,
                              categoryName: '영상 보내기'),
                        ),
                        GestureDetector(
                          onTap: takePhoto,
                          child: const MessageCategoryCard(
                              categoryIcon: Icons.camera_alt_outlined,
                              categoryName: '카메라'),
                        ),
                      ]),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // const MessageCategoryCard(categoryIcon: Icons.mic, categoryName: '음성메세지'),
                      GestureDetector(
                        onTap: () => makeCall(ref, context),
                        child: const MessageCategoryCard(
                            categoryIcon: Icons.video_call_outlined, categoryName: '영상통화'),
                      ),
                      GestureDetector(
                        onTap: showMap,
                        child: const MessageCategoryCard(
                            categoryIcon: Icons.location_on_outlined, categoryName: '위치 보내기'),
                      ),
                      // GestureDetector(
                      //   onTap: makeAppointment,
                      //   child: const MessageCategoryCard(
                      //       categoryIcon: Icons.location_on_outlined, categoryName: '약속 잡기'),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ]),
          ),
        )
      ],
    );
  }
}
