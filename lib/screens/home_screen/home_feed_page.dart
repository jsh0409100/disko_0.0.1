import 'package:disko_001/screens/write_post_screen/write_post_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../../models/post_card_model.dart';
import '../../src/providers.dart';
import '../../src/tools.dart';
import '../../widget/post.dart';

class HomeFeedPage extends ConsumerWidget {
  HomeFeedPage({Key? key}) : super(key: key);

  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    scrollController.addListener(() {
      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - currentScroll <= delta) {
        ref.read(postsProvider.notifier).fetchNextBatch();
      }
    });
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 11.0),
        child: CustomScrollView(
          controller: scrollController,
          restorationId: "posts List",
          slivers: const [
            PostsList(),
            NoMorePosts(),
            OnGoingBottomWidget(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          Get.to(() => const WritePostPage());
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: const CircleBorder(),
        child: Icon(
          Icons.edit,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}

class PostsList extends StatelessWidget {
  const PostsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final state = ref.watch(postsProvider);
      return state.when(
        data: (posts) {
          return posts.isEmpty
              ? SliverToBoxAdapter(
            child: Column(
              children: [
                IconButton(
                  onPressed: () {
                    ref.read(postsProvider.notifier).fetchFirstBatch();
                  },
                  icon: const Icon(Icons.replay),
                ),
                const Chip(
                  label: Text("No posts Found!"),
                ),
              ],
            ),
          )
              : PostsListBuilder(
            posts: posts,
          );
        },
        loading: () => SliverToBoxAdapter(child: Center(child: Container())),
        error: (e, stk) {
          return SliverToBoxAdapter(
            child: Center(
              child: Column(
                children: const [
                  Icon(Icons.info),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "게시물을 불러오는 도중 에러가 발생하였습니다",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        onGoingLoading: (posts) {
          return PostsListBuilder(
            posts: posts,
          );
        },
        onGoingError: (posts, e, stk) {
          return PostsListBuilder(
            posts: posts,
          );
        },
      );
    });
  }
}

class PostsListBuilder extends StatelessWidget {
  const PostsListBuilder({
    Key? key,
    required this.posts,
  }) : super(key: key);

  final List<PostCardModel> posts;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return FutureBuilder(
              future: getDisplayNameByUid(posts[index].uid),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData == false) {
                  return Card(
                    color: Colors.grey.shade300,
                    child: Column(children: [
                      SizedBox(
                        height: 180,
                        width: MediaQuery.of(context).size.width * 0.9,
                      ),
                      const SizedBox(
                        height: 11,
                      )
                    ]),
                  );
                } else {
                  return Post(
                    userName: snapshot.data.toString(),
                    postTitle: posts[index].postTitle,
                    postCategory: posts[index].postCategory,
                    postText: posts[index].postText,
                    uid: posts[index].uid,
                    likes: posts[index].likes,
                    imagesUrl: posts[index].imagesUrl,
                  );
                }
              });
        },
        childCount: posts.length,
      ),
    );
  }
}

class OnGoingBottomWidget extends StatelessWidget {
  const OnGoingBottomWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(40),
      sliver: SliverToBoxAdapter(
        child: Consumer(builder: (context, ref, child) {
          final state = ref.watch(postsProvider);
          return state.maybeWhen(
            orElse: () => const SizedBox.shrink(),
            onGoingLoading: (posts) =>
            const Center(child: CircularProgressIndicator()),
            onGoingError: (posts, e, stk) => Center(
              child: Column(
                children: const [
                  Icon(Icons.info),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Something Went Wrong!",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class NoMorePosts extends ConsumerWidget {
  const NoMorePosts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(postsProvider);

    return SliverToBoxAdapter(
      child: state.maybeWhen(
          orElse: () => const SizedBox.shrink(),
          data: (posts) {
            final nomorePosts = ref.read(postsProvider.notifier).noMoreItems;
            return nomorePosts
                ? const Padding(
                    padding: EdgeInsets.only(bottom: 0),
                    child: Text(
                      "더이상 게시글이 없습니다",
                      textAlign: TextAlign.center,
                    ),
                  )
                : const SizedBox.shrink();
          }),
    );
  }
}