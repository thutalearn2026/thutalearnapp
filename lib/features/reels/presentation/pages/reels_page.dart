import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/reels/reels.dart';

class ReelsPage extends StatefulWidget {
  final bool isActive;

  const ReelsPage({
    super.key,
    this.isActive = true,
  });

  @override
  State<ReelsPage> createState() {
    return _ReelsPageState();
  }
}

class _ReelsPageState extends State<ReelsPage> {
  int _currentIndex = 0;
  bool _isMuted = false;

  static const List<ReelItem> _reels = [
    ReelItem(
      id: 'reel-1',
      title: 'Thai conversation for beginners',
      videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      thumbnailUrl: 'https://images.unsplash.com/photo-1544717305-2782549b5136?w=1000',
    ),
    ReelItem(
      id: 'reel-2',
      title: 'Learn useful Thai expressions',
      videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      thumbnailUrl: 'https://images.unsplash.com/photo-1503676260728-1c00da094a0b?w=1000',
    ),
    ReelItem(
      id: 'reel-3',
      title: 'Daily Thai vocabulary',
      videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      thumbnailUrl: 'https://images.unsplash.com/photo-1523240795612-9a054b0db644?w=1000',
    ),
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.black,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        child: ColoredBox(
          color: Colors.black,
          child: Stack(
            fit: StackFit.expand,
            children: [
              PageView.builder(
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                itemCount: _reels.length,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  final reel = _reels[index];

                  return ReelVideoView(
                    key: ValueKey(reel.id),
                    reel: reel,
                    isActive: widget.isActive && index == _currentIndex,
                    isMuted: _isMuted,
                  );
                },
              ),

              // Fixed overlay. It does not move when
              // the PageView changes.
              _FixedReelsHeader(
                isMuted: _isMuted,
                onMutePressed: _toggleMute,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FixedReelsHeader extends StatelessWidget {
  final bool isMuted;
  final VoidCallback onMutePressed;

  const _FixedReelsHeader({
    required this.isMuted,
    required this.onMutePressed,
  });

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.paddingOf(context).top;

    return Positioned(
      top: statusBarHeight + 32,
      left: 20,
      right: 20,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.smart_display_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                  9.gw,
                  const TtText(
                    'Reels',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          TtZoomTap(
            onTap: onMutePressed,
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withValues(
                  alpha: 0.32,
                ),
                border: Border.all(
                  color: Colors.white.withValues(
                    alpha: 0.30,
                  ),
                ),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(
                  milliseconds: 180,
                ),
                child: Icon(
                  isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                  key: ValueKey(isMuted),
                  color: Colors.white,
                  size: 27,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
