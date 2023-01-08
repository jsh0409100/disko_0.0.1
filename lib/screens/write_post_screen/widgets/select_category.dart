import 'package:flutter/material.dart';

// class SelectCategory extends StatelessWidget {
//   const SelectCategory({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text("카테고리 선택"),
//         actions: <Widget>[
//           IconButton(
//             onPressed: () {},
//             icon: const Text("완료"),
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: Center(
//                   child: Container(
//                 padding: const EdgeInsets.only(top: 100),
//                 child: Wrap(
//                   spacing: 20,
//                   runSpacing: 20,
//                   children: const [
//                     CategoryCard(categoryIcon: "🔥", categoryName: "현지생활"),
//                     CategoryCard(categoryIcon: "🛍️", categoryName: "중고거래"),
//                     CategoryCard(categoryIcon: "👩🏻‍💻", categoryName: "구인구직"),
//                     CategoryCard(categoryIcon: "✈️", categoryName: "여행패키지"),
//                     CategoryCard(categoryIcon: "🏠", categoryName: "한인숙박"),
//                     CategoryCard(categoryIcon: "🍳", categoryName: "요리"),
//                     CategoryCard(categoryIcon: "😀", categoryName: "고민상당"),
//                     CategoryCard(
//                         categoryIcon: "🚖 🌤️", categoryName: "교통 / 날씨"),
//                     CategoryCard(categoryIcon: "🎓", categoryName: "유학생활"),
//                   ],
//                 ),
//               )),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class CategoryCards extends StatefulWidget {
  const CategoryCards({
    Key? key,
  }) : super(key: key);

  @override
  State<CategoryCards> createState() => _CategoryCardsState();
}

class _CategoryCardsState extends State<CategoryCards> {
  int _selected = 0;

  Widget CategoryCardRadioButton(
      {required String categoryIcon,
      required String categoryName,
      required int index}) {
    return SizedBox(
      width: 90,
      height: 90,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selected = index;
          });
        },
        child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: (_selected == index)
                  ? Theme.of(context).colorScheme.primary
                  : Colors.white, //<-- SEE HERE
            ),
            borderRadius: BorderRadius.circular(13.0),
          ),
          elevation: 1,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    categoryIcon,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    categoryName,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: (_selected == index)
                          ? Theme.of(context).colorScheme.primary
                          : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      children: [
        CategoryCardRadioButton(
            categoryIcon: "🔥", categoryName: "현지생활", index: 1),
        CategoryCardRadioButton(
            categoryIcon: "🛍️", categoryName: "중고거래", index: 2),
        CategoryCardRadioButton(
            categoryIcon: "👩🏻‍💻", categoryName: "구인구직", index: 3),
        CategoryCardRadioButton(
            categoryIcon: "✈️", categoryName: "여행", index: 4),
        CategoryCardRadioButton(
            categoryIcon: "🏠", categoryName: "한인숙박", index: 5),
        CategoryCardRadioButton(
            categoryIcon: "🍳", categoryName: "요리", index: 6),
        CategoryCardRadioButton(
            categoryIcon: "😀", categoryName: "고민상당", index: 7),
        CategoryCardRadioButton(
            categoryIcon: "🚖 🌤️", categoryName: "교통/날씨", index: 8),
        CategoryCardRadioButton(
            categoryIcon: "🎓", categoryName: "유학생활", index: 9),
      ],
    );
  }
}
