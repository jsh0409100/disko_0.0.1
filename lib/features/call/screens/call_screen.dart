import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../config/agora_config.dart';
import '../../../models/call.dart';
import '../controller/call_controller.dart';

class CallScreen extends ConsumerStatefulWidget {
  final String channelId;
  final Call call;
  const CallScreen({
    Key? key,
    required this.channelId,
    required this.call,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CallScreenState();
}

class _CallScreenState extends ConsumerState<CallScreen> {
  String channelName = "test-disko";
  String token = AgoraConfig.token;

  int uid = 0; // uid of the local user

  int? _remoteUid; // uid of the remote user
  bool _isJoined = false; // Indicates if the local user has joined the channel
  late RtcEngine agoraEngine; // Agora engine instance

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>(); // Global key to access the scaffold

  Future<void> setupVideoSDKEngine() async {
    // retrieve or request camera and microphone permissions
    await [Permission.microphone, Permission.camera].request();

    //create an instance of the Agora engine
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(RtcEngineContext(appId: AgoraConfig.appId));

    await agoraEngine.enableVideo();

    // Register the event handler
    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          showMessage(
              "Local user uid:${connection.localUid} joined the channel");
          setState(() {
            _isJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          showMessage("Remote user uid:$remoteUid joined the channel");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          showMessage("Remote user uid:$remoteUid left the channel");
          setState(() {
            _remoteUid = null;
          });
          leaveCall();
        },
      ),
    );
    joinCall();
  }

  @override
  void initState() {
    super.initState();
    // Set up an instance of Agora engine
    setupVideoSDKEngine();
  }

  void joinCall() async {
    await agoraEngine.startPreview();
    print('\n\n\n\n\n\n\n\n\n\n\n\n\nhasdialed: ${widget.call.hasDialed}\n\n\n\n\n\n\n\n\n\n\n\n\n');

    // Set channel options including the client role and channel profile
    ChannelMediaOptions options = ChannelMediaOptions(
      clientRoleType: widget.call.hasDialed
          ? ClientRoleType.clientRoleBroadcaster
          : ClientRoleType.clientRoleAudience,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    );

    await agoraEngine.joinChannel(
      token: token,
      channelId: channelName,
      options: options,
      uid: uid,
    );
  }

  void leaveCall() {
    setState(() {
      _isJoined = false;
      _remoteUid = null;
    });
    agoraEngine.leaveChannel();
  }

  // Release the resources when you leave
  @override
  void dispose() async {
    await agoraEngine.leaveChannel();
    agoraEngine.release();
    super.dispose();
  }

  showMessage(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        // Container for the local video
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: Center(child: _localPreview()),
        ),
        const SizedBox(height: 10),
        //Container for the Remote video
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: Center(child: _remoteVideo()),
        ),
        // Button Row
        Row(
          children: <Widget>[
            Expanded(
              child: IconButton(
                onPressed: _isJoined
                    ? () async {
                        leaveCall();
                        ref.read(callControllerProvider).endCall(
                              widget.call.callerId,
                              widget.call.receiverUid,
                              context,
                            );
                        Navigator.pop(context);
                      }
                    : null,
                icon: const Icon(Icons.call_end),
              ),
            ),
          ],
        ),
        // Button Row ends
      ],
    ));
  }

  Widget _localPreview() {
    if (_isJoined) {
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: agoraEngine,
          canvas: const VideoCanvas(uid: 0),
        ),
      );
    } else {
      return const Text(
        'Joining Channel',
        textAlign: TextAlign.center,
      );
    }
  }

// Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: agoraEngine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: channelName),
        ),
      );
    } else {
      String msg = '';
      if (_isJoined) msg = 'Waiting for a remote user to join';
      return Text(
        msg,
        textAlign: TextAlign.center,
      );
    }
  }
}
