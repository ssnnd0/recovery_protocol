import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';

import '../../../core/app_export.dart';

class WorkoutVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final VoidCallback? onVideoCompleted;

  const WorkoutVideoPlayer({
    super.key,
    required this.videoUrl,
    this.onVideoCompleted,
  });

  @override
  State<WorkoutVideoPlayer> createState() => _WorkoutVideoPlayerState();
}

class _WorkoutVideoPlayerState extends State<WorkoutVideoPlayer> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _showControls = true;
  double _playbackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _controller =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      await _controller!.initialize();

      _controller!.addListener(() {
        if (_controller!.value.position >= _controller!.value.duration) {
          widget.onVideoCompleted?.call();
        }
      });

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      debugPrint('Error initializing video: $e');
    }
  }

  void _togglePlayPause() {
    if (_controller != null) {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
      } else {
        _controller!.play();
      }
      setState(() {});
    }
  }

  void _skipForward() {
    if (_controller != null) {
      final currentPosition = _controller!.value.position;
      final newPosition = currentPosition + const Duration(seconds: 15);
      final maxPosition = _controller!.value.duration;

      _controller!
          .seekTo(newPosition > maxPosition ? maxPosition : newPosition);
    }
  }

  void _skipBackward() {
    if (_controller != null) {
      final currentPosition = _controller!.value.position;
      final newPosition = currentPosition - const Duration(seconds: 15);

      _controller!
          .seekTo(newPosition < Duration.zero ? Duration.zero : newPosition);
    }
  }

  void _changePlaybackSpeed() {
    setState(() {
      if (_playbackSpeed == 1.0) {
        _playbackSpeed = 1.25;
      } else if (_playbackSpeed == 1.25) {
        _playbackSpeed = 1.5;
      } else if (_playbackSpeed == 1.5) {
        _playbackSpeed = 0.75;
      } else {
        _playbackSpeed = 1.0;
      }
    });
    _controller?.setPlaybackSpeed(_playbackSpeed);
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || _controller == null) {
      return Container(
        width: double.infinity,
        height: 56.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: CircularProgressIndicator(
            color: AppTheme.lightTheme.primaryColor,
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: 56.h,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Video Player
            Positioned.fill(
              child: GestureDetector(
                onTap: _toggleControls,
                child: AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                ),
              ),
            ),

            // Video Controls Overlay
            if (_showControls)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.7),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      // Top Controls
                      Padding(
                        padding: EdgeInsets.all(4.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: _changePlaybackSpeed,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 3.w,
                                  vertical: 1.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.6),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${_playbackSpeed}x',
                                  style: AppTheme
                                      .lightTheme.textTheme.labelMedium
                                      ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 3.w,
                                vertical: 1.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomIconWidget(
                                    iconName: 'live_tv',
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    'LIVE',
                                    style: AppTheme
                                        .lightTheme.textTheme.labelSmall
                                        ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // Center Play Controls
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: _skipBackward,
                            child: Container(
                              padding: EdgeInsets.all(3.w),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.6),
                                shape: BoxShape.circle,
                              ),
                              child: CustomIconWidget(
                                iconName: 'replay_15',
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: _togglePlayPause,
                            child: Container(
                              padding: EdgeInsets.all(4.w),
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: CustomIconWidget(
                                iconName: _controller!.value.isPlaying
                                    ? 'pause'
                                    : 'play_arrow',
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: _skipForward,
                            child: Container(
                              padding: EdgeInsets.all(3.w),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.6),
                                shape: BoxShape.circle,
                              ),
                              child: CustomIconWidget(
                                iconName: 'forward_15',
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      // Bottom Progress Bar
                      Padding(
                        padding: EdgeInsets.all(4.w),
                        child: Column(
                          children: [
                            VideoProgressIndicator(
                              _controller!,
                              allowScrubbing: true,
                              colors: VideoProgressColors(
                                playedColor: AppTheme.lightTheme.primaryColor,
                                bufferedColor:
                                    Colors.white.withValues(alpha: 0.3),
                                backgroundColor:
                                    Colors.white.withValues(alpha: 0.1),
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDuration(_controller!.value.position),
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  _formatDuration(_controller!.value.duration),
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
