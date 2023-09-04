import 'package:cached_network_image/cached_network_image.dart';
import 'package:disko_001/common/widgets/loading_screen.dart';
import 'package:disko_001/features/chat/widgets/video_player_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

import '../../../common/enums/message_enum.dart';

class DisplayTextImageGIF extends ConsumerStatefulWidget {
  final String message;
  final MessageEnum type;
  final bool isSender;
  final bool isUploading;

  const DisplayTextImageGIF({
    Key? key,
    required this.message,
    required this.type,
    required this.isSender,
    required this.isUploading,
  }) : super(key: key);

  @override
  ConsumerState<DisplayTextImageGIF> createState() =>
      _DisplayTextImageGIFState();
}

class _DisplayTextImageGIFState extends ConsumerState<DisplayTextImageGIF> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
                maxHeight: MediaQuery.of(context).size.width * 0.8),
            child: widget.type == MessageEnum.text
                ? Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFECECEC),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    margin:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: Text(
                      widget.message,
                      style: TextStyle(
                        color: widget.isSender ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ))
                : Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    margin:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: widget.type == MessageEnum.video
                        ? Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFFECECEC),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                            margin: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            child: VideoPlayerItem(
                              videoUrl: widget.message,
                              dataSourceType: DataSourceType.network,
                            ))
                        : CachedNetworkImage(
                            imageUrl: widget.message,
                          ),
                  ));
  }
}
