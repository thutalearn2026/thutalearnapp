import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';

class LearnCourseCard extends StatelessWidget {
  final CourseModel course;
  final int index;
  final VoidCallback onTap;

  const LearnCourseCard({
    super.key,
    required this.course,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = _accentColor(index);

    return TtZoomTap(
      onTap: () {
        HapticFeedback.mediumImpact();
        onTap();
      },
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        elevation: 2,
        shadowColor: Colors.black.withValues(
          alpha: 0.12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CourseImageView(
              imageUrl: course.image,
              accentColor: accentColor,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  12,
                  12,
                  12,
                  12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _CourseChip(
                          label: course.level?.title ?? 'All levels',
                          color: accentColor,
                        ),
                        if (course.category != null)
                          _CourseChip(
                            label: course.category!.title,
                            color: ColorUtils.primaryColor,
                          ),
                      ],
                    ),
                    10.gh,
                    TtText(
                      course.title,
                      fontSize: 14,
                      height: 1.3,
                      fontWeight: FontWeight.bold,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (course.teacher != null) ...[
                      8.gh,
                      Row(
                        children: [
                          const Icon(
                            Icons.person_outline_rounded,
                            size: 16,
                            color: ColorUtils.greyTextColor,
                          ),
                          4.gw,
                          Expanded(
                            child: TtText(
                              course.teacher!.name,
                              fontSize: 12,
                              color: ColorUtils.greyTextColor,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const Spacer(),
                    const Divider(
                      height: 18,
                      color: Color(0xFFE5EAF0),
                    ),
                    Row(
                      spacing: 2,
                      children: [
                        // const Icon(
                        //   Icons.menu_book_outlined,
                        //   size: 16,
                        //   color: ColorUtils.greyTextColor,
                        // ),
                        // 4.gw,
                        Expanded(
                          child: TtText(
                            '${course.moduleCount} module'
                            '${course.moduleCount == 1 ? '' : 's'}',
                            fontSize: 12,
                            color: ColorUtils.greyTextColor,
                          ),
                        ),
                        TtText(
                          '${course.chapterCount} chapters',
                          fontSize: 12,
                          color: accentColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
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

  Color _accentColor(int index) {
    const colors = [
      ColorUtils.secondaryColor,
      Color(0xFF4B79D8),
      Color(0xFFFF8A4C),
      Color(0xFF8B65D6),
    ];

    return colors[index % colors.length];
  }
}

class _CourseImageView extends StatelessWidget {
  final String? imageUrl;
  final Color accentColor;

  const _CourseImageView({
    required this.imageUrl,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final validImageUrl = imageUrl != null && imageUrl!.trim().isNotEmpty;

    return SizedBox(
      width: double.infinity,
      height: 105,
      child: validImageUrl
          ? TtNetworkImage(
              imageUrl: imageUrl!,
              width: double.infinity,
              height: 105,
            )
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    accentColor,
                    accentColor.withValues(alpha: 0.65),
                  ],
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.local_library_outlined,
                  size: 42,
                  color: Colors.white,
                ),
              ),
            ),
    );
  }
}

class _CourseChip extends StatelessWidget {
  final String label;
  final Color color;

  const _CourseChip({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TtText(
        label,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: color,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
