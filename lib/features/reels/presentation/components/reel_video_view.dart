import 'dart:async';

import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/reels/reels.dart';
import 'package:video_player/video_player.dart';

class ReelVideoView extends StatefulWidget {
  final ReelItem reel;
  final bool isActive;
  final bool isMuted;

  const ReelVideoView({
    super.key,
    required this.reel,
    required this.isActive,
    required this.isMuted,
  });

  @override
  State<ReelVideoView> createState() {
    return _ReelVideoViewState();
  }
}

class _ReelVideoViewState
    extends State<ReelVideoView> {
  VideoPlayerController? _videoController;

  Timer? _progressHideTimer;

  bool _isInitializing = false;
  bool _isPlaying = false;
  bool _hasError = false;
  bool _showProgressBar = true;

  @override
  void initState() {
    super.initState();

    if (widget.isActive) {
      _initializeVideo();
    }
  }

  @override
  void didUpdateWidget(
      ReelVideoView oldWidget,
      ) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.reel.id != widget.reel.id) {
      _progressHideTimer?.cancel();

      _releaseController();

      _showProgressBar = true;

      if (widget.isActive) {
        _initializeVideo();
      }

      return;
    }

    if (oldWidget.isMuted != widget.isMuted) {
      _updateVolume();
    }

    if (oldWidget.isActive &&
        !widget.isActive) {
      _progressHideTimer?.cancel();

      _showProgressBar = false;

      _pauseVideo();
    }

    if (!oldWidget.isActive &&
        widget.isActive) {
      _showProgressBar = true;

      if (_videoController == null) {
        _initializeVideo();
      } else {
        _scheduleProgressBarHide();
      }
    }
  }

  Future<void> _initializeVideo() async {
    if (_isInitializing ||
        _videoController != null) {
      return;
    }

    setState(() {
      _isInitializing = true;
      _hasError = false;
      _showProgressBar = true;
    });

    try {
      final controller =
      VideoPlayerController.networkUrl(
        Uri.parse(widget.reel.videoUrl),
        videoPlayerOptions:
        VideoPlayerOptions(
          mixWithOthers: true,
        ),
      );

      controller.addListener(
        _onVideoChanged,
      );

      await controller.initialize();
      await controller.setLooping(true);
      await controller.setVolume(
        widget.isMuted ? 0 : 1,
      );

      if (!mounted) {
        controller
          ..removeListener(_onVideoChanged)
          ..dispose();

        return;
      }

      setState(() {
        _videoController = controller;
        _isInitializing = false;
      });

      if (widget.isActive) {
        _scheduleProgressBarHide();
      }

      // For automatic playback when the reel
      // becomes active, uncomment:
      //
      // if (widget.isActive) {
      //   await controller.play();
      // }
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isInitializing = false;
        _hasError = true;
      });
    }
  }

  Future<void> _updateVolume() async {
    final controller = _videoController;

    if (controller == null) {
      return;
    }

    await controller.setVolume(
      widget.isMuted ? 0 : 1,
    );
  }

  void _onVideoChanged() {
    final controller = _videoController;

    if (!mounted || controller == null) {
      return;
    }

    final playing =
        controller.value.isPlaying;

    if (playing != _isPlaying) {
      setState(() {
        _isPlaying = playing;
      });
    }
  }

  Future<void> _togglePlayback() async {
    var controller = _videoController;

    if (controller == null) {
      await _initializeVideo();

      controller = _videoController;
    }

    if (controller == null ||
        !controller.value.isInitialized) {
      return;
    }

    if (controller.value.isPlaying) {
      await controller.pause();
      return;
    }

    final position =
        controller.value.position;

    final duration =
        controller.value.duration;

    if (duration > Duration.zero &&
        position >= duration) {
      await controller.seekTo(
        Duration.zero,
      );
    }

    await controller.play();
  }

  Future<void> _handleDoubleTap({
    required double tapPosition,
    required double videoWidth,
  }) async {
    if (tapPosition < videoWidth / 2) {
      await _seekBy(
        const Duration(seconds: -5),
      );
    } else {
      await _seekBy(
        const Duration(seconds: 5),
      );
    }
  }

  Future<void> _seekBy(
      Duration difference,
      ) async {
    final controller = _videoController;

    if (controller == null ||
        !controller.value.isInitialized) {
      return;
    }

    final currentPosition =
        controller.value.position;

    final duration =
        controller.value.duration;

    var targetPosition =
        currentPosition + difference;

    if (targetPosition < Duration.zero) {
      targetPosition = Duration.zero;
    }

    if (targetPosition > duration) {
      targetPosition = duration;
    }

    await controller.seekTo(
      targetPosition,
    );
  }

  void _onInteractionStarted() {
    _progressHideTimer?.cancel();

    if (!_showProgressBar && mounted) {
      setState(() {
        _showProgressBar = true;
      });
    }
  }

  void _onInteractionEnded() {
    _scheduleProgressBarHide();
  }

  void _scheduleProgressBarHide() {
    _progressHideTimer?.cancel();

    _progressHideTimer = Timer(
      const Duration(seconds: 2),
          () {
        if (!mounted ||
            !_showProgressBar) {
          return;
        }

        setState(() {
          _showProgressBar = false;
        });
      },
    );
  }

  Future<void> _pauseVideo() async {
    final controller = _videoController;

    if (controller != null &&
        controller.value.isPlaying) {
      await controller.pause();
    }
  }

  void _releaseController() {
    final controller = _videoController;

    if (controller != null) {
      controller
        ..removeListener(_onVideoChanged)
        ..dispose();
    }

    _videoController = null;
    _isPlaying = false;
  }

  @override
  void dispose() {
    _progressHideTimer?.cancel();

    _releaseController();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Listener(
          behavior:
          HitTestBehavior.translucent,
          onPointerDown: (_) {
            _onInteractionStarted();
          },
          onPointerUp: (_) {
            _onInteractionEnded();
          },
          onPointerCancel: (_) {
            _onInteractionEnded();
          },
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,

            // Single tap: play or pause.
            onTap: _togglePlayback,

            // Double tap:
            // left = rewind 5 seconds
            // right = forward 5 seconds
            onDoubleTapDown: (details) {
              _handleDoubleTap(
                tapPosition:
                details.localPosition.dx,
                videoWidth:
                constraints.maxWidth,
              );
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                _buildVideoBackground(),

                const _ReelDarkGradient(),

                if (!_isPlaying &&
                    !_isInitializing &&
                    !_hasError)
                  Center(
                    child: _ReelPlayButton(
                      onPressed:
                      _togglePlayback,
                    ),
                  ),

                if (_isInitializing)
                  const Center(
                    child:
                    CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  ),

                if (_hasError)
                  _ReelErrorView(
                    onRetry:
                    _initializeVideo,
                  ),

                if (_videoController != null &&
                    _videoController!
                        .value.isInitialized)
                  Positioned(
                    left: 18,
                    right: 18,

                    // Above the floating
                    // bottom navigation.
                    bottom: 104,
                    child: IgnorePointer(
                      ignoring:
                      !_showProgressBar,
                      child: AnimatedSlide(
                        duration:
                        const Duration(
                          milliseconds: 220,
                        ),
                        curve: Curves.easeOut,
                        offset:
                        _showProgressBar
                            ? Offset.zero
                            : const Offset(
                          0,
                          0.35,
                        ),
                        child: AnimatedOpacity(
                          duration:
                          const Duration(
                            milliseconds: 220,
                          ),
                          curve:
                          Curves.easeOut,
                          opacity:
                          _showProgressBar
                              ? 1
                              : 0,
                          child:
                          _SimpleReelProgressBar(
                            controller:
                            _videoController!,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVideoBackground() {
    final controller = _videoController;

    if (controller != null &&
        controller.value.isInitialized) {
      final videoSize =
          controller.value.size;

      return ColoredBox(
        color: Colors.black,
        child: FittedBox(
          fit: BoxFit.cover,
          clipBehavior: Clip.hardEdge,
          child: SizedBox(
            width: videoSize.width,
            height: videoSize.height,
            child: VideoPlayer(
              controller,
            ),
          ),
        ),
      );
    }

    final thumbnail =
    widget.reel.thumbnailUrl?.trim();

    if (thumbnail != null &&
        thumbnail.isNotEmpty) {
      return TtNetworkImage(
        imageUrl: thumbnail,
      );
    }

    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF7896A2),
            Color(0xFFE7B7A3),
            Color(0xFF1F3A5F),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.smart_display_outlined,
          size: 82,
          color: Colors.white54,
        ),
      ),
    );
  }
}

class _SimpleReelProgressBar
    extends StatelessWidget {
  final VideoPlayerController controller;

  const _SimpleReelProgressBar({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<
        VideoPlayerValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                TtText(
                  _formatDuration(
                    value.position,
                  ),
                  fontSize: 12,
                  fontWeight:
                  FontWeight.w500,
                  color: Colors.white,
                ),
                const Spacer(),
                TtText(
                  _formatDuration(
                    value.duration,
                  ),
                  fontSize: 12,
                  fontWeight:
                  FontWeight.w500,
                  color: Colors.white,
                ),
              ],
            ),
            5.gh,
            SizedBox(
              height: 18,
              child: VideoProgressIndicator(
                controller,
                allowScrubbing: true,
                padding:
                const EdgeInsets.symmetric(
                  vertical: 7,
                ),
                colors:
                VideoProgressColors(
                  playedColor:
                  ColorUtils.secondaryColor,
                  bufferedColor:
                  Colors.white.withValues(
                    alpha: 0.55,
                  ),
                  backgroundColor:
                  Colors.white.withValues(
                    alpha: 0.30,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatDuration(
      Duration duration,
      ) {
    final totalSeconds =
        duration.inSeconds;

    final hours =
        totalSeconds ~/ 3600;

    final minutes =
        (totalSeconds % 3600) ~/ 60;

    final seconds =
        totalSeconds % 60;

    if (hours > 0) {
      return '$hours:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    }

    return '$minutes:'
        '${seconds.toString().padLeft(2, '0')}';
  }
}

class _ReelPlayButton
    extends StatelessWidget {
  final VoidCallback onPressed;

  const _ReelPlayButton({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TtZoomTap(
      onTap: onPressed,
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color:
              Colors.black.withValues(
                alpha: 0.20,
              ),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Icon(
          Icons.play_arrow_rounded,
          size: 42,
          color: ColorUtils.primaryColor,
        ),
      ),
    );
  }
}

class _ReelDarkGradient
    extends StatelessWidget {
  const _ReelDarkGradient();

  @override
  Widget build(BuildContext context) {
    return const IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [
              0,
              0.22,
              0.70,
              1,
            ],
            colors: [
              Color(0x66000000),
              Colors.transparent,
              Colors.transparent,
              Color(0x66000000),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReelErrorView
    extends StatelessWidget {
  final VoidCallback onRetry;

  const _ReelErrorView({
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black.withValues(
            alpha: 0.55,
          ),
          borderRadius:
          BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.video_library_outlined,
              color: Colors.white,
              size: 38,
            ),
            10.gh,
            const TtText(
              'Unable to load this reel.',
              fontSize: 14,
              color: Colors.white,
              textAlign: TextAlign.center,
            ),
            8.gh,
            TextButton(
              onPressed: onRetry,
              child: const TtText(
                'Try Again',
                fontSize: 14,
                fontWeight:
                FontWeight.w500,
                color:
                ColorUtils.secondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}