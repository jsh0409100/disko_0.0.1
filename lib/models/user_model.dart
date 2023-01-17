class UserModel {
  final String displayName;
  final String phoneNum;
  final String countryCode;

  UserModel({
    required this.displayName,
    required this.phoneNum,
    required this.countryCode,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : phoneNum = json['phoneNumber'],
        displayName = json['displayName'],
        countryCode = json['countryCode'];

  Map<String, dynamic> toJson() => {
        'displayName': displayName,
        'phoneNumber': phoneNum,
        'countryCode': countryCode,
      };
}
