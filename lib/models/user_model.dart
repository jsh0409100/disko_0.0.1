class UserModel {
  final String name;
  final String phoneNum;
  final String countryCode;

  UserModel({
    required this.name,
    required this.phoneNum,
    required this.countryCode,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : phoneNum = json['phoneNumber'],
        name = json['name'],
        countryCode = json['countryCode'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'phoneNumber': phoneNum,
        'countryCode': countryCode,
      };
}
