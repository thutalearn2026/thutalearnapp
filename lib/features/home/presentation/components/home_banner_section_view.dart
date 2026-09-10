import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:thuta_learn/core/core.dart';

class HomeBannerSectionView extends StatefulWidget {
  final List<String> imageUrls;
  final ValueChanged<int>? onBannerTap;

  const HomeBannerSectionView({
    super.key,
    required this.imageUrls,
    this.onBannerTap,
  });

  @override
  State<HomeBannerSectionView> createState() {
    return _HomeBannerSectionViewState();
  }
}

class _HomeBannerSectionViewState extends State<HomeBannerSectionView> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(
      viewportFraction: 1.0,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrls.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 4,
      ),
      child: Column(
        children: [
          SizedBox(
            height: 172,
            child: PageView.builder(
              controller: _pageController,
              clipBehavior: Clip.hardEdge,
              physics: const BouncingScrollPhysics(),
              itemCount: widget.imageUrls.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: _HomeBannerItemView(
                    imageUrl: widget.imageUrls[index],
                    onTap: () {
                      widget.onBannerTap?.call(index);
                    },
                  ),
                );
              },
            ),
          ),
          if (widget.imageUrls.length > 1) ...[
            12.gh,
            SmoothPageIndicator(
              controller: _pageController,
              count: widget.imageUrls.length,
              effect: ExpandingDotsEffect(
                expansionFactor: 3,
                spacing: 6,
                radius: 12,
                dotWidth: 7,
                dotHeight: 7,
                dotColor: ColorUtils.greyTextColor.withValues(
                  alpha: 0.30,
                ),
                activeDotColor: ColorUtils.secondaryColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _HomeBannerItemView extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onTap;

  const _HomeBannerItemView({
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TtZoomTap(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFFE3E8EF),
          ),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withValues(
          //       alpha: 0.08,
          //     ),
          //     blurRadius: 14,
          //     offset: const Offset(0, 5),
          //   ),
          // ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(17),
          child: Stack(
            fit: StackFit.expand,
            children: [
              TtNetworkImage(
                imageUrl: imageUrl,
              ),

              // A subtle overlay makes light-colored
              // images fit naturally with the app UI.
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Color(0x18000000),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
