import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:video_player/video_player.dart';

import '../../theme/app_colors.dart';
import '../../theme/dimens.dart';

class ImageZoomView extends StatefulWidget {
  String? url;
  String? type;
  ImageZoomView({Key? key, this.url, this.type}) : super(key: key);

  @override
  State<ImageZoomView> createState() {
    return _ImageViewScreen();
  }
}

class _ImageViewScreen extends State<ImageZoomView> {
  VideoPlayerController? _controller =
      VideoPlayerController.networkUrl(Uri.parse(''));
  @override
  void initState() {
    super.initState();
    if (widget.type == "video") {
      _controller = VideoPlayerController.networkUrl(Uri.parse('${widget.url}'))
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
        })
        ..addListener(() {
          if (_controller!.value.isCompleted) {
            setState(() {
              _controller!.pause();
            });
          }
        });
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.type == "video") {
      _controller!.dispose();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
          body: SafeArea(
        top: true,
        child: Container(
          color: Colors.transparent,
          child: Column(
            children: [
              const SizedBox(
                height: 24,
              ),
              Container(
                padding: const EdgeInsets.only(left: 16, right: 16),
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: AppColors.blackColor,
                    size: Dimens.twentyEight,
                  ),
                ),
              ),
              Expanded(
                child: widget.type == 'video'
                    ? _controller!.value.isInitialized
                        ? Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                AspectRatio(
                                  aspectRatio: 16.0 / 9.0,
                                  child: VideoPlayer(_controller!),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _controller!.play();
                                    });
                                  },
                                  child: _controller!.value.isPlaying
                                      ? Container()
                                      : Icon(
                                          Icons.play_circle,
                                          size: 50,
                                          color: Colors.white,
                                        ),
                                ),
                              ],
                            ),
                          )
                        : Container()
                    : Container(
                        margin: EdgeInsets.all(16),
                        child: PinchZoom(
                          child: CachedNetworkImage(
                            imageUrl: widget.url!,
                            placeholder: (context, url) => Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              alignment: Alignment.center,
                              child: Container(
                                width: 30,
                                height: 30,
                                child: const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.primaryColor)),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                              ),
                              child: const Icon(Icons.error,
                                  color: Colors.black, size: 30),
                            ),
                          ),
                          maxScale: 2.5,
                          onZoomStart: () {
                            print('Start zooming');
                          },
                          onZoomEnd: () {
                            print('Stop zooming');
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      ));
}
