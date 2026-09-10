import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';

class VocabularyFlashCardView extends StatefulWidget {
  final VocabularyFlashCardItem item;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final VoidCallback onAudio;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const VocabularyFlashCardView({
    super.key,
    required this.item,
    required this.isFavorite,
    required this.onFavorite,
    required this.onAudio,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  State<VocabularyFlashCardView> createState() =>
      _VocabularyFlashCardViewState();
}

class _VocabularyFlashCardViewState
    extends State<VocabularyFlashCardView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  bool _showingBack = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didUpdateWidget(
      covariant VocabularyFlashCardView oldWidget,
      ) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.item != widget.item) {
      _controller.value = 0;
      _showingBack = false;
    }
  }

  void _flipCard() {
    if (_controller.isAnimating) {
      return;
    }

    if (_showingBack) {
      _controller.reverse();
    } else {
      _controller.forward();
    }

    _showingBack = !_showingBack;
  }

  void _handleHorizontalDragEnd(
      DragEndDetails details,
      ) {
    final velocity =
        details.primaryVelocity ?? 0;

    if (velocity > 350) {
      widget.onNext();
    } else if (velocity < -350) {
      widget.onPrevious();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flipCard,
      onHorizontalDragEnd: _handleHorizontalDragEnd,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final angle = _animation.value * math.pi;
          final showFront = angle <= math.pi / 2;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0014)
              ..rotateY(angle),
            child: showFront
                ? _FlashCardFront(item: widget.item)
                : Transform(
              alignment: Alignment.center,
              transform:
              Matrix4.rotationY(math.pi),
              child: _FlashCardBack(
                item: widget.item,
                isFavorite: widget.isFavorite,
                onFavorite: widget.onFavorite,
                onAudio: widget.onAudio,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FlashCardFront extends StatelessWidget {
  final VocabularyFlashCardItem item;

  const _FlashCardFront({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return _FlashCardFrame(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TtText(
                item.thaiWord,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: ColorUtils.primaryColor,
              ),
              10.gw,
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: ColorUtils.secondaryBackgroundColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.volume_up_outlined,
                  color: ColorUtils.primaryColor,
                  size: 22,
                ),
              ),
            ],
          ),
          20.gh,
          TtText(
            item.pronunciation,
            fontSize: 14,
            color: ColorUtils.greyTextColor,
          ),
          14.gh,
          TtText(
            item.partOfSpeech,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.italic,
            color: ColorUtils.primaryColor,
          ),
        ],
      ),
    );
  }
}

class _FlashCardBack extends StatelessWidget {
  final VocabularyFlashCardItem item;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final VoidCallback onAudio;

  const _FlashCardBack({
    required this.item,
    required this.isFavorite,
    required this.onFavorite,
    required this.onAudio,
  });

  @override
  Widget build(BuildContext context) {
    return _FlashCardFrame(
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: _FlashCardImage(item: item),
          ),
          Expanded(
            flex: 4,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      TtText(
                        item.thaiWord,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: ColorUtils.primaryColor,
                      ),
                      8.gw,
                      IconButton(
                        onPressed: onAudio,
                        icon: const Icon(
                          Icons.volume_up_outlined,
                          color: ColorUtils.secondaryColor,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: onFavorite,
                        icon: Icon(
                          isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: isFavorite
                              ? ColorUtils.secondaryColor
                              : ColorUtils.greyTextColor,
                        ),
                      ),
                    ],
                  ),
                  8.gh,
                  TtText(
                    '${item.partOfSpeech}. ${item.definition}',
                    fontSize: 14,
                    height: 1.4,
                    color: ColorUtils.primaryColor,
                  ),
                  14.gh,
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        TtText(
                          item.thaiExample,
                          fontSize: 14,
                          height: 1.4,
                          color: ColorUtils.primaryColor,
                        ),
                        8.gh,
                        TtText(
                          '(${item.pronunciationExample})',
                          fontSize: 14,
                          height: 1.4,
                          fontStyle: FontStyle.italic,
                          color: ColorUtils.primaryColor,
                        ),
                        8.gh,
                        TtText(
                          item.englishExample,
                          fontSize: 14,
                          height: 1.4,
                          fontStyle: FontStyle.italic,
                          color: ColorUtils.primaryColor,
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
    );
  }
}

class _FlashCardImage extends StatelessWidget {
  final VocabularyFlashCardItem item;

  const _FlashCardImage({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    if (item.imagePath != null) {
      return Image.asset(
        item.imagePath!,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE7B78D),
            Color(0xFFB97868),
          ],
        ),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_rounded,
            size: 80,
            color: Colors.white,
          ),
          SizedBox(height: 14),
          TtText(
            'Vocabulary illustration',
            fontSize: 14,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

class _FlashCardFrame extends StatelessWidget {
  final Widget child;

  const _FlashCardFrame({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F2F5),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}