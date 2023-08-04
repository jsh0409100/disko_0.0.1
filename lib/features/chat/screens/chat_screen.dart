import 'package:disko_001/features/chat/controller/chat_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/utils/utils.dart';
import '../../../common/widgets/loading_screen.dart';
import '../../report/report_screen.dart';
import '../widgets/bottom_chat_field.dart';
import '../widgets/message_list.dart';

class ChatScreen extends ConsumerStatefulWidget {
  static const String routeName = '/chat-screen';
  final String peerUid;
  const ChatScreen({
    Key? key,
    required this.peerUid,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatScreen> {
  var currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  @override
  void dispose() {
    super.dispose();
    // print('user left chat');
    // ref.read(chatControllerProvider).toggleUserOnline(context, currentUserUid);
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return Builder(builder: (context) {
          final customTheme = Theme.of(context).copyWith(
            dialogTheme: const DialogTheme(
              backgroundColor: Color(0xFFFFFBFF),
            ),
          );

          return Theme(
            data: customTheme,
            child: AlertDialog(
              title: Text(
                '정말로 이 사용자를 신고하시겠습니까?',
                style: Theme.of(context).textTheme.bodyLarge,
                maxLines: 2,
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        elevation: 2,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      child: Text('아니요',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.white)),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(ReportScreen.routeName, arguments: {
                            'reportedUid': widget.peerUid,
                            'reportedDisplayName': '',
                          });
                        },
                        style: TextButton.styleFrom(
                          elevation: 2,
                          backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        child: Text(
                          '예, 신고할게요',
                          style:
                          Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
                        )),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  void showMenu(String value) {
    switch (value) {
      case '신고하기':
        _showMyDialog();
        break;
      case '차단하기':
        break;
      case '알림끄기':
        break;
      case '채팅방나가기':
        break;
      case '취소':
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.read(chatControllerProvider).setChatMessageSeen(context, widget.peerUid);
    return FutureBuilder(
        future: getUserDataByUid(widget.peerUid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const LoadingScreen();
          }
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(snapshot.data!.profilePic),
                        radius: 20,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(
                        snapshot.data!.displayName,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  actions: [
                    PopupMenuButton<String>(
                      onSelected: showMenu,
                      itemBuilder: (BuildContext context) {
                        return {'신고하기','차단하기','알림끄기','채팅방 나가기'}.map((String choice) {
                          return PopupMenuItem<String>(
                            value: choice,
                            child: choice == '신고하기'
                                ? Text(
                              choice,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.error),
                            )
                                : Text(choice),
                          );
                        }).toList();
                      },
                    ),
                  ],
                  backgroundColor: Colors.white,
                  elevation: 0,
                ),
                body: Column(
                  children: [
                    Expanded(
                        child: ChatMessage(
                      receiverUid: widget.peerUid,
                    )),
                    BottomChatField(
                      receiverUid: widget.peerUid,
                      profilePic: snapshot.data!.profilePic,
                      receiverDisplayName: snapshot.data!.displayName,
                    ),
                  ],
                )),
          );
        });
  }
}
