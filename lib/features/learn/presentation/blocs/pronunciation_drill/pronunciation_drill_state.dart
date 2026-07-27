part of 'pronunciation_drill_bloc.dart';

enum PronunciationDrillStatus {
  idle,
  listening,
  recording,
  feedback,
  completed,
}

class PronunciationDrillState {
  final List<PronunciationDrillItem> items;
  final int currentIndex;
  final PronunciationDrillStatus status;
  final String? feedback;

  const PronunciationDrillState({
    required this.items,
    required this.currentIndex,
    required this.status,
    this.feedback,
  });

  PronunciationDrillItem get currentItem {
    return items[currentIndex];
  }

  double get progress {
    if (items.isEmpty) {
      return 0;
    }

    return (currentIndex + 1) / items.length;
  }

  bool get isListening {
    return status == PronunciationDrillStatus.listening;
  }

  bool get isRecording {
    return status == PronunciationDrillStatus.recording;
  }

  bool get hasFeedback {
    return status == PronunciationDrillStatus.feedback;
  }

  PronunciationDrillState copyWith({
    int? currentIndex,
    PronunciationDrillStatus? status,
    String? feedback,
    bool clearFeedback = false,
  }) {
    return PronunciationDrillState(
      items: items,
      currentIndex: currentIndex ?? this.currentIndex,
      status: status ?? this.status,
      feedback:
      clearFeedback ? null : feedback ?? this.feedback,
    );
  }
}