import 'package:cached_network_image/cached_network_image.dart';
import 'package:disko_001/features/chat/widgets/video_player_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:video_player/video_player.dart';

import '../../../common/enums/message_enum.dart';
import '../../home/screens/detail_page.dart';

class DisplayTextImageGIF extends StatelessWidget {
  final String message;
  final MessageEnum type;
  final bool isSender;
  // final bool isUploading;

  const DisplayTextImageGIF({
    Key? key,
    required this.message,
    required this.type,
    required this.isSender,
    // required this.isUploading,
  }) : super(key: key);
  static final customCacheManager = CacheManager(
    Config(
      'customCacheKey',
      stalePeriod: const Duration(days:15),
      maxNrOfCacheObjects: 20,
    ),
  );
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
          maxHeight: MediaQuery.of(context).size.width * 0.8),
      child: type == MessageEnum.text
          ? Container(
              decoration: BoxDecoration(
                color: isSender ?const Color(0xFF363f93) : const Color(0xFFECECEC),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
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
          : Container(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: type == MessageEnum.video
                  ? Container(
                      // decoration: const BoxDecoration(
                      //   color: Color(0xFFECECEC),
                      //   borderRadius: BorderRadius.all(Radius.circular(15)),
                      // ),
                      margin: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      child: VideoPlayerItem(
                        videoUrl: message,
                        dataSourceType: DataSourceType.network,
                      ))
                  : GestureDetector(
                onTap: (){
                  Navigator.pushNamed(
                    context,
                    DetailPage.routeName,
                    arguments: {
                      'postId': message,
                    },
                  );
                },
                    child: Container(
                        child: type == MessageEnum.share
                            ? Container(
                                margin: const EdgeInsets.only(bottom: 10, top: 25),
                                height: MediaQuery.of(context).size.height*0.25,
                                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                                child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(80.0)
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF363f93).withOpacity(0.3),
                                      offset: const Offset(-10.0,0),
                                      blurRadius: 20.0,
                                      spreadRadius: 4.0,
                                    ),
                                  ],
                                ),
                                  padding: const EdgeInsets.only(
                                    left: 32,
                                    top: 50.0,
                                    bottom: 50,
                                  ),
                                  child: const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "게시물 공유",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        "친구가 당신에게 게시물을 공유했어요!",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                              ),
                            )
                            : CachedNetworkImage(
                                cacheManager:  customCacheManager,
                                errorWidget: (context, url, error) => Container(
                                  color: Colors.black12,
                                  child: const Icon(Icons.error, color: Colors.red, size:30),
                                ),
                                placeholder: (context, url) => Container(color: Colors.black12),
                                key: UniqueKey(),
                                imageUrl: message,
                              ),
                      ),
                  ),
            ),
    );
  }
}
