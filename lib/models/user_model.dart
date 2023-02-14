class UserModel {
  final String displayName;
  final String phoneNum;
  final String countryCode;
  final String profilePic;
  final String tag;

  UserModel({
    required this.profilePic,
    required this.displayName,
    required this.phoneNum,
    required this.countryCode,
    required this.tag,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : phoneNum = json['phoneNumber'],
        displayName = json['displayName'],
        profilePic = json['profilePic'],
        countryCode = json['countryCode'],
        tag = json['tag'];

  Map<String, dynamic> toJson() => {
    'displayName': displayName,
    'phoneNumber': phoneNum,
    'countryCode': countryCode,
    'profilePic': profilePic,
    'tag': tag,
  };
}