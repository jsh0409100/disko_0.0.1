import 'dart:async';
import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
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
  String token = AgoraConfig.token;
  int tokenRole = 1; // use 1 for Host/Broadcaster, 2 for Subscriber/Audience
  String serverUrl = "https://agora-token-server-9n6o.onrender.com";
  int tokenExpireTime = 45; // Expire time in Seconds.
  bool isTokenExpiring = false; // Set to true when the token is about to expire
  String channelName = "disko-call";
  int uid = 0; // uid of the local user
  bool isMuted = false;
  bool isVideoHide = false;
  final user = FirebaseAuth.instance.currentUser;
  bool isCaller = true;

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
          showMessage("Local user uid:${connection.localUid} joined the channel");
          setState(() {});
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          setState(() {
            _remoteUid = remoteUid;
            _isJoined = true;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
          showMessage("Remote user uid:$remoteUid left the channel");
          setState(() {
            _remoteUid = null;
          });
          leaveCall();
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Set up an instance of Agora engine
    initializeAgora();
  }

  Future<void> initializeAgora() async {
    await setupVideoSDKEngine();
    widget.call.hasDialed ? fetchToken(uid, channelName, tokenRole) : setToken(widget.call.token);
  }

  void joinCall(String token) async {
    await agoraEngine.startPreview();

    // Set channel options including the client role and channel profile
    ChannelMediaOptions options = const ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
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
    ref.read(callControllerProvider).endCall(
          widget.call.callerId,
          widget.call.receiverUid,
          context,
        );
    agoraEngine.leaveChannel();
    Navigator.pop(context);
  }

  // Release the resources when you leave
  @override
  void dispose() async {
    super.dispose();
    await agoraEngine.leaveChannel();
    agoraEngine.release();
  }

  Future<void> fetchToken(int uid, String channelName, int tokenRole) async {
    // Prepare the Url
    String url =
        '${serverUrl}/rtc/$channelName/${tokenRole.toString()}/uid/${uid.toString()}/?expiry=${tokenExpireTime.toString()}';
    // Send the request
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // If the server returns an OK response, then parse the JSON.
      Map<String, dynamic> json = jsonDecode(response.body);
      String newToken = json['rtcToken'];
      // Use the token to join a channel or renew an expiring token
      setToken(newToken);
    } else {
      // If the server did not return an OK response,
      // then throw an exception.
      throw Exception('Failed to fetch a token. Make sure that your server URL is valid');
    }
  }

  void setToken(String newToken) async {
    if (isTokenExpiring) {
      // Renew the token
      agoraEngine.renewToken(newToken);
      isTokenExpiring = false;
    } else {
      // Join a channel.
      joinCall(newToken);
    }
    ref.read(callControllerProvider).setToken(newToken, widget.call);
  }

  showMessage(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  void toggleMute() {
    if (isMuted) {
      agoraEngine.disableAudio();
    } else {
      agoraEngine.enableAudio();
    }
    setState(() {
      isMuted = !isMuted;
    });
  }

  void toggleVideoCam() {
    if (isVideoHide) {
      agoraEngine.disableVideo();
    } else {
      agoraEngine.enableVideo();
    }
    setState(() {
      isVideoHide = !isVideoHide;
    });
  }

  void switchCam() {
    agoraEngine.switchCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        // Container for the local video
        Expanded(
          flex: 5,
          child: isVideoHide ? const Center() : Center(child: _localPreview()),
        ),
        const SizedBox(height: 10),
        //Container for the Remote video
        Expanded(
          flex: 5,
          child: Center(child: _remoteVideo()),
        ),
        // Button Row
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: [
                  IconButton(
                    onPressed: toggleVideoCam,
                    icon: isVideoHide
                        ? const Icon(Icons.videocam_off_outlined)
                        : const Icon(Icons.videocam_outlined),
                  ),
                  IconButton(
                    onPressed: toggleMute,
                    icon: isMuted ? const Icon(Icons.mic_off_outlined) : const Icon(Icons.mic),
                  ),
                  IconButton(
                    onPressed: switchCam,
                    icon: const Icon(Icons.cached_outlined),
                  ),
                ],
              ),
              IconButton(
                onPressed: leaveCall,
                icon: const Icon(Icons.call_end),
              ),
            ],
          ),
        ),
      ],
    ));
  }

  Widget _localPreview() {
    isCaller = (user!.uid == widget.call.callerId);
    if (_isJoined) {
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: agoraEngine,
          canvas: const VideoCanvas(uid: 0),
        ),
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: isCaller
                  ? NetworkImage(widget.call.receiverPic)
                  : NetworkImage(widget.call.callerPic),
            ),
            Text(
              isCaller ? widget.call.receiverName : widget.call.callerName,
              textAlign: TextAlign.center,
            ),
            const Text(
              "전화 연결 중",
              textAlign: TextAlign.center,
            ),
          ],
        ),
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
      if (_isJoined) msg = '상대방이 들어오는 중입니다.';
      return Text(
        msg,
        textAlign: TextAlign.center,
      );
    }
  }
}
