import 'package:disko_001/common/widgets/loading_screen.dart';
import 'package:disko_001/features/write_post/controller/write_post_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/widgets/error_text.dart';

class SearchPostDelegate extends SearchDelegate{
  final WidgetRef ref;
  SearchPostDelegate(this.ref);
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: (){
          query = '';
        },
        icon: Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () {
      close(context, null);
    },
  );

  @override
  Widget buildResults(BuildContext context) {
    //Todo 검색 결과를 보여줄 위젯
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ref.watch(searchPostProvider(query)).when(
      data: (posts) => ListView.builder(
        itemCount: posts.length,
        itemBuilder: (BuildContext context, int index){
          final post = posts[index];
          return ListTile(
            title: Text('r/${post.postTitle}'),
            onTap: () {},
            //ToDo 눌렀을 때 이동
          );
        }
      ),
      error: (error, stackTrace) => ErrorText(
        error: error.toString(),
      ),
      loading: () => const LoadingScreen(),
    );
  }
}