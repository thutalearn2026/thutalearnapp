class ModuleDetailArgs {
  final String courseId;
  final String moduleId;
  final int moduleNumber;
  final String? teacherName;

  const ModuleDetailArgs({
    required this.courseId,
    required this.moduleId,
    required this.moduleNumber,
    this.teacherName,
  });
}