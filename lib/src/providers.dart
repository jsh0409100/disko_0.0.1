import 'package:disko_001/models/post_card_model.dart';
import 'package:disko_001/screens/starting_screens/signup_page.dart';
import 'package:disko_001/src/pagination_notifier.dart';
import 'package:disko_001/src/pagination_state/pagination_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';

import '../widget/post_card.dart';

final postsProvider = StateNotifierProvider<PaginationNotifier<PostCardModel>,
    PaginationState<PostCardModel>>((ref) {
  return PaginationNotifier(
    itemsPerBatch: 5,
    fetchNextItems: (
      post,
    ) {
      return ref.read(PostDatabaseProvider).fetchPosts(post);
    },
  )..init();
});

final PostDatabaseProvider = Provider<PostsDatabase>((ref) => PostsDatabase());

final authenticationProvider = Provider<SignUpPage>((ref) {
  return SignUpPage();
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.read(authenticationProvider).authStateChange;
});
