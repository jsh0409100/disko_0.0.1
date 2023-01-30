class UserModel {
  final String displayName;
  final String phoneNum;
  final String countryCode;
  final String profilePic;

  UserModel({
    required this.profilePic,
    required this.displayName,
    required this.phoneNum,
    required this.countryCode,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : phoneNum = json['phoneNumber'],
        displayName = json['displayName'],
        profilePic = json['profilePic'],
        countryCode = json['countryCode'];

  Map<String, dynamic> toJson() => {
        'displayName': displayName,
        'phoneNumber': phoneNum,
        'countryCode': countryCode,
        'profilePic': profilePic,
      };
}
