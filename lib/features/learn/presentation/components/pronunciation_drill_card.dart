import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';

class PronunciationDrillCard extends StatelessWidget {
  final PronunciationDrillItem item;
  final PronunciationDrillStatus status;
  final VoidCallback onListen;
  final VoidCallback onRecord;

  const PronunciationDrillCard({
    super.key,
    required this.item,
    required this.status,
    required this.onListen,
    required this.onRecord,
  });

  bool get _isListening {
    return status == PronunciationDrillStatus.listening;
  }

  bool get _isRecording {
    return status == PronunciationDrillStatus.recording;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 24,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFDCE2E8),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: const BoxDecoration(
              color: ColorUtils.secondaryBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.mic_none_rounded,
              size: 44,
              color: ColorUtils.secondaryColor,
            ),
          ),
          24.gh,
          TtText(
            item.thaiWord,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: ColorUtils.primaryColor,
          ),
          10.gh,
          TtText(
            item.pronunciation,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: ColorUtils.secondaryColor,
          ),
          8.gh,
          TtText(
            item.meaning,
            fontSize: 14,
            color: ColorUtils.greyTextColor,
          ),
          24.gh,
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: [
              _PronunciationActionButton(
                label: _isListening
                    ? 'Listening'
                    : 'Listen',
                icon: _isListening
                    ? Icons.graphic_eq_rounded
                    : Icons.volume_up_outlined,
                foregroundColor: ColorUtils.secondaryColor,
                backgroundColor:
                ColorUtils.secondaryBackgroundColor,
                onTap: onListen,
              ),
              _PronunciationActionButton(
                label: _isRecording
                    ? 'Recording'
                    : 'Record',
                icon: _isRecording
                    ? Icons.graphic_eq_rounded
                    : Icons.mic_none_rounded,
                foregroundColor: Colors.white,
                backgroundColor: ColorUtils.primaryColor,
                onTap: onRecord,
              ),
            ],
          ),
          if (_isRecording) ...[
            16.gh,
            const TtText(
              'Tap Recording again when you are finished',
              fontSize: 14,
              color: ColorUtils.greyTextColor,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

class _PronunciationActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color foregroundColor;
  final Color backgroundColor;
  final VoidCallback onTap;

  const _PronunciationActionButton({
    required this.label,
    required this.icon,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TtZoomTap(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 11,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 21,
              color: foregroundColor,
            ),
            7.gw,
            TtText(
              label,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: foregroundColor,
            ),
          ],
        ),
      ),
    );
  }
}