class UserModel {
  final String name;
  final String phoneNum;
  final String uid;
  final String countryCode;

  UserModel({
    required this.name,
    required this.phoneNum,
    required this.countryCode,
    required this.uid,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : phoneNum = json['phone_number'],
        name = json['name'],
        uid = json['uid'],
        countryCode = json['countryCode'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone_number': phoneNum,
        'uid': uid,
        'countryCode': countryCode,
      };
}
