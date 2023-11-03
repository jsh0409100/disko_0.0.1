import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disko_001/common/repositories/common_firebase_storage_repository.dart';
import 'package:disko_001/features/starting/landing_pages/landing_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app_layout_screen.dart';
import '../../../common/utils/utils.dart';
import '../../../models/user_model.dart';
import '../screens/signup_page.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  ),
);

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository({
    required this.auth,
    required this.firestore,
  });

  Future<UserDataModel?> getCurrentUserData() async {
    var userData = await firestore.collection('users').doc(auth.currentUser?.uid).get();

    UserDataModel? user;
    if (userData.data() != null) {
      user = UserDataModel.fromJson(userData.data()!);
    }
    return user;
  }


  void signInWithPhone(BuildContext context, ProviderRef ref, String phoneNumber,
      String countryCode, bool isSignUp) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: '+${countryCode}$phoneNumber',
        timeout: const Duration(seconds: 120),
        verificationCompleted: (PhoneAuthCredential credential) async {
            await auth.signInWithCredential(credential);

            showSnackBar(context: context, content: "인증이 완료되었습니다!");

            createUserAndNavigate(
              context: context,
              countryCode: countryCode,
              ref: ref,
              isSignUp: isSignUp,
            );
        },
        verificationFailed: (e) {
          throw Exception(e.message);
        },
        codeSent: ((String verificationId, int? resendToken) async {
          SignUpScreen.verificationId = verificationId;
        }),
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      // showSnackBar(context: context, content: e.message!);
    }
  }

  void verifyOTP({
    required BuildContext context,
    required String verificationId,
    required String userOTP,
    required String countryCode,
    required ProviderRef ref,
    required bool isSignUp,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: userOTP,
      );
      await auth.signInWithCredential(credential);
      createUserAndNavigate(
        context: context,
        countryCode: countryCode,
        ref: ref,
        isSignUp: isSignUp,
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  Future<void> createUserAndNavigate({
    required BuildContext context,
    required String countryCode,
    required ProviderRef ref,
    required bool isSignUp,
  }) async {
    String photoUrl =
        'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png';

    if (isSignUp) {
      var user = UserDataModel(
        phoneNum: auth.currentUser!.phoneNumber!,
        displayName: '신규 유저',
        countryCode: countryCode,
        profilePic: photoUrl,
        email: null,
        diskoPoint: 0,
        tag: [],
        description: ' ',
        follow: [],
        hasAuthority: false,
      );

      ref.read(userDataProvider.notifier).updateUser(user);

      saveUserDataToFirebase(
        context: context,
        ref: ref,
        isUserCreated: true,
        user: user,
      );
    }
    else {
      final UserDataModel? user = await ref.read(authRepositoryProvider).getCurrentUserData();
      ref.read(userDataProvider.notifier).updateUser(user!);

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppLayoutScreen.routeName,
        (route) => false,
      );
    }
  }

  void saveUserDataToFirebase(
      {required ProviderRef ref,
      required BuildContext context,
      required UserDataModel user,
      required bool isUserCreated}) async {
    try {
      String uid = auth.currentUser!.uid;
      await firestore.collection('users').doc(uid).set(user.toJson());
      ref.read(userDataProvider.notifier).updateUser(user);
      if (isUserCreated) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          LandingPage.routeName,
          (route) => false,
        );
      }
    } catch (e) {
      // showSnackBar(context: context, content: e.toString());
    }
  }

  // void saveloginUserDataToFirebase({
  //   required String name,
  //   required File? profilePic,
  //   required String countryCode,
  //   required ProviderRef ref,
  //   required BuildContext context,
  //   required bool isUserCreated,
  //   required String description,
  //   required String email,
  //   required int diskoPoint,
  // }) async {
  //   try {
  //     String uid = auth.currentUser!.uid;
  //     String photoUrl =
  //         'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png';
  //
  //     var user = UserModel(
  //       phoneNum: auth.currentUser!.phoneNumber!,
  //       displayName: name,
  //       countryCode: countryCode,
  //       profilePic: photoUrl,
  //       tag: [],
  //       description: description,
  //       follow: [],
  //       email: email,
  //       diskoPoint: diskoPoint,
  //     );
  //     await firestore.collection('users').doc(uid).set(user.toJson());
  //
  //     if (isUserCreated) {
  //       Navigator.pushNamedAndRemoveUntil(
  //         context,
  //         LandingPage.routeName,
  //         (route) => false,
  //       );
  //     } else {
  //       Navigator.pushNamedAndRemoveUntil(
  //         context,
  //         AppLayoutScreen.routeName,
  //         (route) => false,
  //       );
  //     }
  //   } catch (e) {
  //     //showSnackBar(context: context, content: e.toString());
  //   }
  // }

  Stream<UserDataModel> userData(String userId) {
    return firestore.collection('users').doc(userId).snapshots().map(
          (event) => UserDataModel.fromJson(
            event.data()!,
          ),
        );
  }

  void setUserState(bool isOnline) async {
    await firestore.collection('users').doc(auth.currentUser!.uid).update({
      'isOnline': isOnline,
    });
  }

  void saveProfileDataToFirebase({
    required String name,
    required File? profilePic,
    required String countryCode,
    required ProviderRef ref,
    required BuildContext context,
    required String? email,
    required int diskoPoint,
    required bool isUserCreated,
    required List<String> tag,
    required String description,
    required List<String> follow,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl =
          'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png';

      if (profilePic != null) {
        photoUrl = await ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storeFileToFirebase('profilePic/$uid', profilePic);
      } else {
        DocumentSnapshot doc = await firestore.collection('users').doc(auth.currentUser!.uid).get();
        photoUrl = (doc.data() as Map<String, dynamic>)['profilePic'];
      }

      var user = UserDataModel(
        phoneNum: auth.currentUser!.phoneNumber!,
        displayName: name,
        countryCode: countryCode,
        profilePic: photoUrl,
        email: email,
        diskoPoint: diskoPoint,
        tag: tag,
        description: description,
        follow: follow,
        hasAuthority: false,
      );

      await firestore.collection('users').doc(uid).set(user.toJson());
      ref.read(userDataProvider.notifier).updateUser(user);
      if (isUserCreated) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          LandingPage.routeName,
          (route) => false,
        );
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppLayoutScreen.routeName,
          (route) => false,
        );
      }
    } catch (e) {
      // showSnackBar(context: context, content: e.toString());
    }
  }
}
