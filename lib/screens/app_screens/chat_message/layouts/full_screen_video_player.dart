import 'dart:developer';

import 'package:chatzy/config.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FullScreenVideoPlayer extends StatefulWidget {
  final VideoPlayerController videoController;

  const FullScreenVideoPlayer({super.key, required this.videoController});

  @override
  State<FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PopScope(canPop:false ,onPopInvoked: (didPop) {
        if(didPop) return ;
        Get.back();
        widget.videoController.value.isCompleted;
        widget.videoController.pause();
      },
        child: Stack(
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: widget.videoController.value.aspectRatio,
                child: VideoPlayer(widget.videoController),
              ),
            ),
            BackButton(color: appCtrl.appTheme.sameWhite,onPressed: () {
              Get.back();
              widget.videoController.value.isCompleted;
              widget.videoController.pause();
            },).padding(top: Sizes.s50),
            IconButton(
                icon: Icon(
                        widget.videoController.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                        color: appCtrl.appTheme.white)
                    .marginAll(Insets.i3)
                    .decorated(
                        color: appCtrl.appTheme.secondary,
                        shape: BoxShape.circle),
                onPressed: () {
                  log("widget.videoController.value::${widget.videoController.value.isPlaying}");
                  if (widget.videoController.value.isPlaying) {
                    log("widget.videoController.value::${widget.videoController.value.isPlaying}");
                    widget.videoController.pause();
                  } else {
                    // If the video is paused, play it.
                    widget.videoController.play();
                  }
                  setState(() {});
                }).center()
          ],
        ),
      ),
    );
  }
}
