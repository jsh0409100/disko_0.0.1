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

  Future<UserModel?> getCurrentUserData() async {
    var userData =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();

    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromJson(userData.data()!);
    }
    return user;
  }

  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          //TODO 여기서 visibility 바꾸는거 생각해보기
          await auth.signInWithCredential(credential);
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
      showSnackBar(context: context, content: e.message!);
    }
  }

  void verifyOTP({
    required BuildContext context,
    required String verificationId,
    required String userOTP,
    required String countryCode,
    required ProviderRef ref,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: userOTP,
      );
      await auth.signInWithCredential(credential);
      saveUserDataToFirebase(
        name: 'guest',
        profilePic: null,
        context: context,
        countryCode: countryCode,
        ref: ref,
        isUserCreated: true,
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  void saveUserDataToFirebase({
    required String name,
    required File? profilePic,
    required String countryCode,
    required ProviderRef ref,
    required BuildContext context,
    required bool isUserCreated,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl =
          'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png';

      if (profilePic != null) {
        photoUrl = await ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storeFileToFirebase('profilePic/$uid', profilePic);
      }

      var user = UserModel(
        phoneNum: auth.currentUser!.phoneNumber!,
        displayName: name,
        countryCode: countryCode,
        profilePic: photoUrl,
        tag: [],
      );

      await firestore.collection('users').doc(uid).set(user.toJson());

      if (isUserCreated) {
        Navigator.pushNamed(
          context,
          LandingPage.routeName,
        );
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppLayoutScreen.routeName,
          (route) => false,
        );
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Stream<UserModel> userData(String userId) {
    return firestore.collection('users').doc(userId).snapshots().map(
          (event) => UserModel.fromJson(
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
    required bool isUserCreated,
    required List<String> tag,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl =
          'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png';

      if (profilePic != null) {
        photoUrl = await ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storeFileToFirebase('profilePic/$uid', profilePic);
      }

      var user = UserModel(
          phoneNum: auth.currentUser!.phoneNumber!,
          displayName: name,
          countryCode: countryCode,
          profilePic: photoUrl,
          tag : tag,
      );

      await firestore.collection('users').doc(uid).set(user.toJson());

      if (isUserCreated) {
        Navigator.pushNamed(
          context,
          LandingPage.routeName,
        );
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppLayoutScreen.routeName,
              (route) => false,
        );
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

}
