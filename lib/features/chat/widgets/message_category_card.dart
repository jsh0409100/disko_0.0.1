import 'package:flutter/material.dart';

class MessageCategoryCard extends StatelessWidget {
  final IconData categoryIcon;
  final String categoryName;
  const MessageCategoryCard(
      {Key? key, required this.categoryIcon, required this.categoryName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13.0),
      ),
      elevation: 1,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                categoryIcon,
                size: 17,
                color: Colors.black,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                categoryName,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
