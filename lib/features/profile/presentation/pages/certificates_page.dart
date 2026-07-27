import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/profile/profile.dart';

class CertificatesPage extends StatelessWidget {
  const CertificatesPage({super.key});

  static const List<CertificateItem> _certificates = [
    CertificateItem(
      level: 'Beginner',
      moduleTitle:
      'Module 1 : Thai Pronunciation Essentials',
      issuedDate: '16 Mar 2026',
    ),
    CertificateItem(
      level: 'Beginner',
      moduleTitle:
      'Module 2 : Greetings and Self-Introduction',
      issuedDate: '16 Mar 2026',
    ),
  ];

  Future<void> _downloadCertificate(
      BuildContext context,
      CertificateItem certificate,
      ) async {
    if (certificate.downloadUrl == null) {
      context.showSnackBar(
        'The certificate file will be available after '
            'API integration.',
      );

      return;
    }

    // Download the certificate using downloadUrl.
    //
    // Recommended production flow:
    // 1. Request the certificate file from the API.
    // 2. Save it to an application or downloads directory.
    // 3. Report download progress.
    // 4. Open or share the downloaded PDF.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: ColorUtils.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: context.pop,
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: ColorUtils.primaryColor,
          ),
        ),
        title: const TtText(
          'Certifications',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: _certificates.isEmpty
          ? const CertificatesEmptyView()
          : ListView.separated(
        padding: const EdgeInsets.fromLTRB(
          16,
          24,
          16,
          32,
        ),
        itemCount: _certificates.length,
        separatorBuilder: (context, index) {
          return 16.gh;
        },
        itemBuilder: (context, index) {
          final certificate = _certificates[index];

          return CertificateCard(
            certificate: certificate,
            onDownload: () {
              _downloadCertificate(
                context,
                certificate,
              );
            },
          );
        },
      ),
    );
  }
}

class CertificatesEmptyView extends StatelessWidget {
  const CertificatesEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: const BoxDecoration(
                color: ColorUtils.secondaryBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.workspace_premium_outlined,
                size: 45,
                color: ColorUtils.secondaryColor,
              ),
            ),
            20.gh,
            const TtText(
              'No certificates yet',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            10.gh,
            const TtText(
              'Complete learning modules and their quizzes '
                  'to earn certificates.',
              fontSize: 14,
              height: 1.4,
              textAlign: TextAlign.center,
              color: ColorUtils.greyTextColor,
            ),
          ],
        ),
      ),
    );
  }
}