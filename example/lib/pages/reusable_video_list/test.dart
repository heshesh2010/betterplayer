import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({Key? key}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late BetterPlayerController _betterPlayerController;

  @override
  void initState() {
    _betterPlayerController = BetterPlayerController(BetterPlayerConfiguration(
      aspectRatio: 16 / 9,
      looping: true,
      autoPlay: true,
      autoDispose: false,
      handleLifecycle: false,
      controlsConfiguration:
          BetterPlayerControlsConfiguration(showControls: false),
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return index == 1
              ? VideoItem(_betterPlayerController)
              : Container(
                  margin: EdgeInsets.all(20),
                  width: 200,
                  height: 200,
                  color: Colors.red);
        },
      ),
    );
  }

  @override
  void dispose() {
    _betterPlayerController.dispose(forceDispose: true);
    super.dispose();
  }
}

class VideoItem extends StatefulWidget {
  final BetterPlayerController _betterPlayerController;

  const VideoItem(this._betterPlayerController);

  @override
  _VideoItemState createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  BetterPlayerController get controller => widget._betterPlayerController;

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  void initPlayer() {
    var dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      bufferingConfiguration: BetterPlayerBufferingConfiguration(
          minBufferMs: 25000,
          maxBufferMs: 6553600,
          bufferForPlaybackMs: 1250,
          bufferForPlaybackAfterRebufferMs: 2500),
    );
    controller.setupDataSource(dataSource);
  }

  void onVisibilityChanged(double fraction) {
    print("Fraction is : $fraction");
    if (fraction == 0) {
      controller.pause();
    } else {
      controller.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: GlobalKey(),
      child: BetterPlayer(controller: controller),
      onVisibilityChanged: (info) {
        onVisibilityChanged(info.visibleFraction);
      },
    );
  }
}
