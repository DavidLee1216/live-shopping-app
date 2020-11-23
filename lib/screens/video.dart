import 'dart:io';

import 'package:flutter/material.dart';
import 'package:liveapp/config/constants.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  final String videoPath;
  VideoScreen({Key key, this.videoPath}) : super(key: key);

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  VideoPlayerController _videoController;
  Future<void> _initializeVideoControllerFuture;

  void _playVideo() async {
    await _videoController.seekTo(Duration.zero);
    await _videoController.play();
    setState(() {});
  }

  void _stopVideo() async {
    await _videoController.pause();
  }

  @override
  void initState() {
    super.initState();

    _videoController = VideoPlayerController.file(File(widget.videoPath));
    _videoController.addListener(() {
      if (!_videoController.value.isPlaying) {
        setState(() {});
      }
    });

    _initializeVideoControllerFuture = _videoController.initialize();
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;

    return Scaffold(
      body: FutureBuilder(
        future: _initializeVideoControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return GestureDetector(
              onTap: _videoController.value.isPlaying ? _stopVideo : _playVideo,
              child: Stack(
                children: [
                  Transform.scale(
                    scale: _videoController.value.aspectRatio / deviceRatio,
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: _videoController.value.aspectRatio,
                        child: VideoPlayer(_videoController),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          alignment: Alignment.centerRight,
                          margin: const EdgeInsets.only(top: 7, right: 15),
                          child: Icon(
                            Icons.close,
                            color: kButtonTextColor,
                            size: 30,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Icon(
                            _videoController.value.isPlaying
                                ? Icons.stop
                                : Icons.play_arrow,
                            color: kButtonTextColor,
                            size: 100,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
