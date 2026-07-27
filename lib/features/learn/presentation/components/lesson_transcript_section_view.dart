import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thuta_learn/core/core.dart';

class LessonTranscriptSectionView extends StatefulWidget {
  const LessonTranscriptSectionView({super.key});

  @override
  State<LessonTranscriptSectionView> createState() =>
      _LessonTranscriptSectionViewState();
}

class _LessonTranscriptSectionViewState
    extends State<LessonTranscriptSectionView> {
  final ScrollController _scrollController = ScrollController();

  static const String _plainTranscript = '''
The moon is common phrases in Thai.
Higher body, my name is a.
Welcome to the call Thai.
Words and phrases will be introduced in this lesson.
This is your opportunity to export the most useful expressions.
''';

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _copyTranscript() async {
    await Clipboard.setData(
      const ClipboardData(text: _plainTranscript),
    );

    if (mounted) {
      context.showSnackBar('Transcript copied');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      padding: const EdgeInsets.fromLTRB(16, 14, 10, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ColorUtils.secondaryColor.withValues(alpha: 0.7),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: TtText(
                  'Transcript',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: ColorUtils.primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const TtText(
                  '1x',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: ColorUtils.primaryColor,
                ),
              ),
              10.gw,
              IconButton(
                onPressed: _copyTranscript,
                icon: const Icon(
                  Icons.copy_rounded,
                  color: ColorUtils.primaryColor,
                ),
              ),
            ],
          ),
          12.gh,
          Expanded(
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.only(right: 14),
                child: Text.rich(
                  TextSpan(
                    style: const TextStyle(
                      fontFamily: 'helvetica_neue',
                      fontSize: 14,
                      height: 1.7,
                      color: ColorUtils.primaryColor,
                    ),
                    children: [
                      const TextSpan(
                        text:
                        'The moon is common phrases in\n',
                      ),
                      TextSpan(
                        text:
                        'Thai Higher Body My name is a\n',
                        style: TextStyle(
                          color: ColorUtils.secondaryColor,
                          decoration: TextDecoration.underline,
                          decorationColor:
                          ColorUtils.secondaryColor,
                        ),
                      ),
                      const TextSpan(
                        text:
                        'Welcome to the call Thai\n'
                            'Words and phrases will be introduced\n'
                            'This is your opportunity to export the most.',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}