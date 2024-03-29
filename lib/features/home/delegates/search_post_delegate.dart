import 'package:disko_001/common/widgets/loading_screen.dart';
import 'package:disko_001/features/write_post/controller/write_post_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/widgets/error_text.dart';
import '../../../common/utils/utils.dart';
import '../widgets/post.dart';

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
    return ref.watch(searchPostProvider(query)).when(
      data: (posts) => ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return FutureBuilder(
              future: getUserDataByUid(posts[index].uid),
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
                    post: posts[index],
                  );
                }
              }
          );
        }
      ), error:(error, stackTrace) => ErrorText(
      error: error.toString(),
    ),
      loading: () => const LoadingScreen(),
    );
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
      loading: () => Container(),
    );
  }
}