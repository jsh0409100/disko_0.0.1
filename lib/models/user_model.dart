class UserModel {
  final String displayName;
  final String phoneNum;
  final String countryCode;
  final String profilePic;
  final String? email;
  final int diskoPoint;
  final String description;
  final List<String> tag;
  final List<String> follow;

  UserModel({
    required this.profilePic,
    required this.email,
    required this.diskoPoint,
    required this.displayName,
    required this.phoneNum,
    required this.countryCode,
    required this.tag,
    required this.description,
    required this.follow,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : phoneNum = json['phoneNumber'],
        displayName = json['displayName'],
        email = json['email'],
        diskoPoint = json['diskoPoint'],
        profilePic = json['profilePic'],
        countryCode = json['countryCode'],
        description = json['description'],
        tag = json['tag'].cast<String>(),
        follow = json['follow'].cast<String>();

  Map<String, dynamic> toJson() => {
        'displayName': displayName,
        'phoneNumber': phoneNum,
        'email': email,
        'diskoPoint': diskoPoint,
        'countryCode': countryCode,
        'profilePic': profilePic,
        'description': description,
        'tag': tag,
        'follow': follow,
      };
}
