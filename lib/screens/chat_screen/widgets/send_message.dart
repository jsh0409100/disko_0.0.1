import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disko_001/models/chat_message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SendMessage extends StatefulWidget {
  const SendMessage({Key? key, required this.collectionPath}) : super(key: key);
  final String collectionPath;

  @override
  State<SendMessage> createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  final controller = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;
  var _userEnterMessage = '';
  void _sendMessage() {
    FocusScope.of(context).unfocus();
    FirebaseFirestore.instance
        .collection(widget.collectionPath)
        .add(ChatMessageModel(
          time: Timestamp.now(),
          senderId: user!.uid,
          message: _userEnterMessage,
        ).toJson());
    controller.clear();
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
            controller: controller,
            maxLines: null,
            decoration: InputDecoration(
              suffixIcon: Container(
                padding: const EdgeInsets.all(0.0),
                width: 24,
                child: IconButton(
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                  onPressed: () {},
                  icon: const Icon(
                    Icons.emoji_emotions_outlined,
                  ),
                ),
              ),
              border: const OutlineInputBorder(),
              hintText: "메세지 보내기",
            ),
            onChanged: (value) {
              setState(() {
                _userEnterMessage = value;
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
