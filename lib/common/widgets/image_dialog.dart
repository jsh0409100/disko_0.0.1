import 'package:flutter/material.dart';

class ImageDialog extends StatelessWidget {
  final String imgUrl;
  const ImageDialog({super.key, required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration:
            BoxDecoration(image: DecorationImage(image: NetworkImage(imgUrl), fit: BoxFit.cover)),
      ),
    );
  }
}
