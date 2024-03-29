import 'package:disko_001/models/post_card_model.dart';
import 'package:disko_001/src/pagination_notifier.dart';
import 'package:disko_001/src/pagination_state/pagination_state.dart';
import 'package:riverpod/riverpod.dart';

import '../features/home/widgets/post.dart';
import '../models/user_model.dart';

final postsProvider = StateNotifierProvider<PaginationNotifier<PostCardModel>,
    PaginationState<PostCardModel>>((ref) {
      final UserDataModel user = ref.watch(userDataProvider);
  return PaginationNotifier(
    itemsPerBatch: 5,
    fetchNextItems: (
      post,
    ) {
      return ref.read(PostDatabaseProvider).fetchPosts(post, user);
    },
  )..init();
});

final PostDatabaseProvider = Provider<PostsDatabase>((ref) => PostsDatabase());
