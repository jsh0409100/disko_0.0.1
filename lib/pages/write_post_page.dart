import 'package:disko_001/pages/select_category.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WritePostPage extends StatelessWidget {
  const WritePostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            shape: const Border(
                bottom: BorderSide(color: Colors.black, width: 0.5)),
            centerTitle: true,
            title: const Text(
              '글쓰기',
              style: TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Get.to(() => const SelectCategory());
                  },
                  child: const Text(
                    '다음',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  )),
            ]),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Column(children: [
              const TextField(
                maxLength: 15,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 24),
                  hintText: '제목',
                ),
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
              const Expanded(
                flex: 10,
                //TODO 오버플로우 해결 방법 찾기
                child: TextField(
                  expands: true,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                        top: 10, left: 24, right: 24, bottom: 0),
                    hintText: '글작성',
                  ),
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Expanded(
                child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              top: BorderSide(
                        color: Colors.black,
                        width: 0.5,
                      ))),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.add_reaction_outlined),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.photo_camera_outlined),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    )),
              )
            ]);
          },
        ));
  }
}
