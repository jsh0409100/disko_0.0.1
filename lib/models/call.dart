class Call {
  final String callerId;
  final String callerName;
  final String callerPic;
  final String receiverUid;
  final String receiverName;
  final String receiverPic;
  final String token;
  final String callId;
  final bool hasDialed;
  Call({
    required this.callerId,
    required this.callerName,
    required this.callerPic,
    required this.receiverUid,
    required this.receiverName,
    required this.receiverPic,
    required this.callId,
    required this.hasDialed,
    required this.token,
  });

  Map<String, dynamic> toJson() {
    return {
      'callerId': callerId,
      'callerName': callerName,
      'callerPic': callerPic,
      'receiverUid': receiverUid,
      'receiverName': receiverName,
      'receiverPic': receiverPic,
      'callId': callId,
      'hasDialed': hasDialed,
      'token': token,
    };
  }

  factory Call.fromJson(Map<String, dynamic> map) {
    return Call(
      callerId: map['callerId'] ?? '',
      callerName: map['callerName'] ?? '',
      callerPic: map['callerPic'] ?? '',
      receiverUid: map['receiverUid'] ?? '',
      receiverName: map['receiverName'] ?? '',
      receiverPic: map['receiverPic'] ?? '',
      callId: map['callId'] ?? '',
      token: map['token'] ?? '',
      hasDialed: map['hasDialed'] ?? false,
    );
  }
}
