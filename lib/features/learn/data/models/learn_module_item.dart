enum LearnModuleStatus {
  completed,
  inProgress,
  locked,
}

class LearnModuleItem {
  final int moduleNumber;
  final String title;
  final String description;
  final LearnModuleStatus status;
  final double progress;
  final bool quizPassed;

  const LearnModuleItem({
    required this.moduleNumber,
    required this.title,
    required this.description,
    required this.status,
    this.progress = 0,
    this.quizPassed = false,
  });
}