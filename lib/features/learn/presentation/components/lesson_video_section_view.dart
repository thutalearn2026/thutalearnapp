import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';
import 'package:video_player/video_player.dart';

class LessonVideoSectionView extends StatefulWidget {
  final ChapterVideoModel video;

  const LessonVideoSectionView({
    super.key,
    required this.video,
  });

  @override
  State<LessonVideoSectionView> createState() {
    return _LessonVideoSectionViewState();
  }
}

class _LessonVideoSectionViewState
    extends State<LessonVideoSectionView> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _initializePlayer();
  }

  @override
  void didUpdateWidget(
      LessonVideoSectionView oldWidget,
      ) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.video.id != widget.video.id) {
      _releaseControllers();

      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      _initializePlayer();
    }
  }

  Future<void> _initializePlayer() async {
    final playableUrl = _resolvePlayableUrl(
      widget.video,
    );

    if (playableUrl == null) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage =
        'This lesson does not currently contain a direct '
            'MP4 or HLS playback URL.';
      });

      return;
    }

    try {
      final videoController =
      VideoPlayerController.networkUrl(
        Uri.parse(playableUrl),
      );

      await videoController.initialize();

      if (!mounted) {
        videoController.dispose();
        return;
      }

      final aspectRatio =
      videoController.value.aspectRatio > 0
          ? videoController.value.aspectRatio
          : 16 / 9;

      final chewieController = ChewieController(
        videoPlayerController: videoController,
        aspectRatio: aspectRatio,
        autoPlay: false,
        looping: false,
        allowFullScreen: true,
        allowMuting: true,
        allowPlaybackSpeedChanging: true,
        showControls: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: ColorUtils.secondaryColor,
          handleColor: ColorUtils.secondaryColor,
          bufferedColor: Colors.white54,
          backgroundColor: Colors.white30,
        ),
        errorBuilder: (context, errorMessage) {
          return _VideoMessageView(
            thumbnailUrl: widget.video.thumbnail,
            icon: Icons.error_outline_rounded,
            message: 'Unable to play this video.',
          );
        },
      );

      setState(() {
        _videoController = videoController;
        _chewieController = chewieController;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage =
        'The video could not be initialized. '
            'Please try again.';
      });
    }
  }

  String? _resolvePlayableUrl(
      ChapterVideoModel video,
      ) {
    final candidates = [
      video.videoPath,
      video.playerUrl,
    ];

    for (final candidate in candidates) {
      final value = candidate?.trim();

      if (value == null || value.isEmpty) {
        continue;
      }

      final uri = Uri.tryParse(value);

      if (uri == null ||
          !(uri.scheme == 'https' ||
              uri.scheme == 'http')) {
        continue;
      }

      final path = uri.path.toLowerCase();

      final isDirectMedia =
          path.endsWith('.mp4') ||
              path.endsWith('.m3u8') ||
              path.endsWith('.mov') ||
              path.endsWith('.webm');

      if (isDirectMedia) {
        return value;
      }

      // Non-Vimeo URLs may be redirecting playback
      // endpoints which video_player can initialize.
      if (video.videoSource?.toLowerCase() != 'vimeo') {
        return value;
      }
    }

    return null;
  }

  void _releaseControllers() {
    _chewieController?.dispose();
    _videoController?.dispose();

    _chewieController = null;
    _videoController = null;
  }

  @override
  void dispose() {
    _releaseControllers();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _VideoThumbnailView(
                thumbnailUrl: widget.video.thumbnail,
              ),
              Container(
                color: Colors.black.withValues(
                  alpha: 0.35,
                ),
              ),
              const Center(
                child: CircularProgressIndicator(
                  color: ColorUtils.secondaryColor,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return _VideoMessageView(
        thumbnailUrl: widget.video.thumbnail,
        icon: Icons.video_library_outlined,
        message: _errorMessage!,
      );
    }

    final controller = _chewieController;

    if (controller == null) {
      return _VideoMessageView(
        thumbnailUrl: widget.video.thumbnail,
        icon: Icons.error_outline_rounded,
        message: 'Video player is unavailable.',
      );
    }

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ColoredBox(
          color: Colors.black,
          child: Chewie(
            controller: controller,
          ),
        ),
      ),
    );
  }
}

class _VideoMessageView extends StatelessWidget {
  final String? thumbnailUrl;
  final IconData icon;
  final String message;

  const _VideoMessageView({
    required this.thumbnailUrl,
    required this.icon,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _VideoThumbnailView(
              thumbnailUrl: thumbnailUrl,
            ),
            Container(
              color: Colors.black.withValues(
                alpha: 0.62,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 38,
                    color: Colors.white,
                  ),
                  12.gh,
                  TtText(
                    message,
                    fontSize: 14,
                    height: 1.4,
                    color: Colors.white,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VideoThumbnailView extends StatelessWidget {
  final String? thumbnailUrl;

  const _VideoThumbnailView({
    required this.thumbnailUrl,
  });

  @override
  Widget build(BuildContext context) {
    final url = thumbnailUrl?.trim();

    if (url == null || url.isEmpty) {
      return const ColoredBox(
        color: Color(0xFFCBD8DE),
        child: Center(
          child: Icon(
            Icons.video_library_outlined,
            size: 60,
            color: ColorUtils.primaryColor,
          ),
        ),
      );
    }

    return TtNetworkImage(
      imageUrl: url,
    );
  }
}