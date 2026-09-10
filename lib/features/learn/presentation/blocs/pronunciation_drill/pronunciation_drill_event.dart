part of 'pronunciation_drill_bloc.dart';

sealed class PronunciationDrillEvent {}

class PronunciationListenPressed
    extends PronunciationDrillEvent {}

class PronunciationRecordPressed
    extends PronunciationDrillEvent {}

class PronunciationRecordingCompleted
    extends PronunciationDrillEvent {}

class PronunciationNextPressed
    extends PronunciationDrillEvent {}

class PronunciationRestartPressed
    extends PronunciationDrillEvent {}