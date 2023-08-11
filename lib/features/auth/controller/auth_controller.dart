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

  void verifyOTP(BuildContext context, String verificationId, String userOTP, String countryCode,
      bool itisSignUp) {
    authRepository.verifyOTP(
      context: context,
      verificationId: verificationId,
      userOTP: userOTP,
      countryCode: countryCode,
      ref: ref,
      itis: itisSignUp,
    );
  }

  void saveUserDataToFirebase(
      BuildContext context, String name, File? profilePic, String countryCode, String description, List<String> follow) {
    authRepository.saveUserDataToFirebase(
      name: name,
      profilePic: profilePic,
      context: context,
      ref: ref,
      countryCode: countryCode,
      isUserCreated: false,
      description: description,
      follow: follow,
    );
  }

  void saveProfileDataToFirebase(
      BuildContext context,
      String name,
      File? profilePic,
      String countryCode,
      List<String> tag,
      String description,
      List<String> follow,
      String? email,
      int diskoPoint) {
    authRepository.saveProfileDataToFirebase(
      name: name,
      profilePic: profilePic,
      context: context,
      ref: ref,
      countryCode: countryCode,
      isUserCreated: false,
      tag: tag,
      description: description,
      follow: follow,
      email: email,
      diskoPoint: diskoPoint,
    );
  }

  Stream<UserModel> userDataById(String userId) {
    return authRepository.userData(userId);
  }

  void setUserState(bool isOnline) {
    authRepository.setUserState(isOnline);
  }
}
