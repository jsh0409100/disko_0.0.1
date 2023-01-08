import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[50],
        automaticallyImplyLeading: true,
        title: const Text(
          '유학생활',
          style: TextStyle(
            color: Colors.black
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: const <Widget>[
          Square(),
        ],
      ),
    );
  }
}

class Square extends StatelessWidget {
  const Square({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            padding: const EdgeInsets.fromLTRB(19, 17, 0, 18),
            width: 345,
            height: 63,
            decoration: BoxDecoration(
                color: const Color(0xffD9D9D9),
                borderRadius: BorderRadius.circular(12)
            ),
            child: const Text(
              '제목',
              style: TextStyle(
                fontSize: 26,
              ),
            ),
          ),
        ),
        const SizedBox(height: 13),
        Row(
          children: [
            const SizedBox(width: 15),
            Column(
              children: const [
                Text('본문내용 본문내용 본문내용 본문내용',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                Text('본문내용 본문내용 본문내용 본문내용',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                Text('본문내용 본문내용 본문내용 본문내용',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 166,
              height: 148,
              decoration: BoxDecoration(
                color: const Color(0xffD9D9D9),
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(image: NetworkImage('https://images.unsplash.com/photo-1493612276216-ee3925520721?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cmFuZG9tfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60')),
              ),
            ),
            const SizedBox(width: 13),
            Container(
              width: 166,
              height: 148,
              decoration: BoxDecoration(
                color: const Color(0xffD9D9D9),
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(image: NetworkImage('https://images.unsplash.com/photo-1481349518771-20055b2a7b24?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8cmFuZG9tfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60')),
              ),
            ),
          ],
        ),
        const SizedBox(height: 19),
        Row(
          children: [
            const SizedBox(width: 15),
            Column(
              children: const [
                Text('본문내용 본문내용 본문내용 본문내용',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                Text('본문내용 본문내용 본문내용 본문내용',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                Text('본문내용 본문내용 본문내용 본문내용',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Center(
          child: Container(
            width: 345,
            height: 278,
            decoration: BoxDecoration(
              color: const Color(0xffD9D9D9),
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(image: NetworkImage('https://images.unsplash.com/photo-1513542789411-b6a5d4f31634?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8cmFuZG9tfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60')),
            ),
          ),
        ),
        const SizedBox(height: 42),
        const SizedBox(width: 376,
          child: Divider(color: Color(0xffD9D9D9), thickness: 1),
        ),
        const SizedBox(height: 9),
        Row(
          children: [
            const SizedBox(width: 14),
            IconButton(
              onPressed: () {  },
              icon: const Icon(Icons.favorite_border_outlined),
              iconSize: 24,
            ),
            const SizedBox(width: 24),
            IconButton(
              onPressed: () {  },
              icon: const Icon(Icons.chat_outlined),
              iconSize: 24,
            ),
            const SizedBox(width: 24),
            IconButton(
              onPressed: () {  },
              icon: const Icon(Icons.bookmark_border_outlined),
              iconSize: 24,
            ),
          ],
        ),
        const SizedBox(height: 41),
        Row(
          children: [
            const SizedBox(width: 15),
            Container(
              height: 36,
              width: 36,
              decoration: const BoxDecoration(
                  color: Color(0xffD9D9D9),
                  shape: BoxShape.circle
              ),
            ),
            const SizedBox(width: 14),
            Column(
              children: [
                Row(
                  children: const [
                    Text('닉네임',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text('시간',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text('wow 예뻐요!',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 120),
            Row(
              children: [
                Column(
                  children: [
                    IconButton(
                      onPressed: () {  },
                      icon: const Icon(Icons.chat_bubble_outline),
                      iconSize: 24,
                    ),
                    const Text('1'),
                  ],
                ),
                const SizedBox(width: 5),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {  },
                      icon: const Icon(Icons.favorite_border_outlined),
                      iconSize: 24,
                    ),
                    const Text('8'),
                  ],
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 19),
        Row(
          children: [
            const SizedBox(width: 62),
            Container(
              height: 36,
              width: 36,
              decoration: const BoxDecoration(
                  color: Color(0xffD9D9D9),
                  shape: BoxShape.circle
              ),
            ),
            const SizedBox(width: 14),
            Column(
              children: [
                Row(
                  children: const [
                    Text('닉네임2',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text('시간',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text('당신도 예뻐요!',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 19),
        Row(
          children: [
            const SizedBox(width: 15),
            Container(
              height: 36,
              width: 36,
              decoration: const BoxDecoration(
                  color: Color(0xffD9D9D9),
                  shape: BoxShape.circle
              ),
            ),
            const SizedBox(width: 14),
            Column(
              children: [
                Row(
                  children: const [
                    Text('닉네임3',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text('시간',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text('우와아아아!',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 29),
        const SizedBox(width: 376,
          child: Divider(color: Color(0xffD9D9D9), thickness: 1),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const SizedBox(width: 15),
            Container(
              height: 36,
              width: 36,
              decoration: const BoxDecoration(
                  color: Color(0xffD9D9D9),
                  shape: BoxShape.circle
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: SizedBox(
                width: 252,
                height: 41.5,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '댓글 쓰기',
                    hintStyle: const TextStyle(fontSize: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    filled: true,
                    fillColor: const Color(0xffD9D9D9),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: const EdgeInsets.all(10),
                backgroundColor: const Color(0xffE4E4E4),
                minimumSize: const Size(48, 42),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              onPressed: () {},
              child: const Text(
                '게시',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
