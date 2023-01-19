import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final String displayName, country, description;
  const ProfilePage(
      {Key? key,
      required this.displayName,
      required this.country,
      required this.description})
      : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String test = 'test';

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 130,
              child: GestureDetector(
                child: Stack(children: const [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(
                        'https://i.guim.co.uk/img/media/a72cabc3e4889bd471dec02579514f462cecf920/0_11_2189_1313/master/2189.jpg?width=1200&height=1200&quality=85&auto=format&fit=crop&s=a3fd231d883d268abe7b7e0b6a2b762b'),
                  ),
                  Positioned(
                    left: 80,
                    top: 95,
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
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.displayName,
                      style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                      ),
                    ),
                    Text(
                      widget.country,
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
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
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
                SizedBox(width: MediaQuery.of(context).size.width * 0.03),
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
                SizedBox(width: MediaQuery.of(context).size.width * 0.03),
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
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Text(
              widget.description,
              style: TextStyle(
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Card(
              elevation: 5,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.only(top: 15),
                width: double.infinity,
                height: 82,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          test = 'mirror ball';
                        });
                      },
                      child: Container(
                        width: 50,
                        height: 60,
                        child: Column(
                          children: const [
                            Text(
                              '미러볼',
                              style: TextStyle(
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
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
                    SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          test = 'My Post';
                        });
                      },
                      child: Container(
                        width: 50,
                        height: 60,
                        child: Column(
                          children: const [
                            Text(
                              '게시물',
                              style: TextStyle(
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
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
                    SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          test = 'Q and A';
                        });
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        child: Column(
                          children: const [
                            Text(
                              '질문답변',
                              style: TextStyle(
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
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
                    SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          test = 'Followings';
                        });
                      },
                      child: Container(
                        width: 50,
                        height: 60,
                        child: Column(
                          children: const [
                            Text(
                              '팔로잉',
                              style: TextStyle(
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
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
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Container(
              child: Text('$test'),
            ),
          ],
        ),
      ],
    );
  }

  Widget mirrorballbuilder() {
    return Container(
      child: const Text('mirrorball'),
    );
  }

  Widget Mypost() {
    return Container(
      child: const Text('My post'),
    );
  }

  Widget QandA() {
    return Container(
      child: const Text('Q and A'),
    );
  }

  Widget Followings() {
    return const Text('Followings');
  }
}
