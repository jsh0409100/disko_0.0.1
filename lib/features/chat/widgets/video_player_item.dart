import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  final DataSourceType dataSourceType;

  const VideoPlayerItem({
    Key? key,
    required this.videoUrl,
    required this.dataSourceType,
  }) : super(key: key);

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    switch (widget.dataSourceType) {
      case DataSourceType.asset:
        _videoPlayerController = VideoPlayerController.asset(widget.videoUrl);
        break;
      case DataSourceType.network:
        _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
        break;
      case DataSourceType.file:
        _videoPlayerController = VideoPlayerController.file(File(widget.videoUrl));
        break;
      case DataSourceType.contentUri:
        _videoPlayerController = VideoPlayerController.contentUri(Uri.parse(widget.videoUrl));
        break;
    }

    _videoPlayerController.initialize().then(
          (_) => setState(() {
            _isLoading = false;
            _chewieController = ChewieController(
              videoPlayerController: _videoPlayerController,
              aspectRatio: _videoPlayerController.value.aspectRatio,
              showControlsOnInitialize: false,
              placeholder: Container(
                color: Colors.black12,
              )
            );
          }),
        );
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
    _chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? const CircularProgressIndicator() : Chewie(controller: _chewieController);
  }
}
