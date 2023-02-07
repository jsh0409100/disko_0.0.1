import 'package:disko_001/models/post_card_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/controller/auth_controller.dart';
import '../repository/write_post_repository.dart';

final writePostControllerProvider = Provider((ref) {
  final writePostRepository = ref.watch(writePostRepositoryProvider);
  return WritePostController(
    writePostRepository: writePostRepository,
    ref: ref,
  );
});

final searchPostProvider = StreamProvider.family((ref, String query){
  return ref.watch(writePostRepositoryProvider).searchPost(query);
  //Todo 나중에 검증하기
});

class WritePostController{
  final WritePostRepository writePostRepository;
  final ProviderRef ref;
  WritePostController({
    required this.writePostRepository,
    required this.ref,
  });

  void uploadPost(
    BuildContext context,
    String text,
    String postCategory,
    String postTitle,
    List<String> imagesUrl,
    String postId,
  ) {
    ref.read(userDataAuthProvider).whenData(
          (value) => writePostRepository.uploadPost(
            context: context,
            text: text,
            userData: value!,
            postId: postId,
            postCategory: postCategory,
            postTitle: postTitle,
            imagesUrl: imagesUrl,
          ),
        );
  }
  
  Stream<List<PostCardModel>> searchPost(String query){
    return writePostRepository.searchPost(query);
  }
}
