import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LegalWebViewPage extends StatefulWidget {
  final String title;
  final String url;

  const LegalWebViewPage({
    super.key,
    required this.title,
    required this.url,
  });

  @override
  State<LegalWebViewPage> createState() {
    return _LegalWebViewPageState();
  }
}

class _LegalWebViewPageState
    extends State<LegalWebViewPage> {
  late final WebViewController _controller;

  int _loadingProgress = 0;
  bool _hasLoadingError = false;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(
        JavaScriptMode.unrestricted,
      )
      ..setBackgroundColor(
        ColorUtils.scaffoldBackgroundColor,
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (!mounted) return;

            setState(() {
              _loadingProgress = 0;
              _hasLoadingError = false;
            });
          },
          onProgress: (progress) {
            if (!mounted) return;

            setState(() {
              _loadingProgress = progress;
            });
          },
          onPageFinished: (_) {
            if (!mounted) return;

            setState(() {
              _loadingProgress = 100;
            });
          },
          onWebResourceError: (error) {
            // Do not replace the whole page when an image,
            // font or another secondary resource fails.
            if (error.isForMainFrame != true ||
                !mounted) {
              return;
            }

            setState(() {
              _loadingProgress = 100;
              _hasLoadingError = true;
            });
          },
          onNavigationRequest: (request) {
            final uri = Uri.tryParse(
              request.url,
            );

            if (uri == null) {
              return NavigationDecision.prevent;
            }

            if (uri.scheme == 'https' ||
                uri.scheme == 'http') {
              return NavigationDecision.navigate;
            }

            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(
        Uri.parse(widget.url),
      );
  }

  void _retry() {
    setState(() {
      _loadingProgress = 0;
      _hasLoadingError = false;
    });

    _controller.loadRequest(
      Uri.parse(widget.url),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      ColorUtils.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor:
        ColorUtils.scaffoldBackgroundColor,
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
        title: TtText(
          widget.title,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: ColorUtils.primaryColor,
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: _hasLoadingError
                ? _LegalPageErrorView(
              onRetry: _retry,
            )
                : WebViewWidget(
              controller: _controller,
            ),
          ),
          if (!_hasLoadingError &&
              _loadingProgress < 100)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(
                value: _loadingProgress / 100,
                minHeight: 3,
                color:
                ColorUtils.secondaryColor,
                backgroundColor:
                const Color(0xFFE2E5E9),
              ),
            ),
        ],
      ),
    );
  }
}

class _LegalPageErrorView
    extends StatelessWidget {
  final VoidCallback onRetry;

  const _LegalPageErrorView({
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.language_rounded,
              size: 58,
              color: ColorUtils.greyTextColor,
            ),
            16.gh,
            const TtText(
              'Unable to load this page.',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ColorUtils.primaryColor,
              textAlign: TextAlign.center,
            ),
            8.gh,
            const TtText(
              'Please check your internet connection '
                  'and try again.',
              fontSize: 14,
              height: 1.4,
              color: ColorUtils.greyTextColor,
              textAlign: TextAlign.center,
            ),
            20.gh,
            SizedBox(
              width: 150,
              child: TtButton(
                onTap: onRetry,
                child: const TtText(
                  'Try Again',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}