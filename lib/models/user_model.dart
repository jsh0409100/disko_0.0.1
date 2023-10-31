import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserDataModel {
  final String displayName;
  final String phoneNum;
  final String countryCode;
  final String profilePic;
  final String? email;
  final int diskoPoint;
  final String description;
  final List<String> tag;
  final List<String> follow;
  final bool hasAuthority;

  UserDataModel({
    required this.profilePic,
    required this.email,
    required this.diskoPoint,
    required this.displayName,
    required this.phoneNum,
    required this.countryCode,
    required this.tag,
    required this.description,
    required this.follow,
    required this.hasAuthority,
  });

  UserDataModel.fromJson(Map<String, dynamic> json)
      : phoneNum = json['phoneNumber'],
        displayName = json['displayName'],
        email = json['email'],
        diskoPoint = json['diskoPoint'],
        profilePic = json['profilePic'],
        countryCode = json['countryCode'],
        description = json['description'],
        tag = json['tag'].cast<String>(),
        hasAuthority = json['hasAuthority'],
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
    'hasAuthority': hasAuthority,
      };
}

class UserDataProvider extends StateNotifier<UserDataModel> {
  UserDataProvider()
      : super(UserDataModel(
          profilePic: '',
          email: '',
          diskoPoint: 0,
          displayName: '',
          phoneNum: '',
          countryCode: '',
          tag: [],
          description: '',
          follow: [],
      hasAuthority: false,
        ));

  void updateUser(UserDataModel userData) {
    state = userData;
  }
}

final userDataProvider = StateNotifierProvider<UserDataProvider, UserDataModel>((ref) {
  return UserDataProvider();
});
