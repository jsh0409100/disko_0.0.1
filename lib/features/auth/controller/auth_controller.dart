import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/user_model.dart';
import '../repository/auth_repository.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository, ref: ref);
});

final userDataAuthProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getUserData();
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;
  AuthController({
    required this.authRepository,
    required this.ref,
  });

  Future<UserModel?> getUserData() async {
    UserModel? user = await authRepository.getCurrentUserData();
    return user;
  }

  void signInWithPhone(BuildContext context, String phoneNumber) {
    authRepository.signInWithPhone(context, phoneNumber);
  }

  void verifyOTP(BuildContext context, String verificationId, String userOTP,
      String countryCode) {
    authRepository.verifyOTP(
      context: context,
      verificationId: verificationId,
      userOTP: userOTP,
      countryCode: countryCode,
      ref: ref,
    );
  }

  void saveUserDataToFirebase(
      BuildContext context, String name, File? profilePic, String countryCode) {
    authRepository.saveUserDataToFirebase(
      name: name,
      profilePic: profilePic,
      context: context,
      ref: ref,
      countryCode: countryCode,
      isUserCreated: false,
    );
  }

  void saveProfileDataToFirebase(
      BuildContext context, String name, File? profilePic, String countryCode, String tag) {
    authRepository.saveProfileDataToFirebase(
      name: name,
      profilePic: profilePic,
      context: context,
      ref: ref,
      countryCode: countryCode,
      isUserCreated: false,
      tag: tag,
    );
  }

  Stream<UserModel> userDataById(String userId) {
    return authRepository.userData(userId);
  }

  void setUserState(bool isOnline) {
    authRepository.setUserState(isOnline);
  }
}
