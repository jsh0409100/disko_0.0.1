import 'package:flutter/material.dart';

class SelectCategory extends StatelessWidget {
  const SelectCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("카테고리 선택"),
        actions: <Widget>[
          IconButton(
            onPressed: (){},
            icon: Text("완료"),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                  child: Container(
                    padding: EdgeInsets.only(top: 100),
                    child: Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: Card(
                            elevation: 0,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("🔥"),
                                    SizedBox(height: 10,),
                                    Text("현지생활"),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: Card(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("🛍️"),
                                    SizedBox(height: 10,),
                                    Text("중고거래"),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: Card(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("👩🏻‍💻"),
                                    SizedBox(height: 10,),
                                    Text("구인구직"),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: Card(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("✈️"),
                                    SizedBox(height: 10,),
                                    Text("여행패키지"),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: Card(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("🏠"),
                                    SizedBox(height: 10,),
                                    Text("한인숙박"),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: Card(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("🍳"),
                                    SizedBox(height: 10,),
                                    Text("요리"),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: Card(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("😀"),
                                    SizedBox(height: 10,),
                                    Text("고민상담"),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: Card(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("🚖 🌤️"),
                                    SizedBox(height: 10,),
                                    Text("교통 / 날씨"),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: Card(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("🎓"),
                                    SizedBox(height: 10,),
                                    Text("유학생활"),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
