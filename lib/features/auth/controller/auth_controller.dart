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

  Future<UserDataModel?> getUserData() async {
    UserDataModel? user = await authRepository.getCurrentUserData();
    if (user != null) ref.read(userDataProvider.notifier).updateUser(user);
    return user;
  }

  void signInWithPhone(BuildContext context, String phoneNumber, String countryCode, bool isSignUp) {
    authRepository.signInWithPhone(context, ref, phoneNumber, countryCode, isSignUp);
  }

  void verifyOTP(BuildContext context, String verificationId, String userOTP, String countryCode,
      bool isSignUp) {
    authRepository.verifyOTP(
      context: context,
      verificationId: verificationId,
      userOTP: userOTP,
      countryCode: countryCode,
      ref: ref,
      isSignUp: isSignUp,
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

  Stream<UserDataModel> userDataById(String userId) {
    return authRepository.userData(userId);
  }

  void setUserState(bool isOnline) {
    authRepository.setUserState(isOnline);
  }
}
