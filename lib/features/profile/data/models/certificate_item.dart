class CertificateItem {
  final String level;
  final String moduleTitle;
  final String issuedDate;
  final String? imagePath;
  final String? downloadUrl;

  const CertificateItem({
    required this.level,
    required this.moduleTitle,
    required this.issuedDate,
    this.imagePath,
    this.downloadUrl,
  });
}