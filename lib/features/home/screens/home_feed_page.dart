import 'package:disko_001/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/enums/country_enum.dart';
import '../../../common/utils/utils.dart';
import '../../../common/widgets/common_app_bar.dart';
import '../../../models/category_list.dart';
import '../../../models/post_card_model.dart';
import '../../../src/providers.dart';
import '../../write_post/screens/write_post_page.dart';
import '../widgets/persistent_header.dart';
import '../widgets/post.dart';

final selectedIndexProvider = StateProvider<int>((ref) => 999);

class HomeFeedPage extends ConsumerStatefulWidget {
  const HomeFeedPage({Key? key}) : super(key: key);

  @override
  _HomeFeedPageState createState() => _HomeFeedPageState();
}

class _HomeFeedPageState extends ConsumerState<HomeFeedPage> with AutomaticKeepAliveClientMixin {
  final ScrollController scrollController = ScrollController();
  int? _value;

  List<Widget> techChips() {
    List<Widget> chips = [];
    for (int i = 0; i < CategoryList.categories.length; i++) {
      Widget item = Padding(
        padding: const EdgeInsets.only(left: 10, right: 5),
        child: ChoiceChip(
          shape: const StadiumBorder(side: BorderSide(width: 0.5)),
          label: Text(CategoryList.categories[i]),
          labelStyle: const TextStyle(color: Colors.black),
          backgroundColor: Theme.of(context).colorScheme.background,
          selectedColor: Theme.of(context).colorScheme.primary,
          selected: _value == i,
          onSelected: (bool selected) {
            if (selected) {
              ref.read(selectedIndexProvider.notifier).update((state) => i);
            } else {
              ref.read(selectedIndexProvider.notifier).update((state) => 999);
            }
            setState(() {
              _value = selected ? i : null;
            });
          },
        ),
      );
      chips.add(item);
    }
    return chips;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final UserDataModel user = ref.watch(userDataProvider);
    super.build(context);
    scrollController.addListener(() {
      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - currentScroll < delta) {
        ref.read(postsProvider.notifier).fetchNextBatch();
      }
    });
    return Scaffold(
      appBar: CommonAppBar(
        title: countries[user.countryCode]!,
        appBar: AppBar(),
      ),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: RefreshIndicator(
        onRefresh: () => ref.read(postsProvider.notifier).reloadPage(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 11.0),
          child: CustomScrollView(
            controller: scrollController,
            restorationId: "posts List",
            slivers: [
              SliverPersistentHeader(
                  delegate: PersistentHeaderList(
                widget: techChips(),
              )),
              PostsList(),
              NoMorePosts(),
              OnGoingBottomWidget(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, WritePostPage.routeName);
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
          return const SliverToBoxAdapter(
            child: Center(
              child: Column(
                children: [
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

class PostsListBuilder extends ConsumerStatefulWidget {
  const PostsListBuilder({
    Key? key,
    required this.posts,
  }) : super(key: key);

  final List<PostCardModel> posts;

  @override
  ConsumerState<PostsListBuilder> createState() => _PostsListBuilderState();
}

class _PostsListBuilderState extends ConsumerState<PostsListBuilder> {
  @override
  void initState() {
    super.initState();
    ref.read(selectedIndexProvider);
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        addAutomaticKeepAlives: true,
        (context, index) {
          final selectedIndex = ref.watch(selectedIndexProvider);
          if (selectedIndex == 999) {
            return FutureBuilder(
                future: getUserDataByUid(widget.posts[index].uid),
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
                    PostCardModel post = PostCardModel(
                      userName: snapshot.data.displayName,
                      postTitle: widget.posts[index].postTitle,
                      postText: widget.posts[index].postText,
                      uid: widget.posts[index].uid,
                      postId: widget.posts[index].postId,
                      likes: widget.posts[index].likes,
                      imagesUrl: widget.posts[index].imagesUrl,
                      time: widget.posts[index].time,
                      isQuestion: widget.posts[index].isQuestion,
                      commentCount: widget.posts[index].commentCount,
                      category: widget.posts[index].category,
                      isAnnouncement: widget.posts[index].isAnnouncement,
                    );
                    return Post(
                      post: post,
                    );
                  }
                });
          }  else if (widget.posts[index].category == CategoryList.categories[selectedIndex]) {
            return FutureBuilder(
                future: getUserDataByUid(widget.posts[index].uid),
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
                    PostCardModel post = PostCardModel(
                      userName: snapshot.data.displayName,
                      postTitle: widget.posts[index].postTitle,
                      postText: widget.posts[index].postText,
                      uid: widget.posts[index].uid,
                      postId: widget.posts[index].postId,
                      likes: widget.posts[index].likes,
                      imagesUrl: widget.posts[index].imagesUrl,
                      time: widget.posts[index].time,
                      isQuestion: widget.posts[index].isQuestion,
                      commentCount: widget.posts[index].commentCount,
                      category: widget.posts[index].category,
                      isAnnouncement: widget.posts[index].isAnnouncement,
                    );
                    return Post(
                      post: post,
                    );
                  }
                });
          } else if(selectedIndex == 0 && widget.posts[index].isAnnouncement){
              return FutureBuilder(
                  future: getUserDataByUid(widget.posts[index].uid),
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
                      PostCardModel post = PostCardModel(
                        userName: snapshot.data.displayName,
                        postTitle: widget.posts[index].postTitle,
                        postText: widget.posts[index].postText,
                        uid: widget.posts[index].uid,
                        postId: widget.posts[index].postId,
                        likes: widget.posts[index].likes,
                        imagesUrl: widget.posts[index].imagesUrl,
                        time: widget.posts[index].time,
                        isQuestion: widget.posts[index].isQuestion,
                        commentCount: widget.posts[index].commentCount,
                        category: widget.posts[index].category,
                        isAnnouncement: widget.posts[index].isAnnouncement,
                      );
                      return Post(
                        post: post,
                      );
                    }
                  });

          } else {
            return const SizedBox();
          }
        },
        childCount: widget.posts.length,
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
            onGoingLoading: (posts) => const Center(child: CircularProgressIndicator()),
            onGoingError: (posts, e, stk) => const Center(
              child: Column(
                children: [
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
