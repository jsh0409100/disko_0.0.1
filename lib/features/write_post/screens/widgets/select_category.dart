import 'package:flutter/material.dart';

import '../../../../models/category_list.dart';

class CategoryCards extends StatefulWidget {
  late int selected;
  CategoryCards({
    required this.selected,
    Key? key,
  }) : super(key: key);

  @override
  State<CategoryCards> createState() => _CategoryCardsState();
}

class _CategoryCardsState extends State<CategoryCards> {
  Widget CategoryCardRadioButton({
    required String categoryIcon,
    required String categoryName,
    required int index,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.25,
      height: MediaQuery.of(context).size.width * 0.25,
      child: GestureDetector(
        onTap: () {
          setState(() {
            widget.selected = index;
          });
        },
        child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color:
                  (widget.selected == index) ? Theme.of(context).colorScheme.primary : Colors.white,
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
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    categoryName,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: (widget.selected == index)
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 11.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            CategoryCardRadioButton(
                categoryIcon: "🔥", categoryName: CategoryList.categories[1], index: 1),
            CategoryCardRadioButton(
                categoryIcon: "🛍️", categoryName: CategoryList.categories[2], index: 2),
            CategoryCardRadioButton(
                categoryIcon: "👩🏻‍💻", categoryName: CategoryList.categories[3], index: 3),
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CategoryCardRadioButton(
                  categoryIcon: "✈️", categoryName: CategoryList.categories[4], index: 4),
              CategoryCardRadioButton(
                  categoryIcon: "🏠", categoryName: CategoryList.categories[5], index: 5),
              CategoryCardRadioButton(
                  categoryIcon: "🍳", categoryName: CategoryList.categories[6], index: 6),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CategoryCardRadioButton(
                  categoryIcon: "😀", categoryName: CategoryList.categories[7], index: 7),
              CategoryCardRadioButton(
                  categoryIcon: "🚖 🌤️", categoryName: CategoryList.categories[8], index: 8),
              CategoryCardRadioButton(
                  categoryIcon: "🎓", categoryName: CategoryList.categories[9], index: 9),
            ],
          ),
        ],
      ),
    );
  }
}
