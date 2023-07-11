import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/enums/notification_enum.dart';
import '../../../models/chip_model.dart';
import '../../../models/comment_model.dart';
import '../../auth/controller/auth_controller.dart';
import '../repository/profile_repository.dart';


final profileControllerProvider = Provider((ref) {
  final profileRepository = ref.watch(profileRepositoryProvider);
  return ProfileController(
    profileRepository: profileRepository,
    ref: ref,
  );
});

class ProfileController {
  final ProfileRepository profileRepository;
  final ProviderRef ref;
  ProfileController({
    required this.profileRepository,
    required this.ref,
  });

  Stream<List<ChipModel>> chipStream(List<String> chip){
    return profileRepository.getChipStream(chip);
  }

  void uploadChip(
      BuildContext context,
      List<String> tag,
      ) {
    ref.read(userDataAuthProvider).whenData(
          (value) => profileRepository.uploadChip(
        context: context,
        tag: tag,
      ),
    );
  }


}
