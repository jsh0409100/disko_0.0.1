import 'package:cached_network_image/cached_network_image.dart';
import 'package:disko_001/features/chat/widgets/video_player_item.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

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
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
          maxHeight: MediaQuery.of(context).size.width * 0.4),
      child: type == MessageEnum.text
          ? Container(
              decoration: const BoxDecoration(
                color: Color(0xFFECECEC),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Text(
                message,
                style: TextStyle(
                  color: isSender ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ))
          : type == MessageEnum.video
              ? Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFECECEC),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: VideoPlayerItem(
                    videoUrl: message,
                    dataSourceType: DataSourceType.network,
                  ))
              : CachedNetworkImage(
                  imageUrl: message,
                ),
    );
  }
}
