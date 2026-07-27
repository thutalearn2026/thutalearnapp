import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/profile/profile.dart';

class CertificateCard extends StatelessWidget {
  final CertificateItem certificate;
  final VoidCallback onDownload;

  const CertificateCard({
    super.key,
    required this.certificate,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: const DashedRoundedBorderPainter(
        color: Color(0xFFC9D1DA),
        borderRadius: 16,
        strokeWidth: 1.3,
        dashLength: 5,
        gapLength: 4,
      ),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(
          minHeight: 150,
        ),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CertificateThumbnail(
              imagePath: certificate.imagePath,
            ),
            16.gw,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CertificateLevelBadge(
                    level: certificate.level,
                  ),
                  10.gh,
                  TtText(
                    certificate.moduleTitle,
                    fontSize: 16,
                    height: 1.3,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    color: ColorUtils.primaryColor,
                  ),
                  12.gh,
                  Row(
                    children: [
                      const Icon(
                        Icons.event_available_outlined,
                        size: 22,
                        color: ColorUtils.primaryColor,
                      ),
                      8.gw,
                      Expanded(
                        child: TtText(
                          certificate.issuedDate,
                          fontSize: 14,
                          color: ColorUtils.greyTextColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: IconButton(
                tooltip: 'Download certificate',
                onPressed: onDownload,
                icon: const Icon(
                  Icons.download_outlined,
                  size: 29,
                  color: ColorUtils.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CertificateThumbnail extends StatelessWidget {
  final String? imagePath;

  const CertificateThumbnail({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 86,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFE4E7EB),
        ),
      ),
      child: imagePath != null
          ? Image.asset(
        imagePath!,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      )
          : const CertificatePlaceholder(),
    );
  }
}

class CertificatePlaceholder extends StatelessWidget {
  const CertificatePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: ColoredBox(
            color: Colors.white,
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          bottom: 0,
          child: ClipPath(
            clipper: CertificateDecorationClipper(),
            child: Container(
              width: 42,
              color: ColorUtils.primaryColor,
            ),
          ),
        ),
        const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.workspace_premium_outlined,
                size: 27,
                color: Color(0xFFC39B3A),
              ),
              SizedBox(height: 3),
              TtText(
                'CERTIFICATE',
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: ColorUtils.primaryColor,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CertificateDecorationClipper
    extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(size.width * 0.45, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..lineTo(size.width * 0.5, size.height * 0.5)
      ..close();
  }

  @override
  bool shouldReclip(
      covariant CertificateDecorationClipper oldClipper,
      ) {
    return false;
  }
}

class CertificateLevelBadge extends StatelessWidget {
  final String level;

  const CertificateLevelBadge({
    super.key,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
              color: ColorUtils.secondaryColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.school_outlined,
              size: 14,
              color: Colors.white,
            ),
          ),
          6.gw,
          TtText(
            level,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: ColorUtils.primaryColor,
          ),
        ],
      ),
    );
  }
}

class DashedRoundedBorderPainter extends CustomPainter {
  final Color color;
  final double borderRadius;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;

  const DashedRoundedBorderPainter({
    required this.color,
    required this.borderRadius,
    required this.strokeWidth,
    required this.dashLength,
    required this.gapLength,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          rect,
          Radius.circular(borderRadius),
        ),
      );

    for (final metric in path.computeMetrics()) {
      double distance = 0;

      while (distance < metric.length) {
        final end = math.min(
          distance + dashLength,
          metric.length,
        );

        canvas.drawPath(
          metric.extractPath(distance, end),
          paint,
        );

        distance += dashLength + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(
      covariant DashedRoundedBorderPainter oldDelegate,
      ) {
    return oldDelegate.color != color ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dashLength != dashLength ||
        oldDelegate.gapLength != gapLength;
  }
}