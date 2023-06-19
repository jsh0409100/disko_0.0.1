import 'package:cached_network_image/cached_network_image.dart';
import 'package:disko_001/features/chat/widgets/video_player_item.dart';
import 'package:flutter/material.dart';

import '../../../common/enums/message_enum.dart';

class DisplayTextImageGIF extends StatelessWidget {
  final String message;
  final MessageEnum type;
  final bool isSender;
  const DisplayTextImageGIF({
    Key? key,
    required this.message,
    required this.type,
    required this.isSender,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return type == MessageEnum.text
        ? Text(
            message,
            style: TextStyle(
              color: isSender ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          )
        : type == MessageEnum.video
            ? VideoPlayerItem(
                videoUrl: message,
              )
            : CachedNetworkImage(
                imageUrl: message,
              );
  }
}
