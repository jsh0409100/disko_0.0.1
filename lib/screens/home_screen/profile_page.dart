import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    child: Stack(children: const [
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage('https://i.guim.co.uk/img/media/a72cabc3e4889bd471dec02579514f462cecf920/0_11_2189_1313/master/2189.jpg?width=1200&height=1200&quality=85&auto=format&fit=crop&s=a3fd231d883d268abe7b7e0b6a2b762b'),
                        ),
                      ),
                      Positioned(
                        left: 100,
                        top: 115,
                        child: CircleAvatar(
                          backgroundColor: Color(0xffEFEFEF),
                          radius: 15,
                          child: Icon(
                            Icons.edit_outlined,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                      )
                    ]),
                    onTap: () {},
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width*0.2),
                  ButtonBar(
                    children: [
                      OutlinedButton(
                        onPressed: () {},
                        child: const Icon(
                          Icons.chat_outlined,
                          color: Colors.black,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          fixedSize: const Size(48, 28),
                        ),
                        onPressed: () {},
                        child: const Text(
                          '구독',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: const [
                      Text(
                        '올리비아 핫세',
                        style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                        ),
                      ),
                      Text('이스라엘',
                        style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.01),
              Row(
                children: [
                  Chip(
                    label: const Text('✏ 유학생'),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width*0.03),
                  Chip(
                    label: const Text('🍳 요리'),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width*0.03),
                  Chip(
                    label: const Text('📸 사진찍기'),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.01),
              const Text(
                '안녕하세요! 이스라엘에서 3년째 거주하고 있는 유학생입니다 :D 이스라엘에서 공부하고 있는 유학생분들 소통해요! 제 엠비티아이는 엥뿌삐',
                style: TextStyle(
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.03),
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        child: Column(
                          children: const [
                            Text(
                              '미러볼',
                              style: TextStyle(
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                              ),
                            ),
                            Text(
                              'Lv.2',
                              style: TextStyle(
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width*0.1),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        child: Column(
                          children: const [
                            Text(
                              '게시물',
                              style: TextStyle(
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                              ),
                            ),
                            Text(
                              '5',
                              style: TextStyle(
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width*0.1),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        child: Column(
                          children: const [
                            Text(
                              '질문답변',
                              style: TextStyle(
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                              ),
                            ),
                            Text(
                              '30',
                              style: TextStyle(
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width*0.1),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        child: Column(
                          children: const [
                            Text(
                              '팔로잉',
                              style: TextStyle(
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                              ),
                            ),
                            Text(
                              '15',
                              style: TextStyle(
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.03),
              Image.asset(
                'assets/mirrorball.png',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
