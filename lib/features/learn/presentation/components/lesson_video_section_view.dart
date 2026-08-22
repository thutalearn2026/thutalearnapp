import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';
import 'package:video_player/video_player.dart';

class LessonVideoSectionView
    extends StatefulWidget {
  final ChapterVideoModel video;

  /// Private local MP4 path returned after the video
  /// download has completed.
  final String? localFilePath;

  const LessonVideoSectionView({
    super.key,
    required this.video,
    this.localFilePath,
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

  int _initializationId = 0;

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

    final videoChanged =
        oldWidget.video.id != widget.video.id;

    final localFileChanged =
        oldWidget.localFilePath !=
            widget.localFilePath;

    if (videoChanged || localFileChanged) {
      _releaseControllers();

      _isLoading = true;
      _errorMessage = null;

      _initializePlayer();
    }
  }

  Future<void> _initializePlayer() async {
    final initializationId =
    ++_initializationId;

    final playbackSources =
    _buildPlaybackSources(widget.video);

    if (playbackSources.isEmpty) {
      if (!mounted ||
          initializationId !=
              _initializationId) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage =
        'This lesson does not currently contain '
            'an offline, HLS, or MP4 playback source.';
      });

      return;
    }

    for (final source in playbackSources) {
      VideoPlayerController? videoController;

      try {
        videoController =
            _createVideoController(source);

        await videoController
            .initialize()
            .timeout(
          const Duration(seconds: 25),
        );

        if (!mounted ||
            initializationId !=
                _initializationId) {
          await videoController.dispose();
          return;
        }

        final videoAspectRatio =
            videoController.value.aspectRatio;

        final aspectRatio =
        videoAspectRatio > 0
            ? videoAspectRatio
            : 16 / 9;

        final chewieController =
        ChewieController(
          videoPlayerController:
          videoController,
          aspectRatio: aspectRatio,
          autoInitialize: false,
          autoPlay: false,
          looping: false,
          allowFullScreen: true,
          allowMuting: true,
          allowPlaybackSpeedChanging: true,
          showControls: true,
          materialProgressColors:
          ChewieProgressColors(
            playedColor:
            ColorUtils.secondaryColor,
            handleColor:
            ColorUtils.secondaryColor,
            bufferedColor: Colors.white54,
            backgroundColor: Colors.white30,
          ),
          placeholder: _VideoThumbnailView(
            thumbnailUrl:
            widget.video.thumbnail,
          ),
          errorBuilder: (
              context,
              errorMessage,
              ) {
            return _VideoMessageView(
              thumbnailUrl:
              widget.video.thumbnail,
              icon:
              Icons.error_outline_rounded,
              message:
              'Unable to play this video.',
              onRetry: _retry,
            );
          },
        );

        setState(() {
          _videoController =
              videoController;
          _chewieController =
              chewieController;
          _isLoading = false;
          _errorMessage = null;
        });

        return;
      } catch (_) {
        if (videoController != null) {
          await videoController.dispose();
        }

        // If the local video is missing or corrupted,
        // continue with HLS and MP4 network sources.
      }
    }

    if (!mounted ||
        initializationId !=
            _initializationId) {
      return;
    }

    setState(() {
      _isLoading = false;
      _errorMessage =
      'The video could not be initialized. '
          'Please check your connection or '
          'download the lesson again.';
    });
  }

  VideoPlayerController _createVideoController(
      _PlaybackSource source,
      ) {
    final localFilePath =
        source.localFilePath;

    if (localFilePath != null) {
      return VideoPlayerController.file(
        File(localFilePath),
      );
    }

    return VideoPlayerController.networkUrl(
      source.uri!,
      formatHint: source.formatHint,
    );
  }

  List<_PlaybackSource> _buildPlaybackSources(
      ChapterVideoModel video,
      ) {
    final sources = <_PlaybackSource>[];
    final addedUrls = <String>{};

    /*
     * 1. Downloaded local video
     */

    final localFilePath =
    widget.localFilePath?.trim();

    if (localFilePath != null &&
        localFilePath.isNotEmpty) {
      final localFile = File(
        localFilePath,
      );

      if (localFile.existsSync()) {
        sources.add(
          _PlaybackSource.local(
            localFilePath,
          ),
        );
      }
    }

    void addNetworkSource(
        String? rawUrl, {
          VideoFormat? formatHint,
        }) {
      final value = rawUrl?.trim();

      if (value == null || value.isEmpty) {
        return;
      }

      final uri = Uri.tryParse(value);

      if (uri == null ||
          !(uri.scheme == 'http' ||
              uri.scheme == 'https') ||
          uri.host.isEmpty) {
        return;
      }

      if (!addedUrls.add(uri.toString())) {
        return;
      }

      sources.add(
        _PlaybackSource.network(
          uri: uri,
          formatHint: formatHint,
        ),
      );
    }

    /*
     * 2. Adaptive HLS stream
     */

    addNetworkSource(
      video.hlsUrl,
      formatHint: VideoFormat.hls,
    );

    /*
     * 3. MP4 fallback sources
     *
     * Highest resolution is attempted first.
     */

    final mp4Files = [
      ...video.mp4Files,
    ]..sort(
          (first, second) {
        return (second.height ?? 0)
            .compareTo(
          first.height ?? 0,
        );
      },
    );

    for (final mp4File in mp4Files) {
      addNetworkSource(
        mp4File.link,
      );
    }

    /*
     * 4. Future direct video_path support
     */

    final videoPath =
    video.videoPath?.trim();

    if (videoPath != null &&
        videoPath.isNotEmpty) {
      final uri =
      Uri.tryParse(videoPath);

      final path =
          uri?.path.toLowerCase() ?? '';

      addNetworkSource(
        videoPath,
        formatHint:
        path.endsWith('.m3u8')
            ? VideoFormat.hls
            : null,
      );
    }

    return sources;
  }

  void _retry() {
    _releaseControllers();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    _initializePlayer();
  }

  void _releaseControllers() {
    _initializationId++;

    final chewieController =
        _chewieController;

    final videoController =
        _videoController;

    _chewieController = null;
    _videoController = null;

    chewieController?.dispose();
    videoController?.dispose();
  }

  @override
  void dispose() {
    _releaseControllers();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _VideoLoadingView(
        thumbnailUrl:
        widget.video.thumbnail,
      );
    }

    if (_errorMessage != null) {
      return _VideoMessageView(
        thumbnailUrl:
        widget.video.thumbnail,
        icon:
        Icons.video_library_outlined,
        message: _errorMessage!,
        onRetry: _retry,
      );
    }

    final chewieController =
        _chewieController;

    if (chewieController == null) {
      return _VideoMessageView(
        thumbnailUrl:
        widget.video.thumbnail,
        icon:
        Icons.error_outline_rounded,
        message:
        'Video player is unavailable.',
        onRetry: _retry,
      );
    }

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(
        borderRadius:
        BorderRadius.circular(16),
        child: ColoredBox(
          color: Colors.black,
          child: Chewie(
            controller:
            chewieController,
          ),
        ),
      ),
    );
  }
}

class _PlaybackSource {
  final Uri? uri;
  final String? localFilePath;
  final VideoFormat? formatHint;

  const _PlaybackSource.network({
    required this.uri,
    this.formatHint,
  }) : localFilePath = null;

  const _PlaybackSource.local(
      this.localFilePath,
      )   : uri = null,
        formatHint = null;
}

class _VideoLoadingView
    extends StatelessWidget {
  final String? thumbnailUrl;

  const _VideoLoadingView({
    required this.thumbnailUrl,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(
        borderRadius:
        BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _VideoThumbnailView(
              thumbnailUrl: thumbnailUrl,
            ),
            ColoredBox(
              color: Colors.black.withValues(
                alpha: 0.35,
              ),
            ),
            const Center(
              child:
              CircularProgressIndicator(
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

class _VideoMessageView
    extends StatelessWidget {
  final String? thumbnailUrl;
  final IconData icon;
  final String message;
  final VoidCallback? onRetry;

  const _VideoMessageView({
    required this.thumbnailUrl,
    required this.icon,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(
        borderRadius:
        BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _VideoThumbnailView(
              thumbnailUrl: thumbnailUrl,
            ),
            ColoredBox(
              color: Colors.black.withValues(
                alpha: 0.65,
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 38,
                    color: Colors.white,
                  ),
                  10.gh,
                  TtText(
                    message,
                    fontSize: 14,
                    height: 1.4,
                    color: Colors.white,
                    textAlign:
                    TextAlign.center,
                  ),
                  if (onRetry != null) ...[
                    10.gh,
                    TextButton.icon(
                      onPressed: onRetry,
                      icon: const Icon(
                        Icons.refresh_rounded,
                        color: Colors.white,
                      ),
                      label: const TtText(
                        'Try Again',
                        fontSize: 14,
                        fontWeight:
                        FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VideoThumbnailView
    extends StatelessWidget {
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
            color:
            ColorUtils.primaryColor,
          ),
        ),
      );
    }

    return TtNetworkImage(
      imageUrl: url,
    );
  }
}