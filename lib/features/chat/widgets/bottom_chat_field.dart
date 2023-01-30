import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  final user = FirebaseAuth.instance.currentUser;

  var _userEnterMessage = '';

  void _sendMessage() async {
    ref.read(chatControllerProvider).sendTextMessage(
          context,
          _userEnterMessage,
          widget.receiverUid,
        );
    controller.clear();

    // final currentChat =
    //     FirebaseFirestore.instance.collection('messages').doc(widget.chatName);
    // final doc = await currentChat.get();
    // (doc.exists)
    //     ? currentChat.update(messageData)
    //     : currentChat.set(messageData);
    // await currentChat.update({"unreadMessageCount": FieldValue.increment(1)});
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
