import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';

class ResourceDetailPage extends StatelessWidget {
  final ResourceDetailArgs args;

  const ResourceDetailPage({
    super.key,
    required this.args,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        return getIt<ResourceDetailBloc>()..add(
          OnGetResourceDetail(
            chapterId: args.chapterId,
            resourceId: args.resourceId,
          ),
        );
      },
      child: _ResourceDetailView(
        args: args,
      ),
    );
  }
}

class _ResourceDetailView extends StatefulWidget {
  final ResourceDetailArgs args;

  const _ResourceDetailView({
    required this.args,
  });

  @override
  State<_ResourceDetailView> createState() {
    return _ResourceDetailViewState();
  }
}

class _ResourceDetailViewState extends State<_ResourceDetailView> {
  final PdfViewerController _pdfController = PdfViewerController();

  bool _isDocumentLoading = true;
  String? _documentError;
  int _currentPage = 1;
  int _pageCount = 0;

  void _retryApi() {
    setState(() {
      _isDocumentLoading = true;
      _documentError = null;
      _currentPage = 1;
      _pageCount = 0;
    });

    context.read<ResourceDetailBloc>().add(
      OnGetResourceDetail(
        chapterId: widget.args.chapterId,
        resourceId: widget.args.resourceId,
      ),
    );
  }

  bool _isPdf(ChapterResourceModel resource) {
    final type = resource.fileType.toLowerCase();
    final uri = Uri.tryParse(resource.fileUrl);
    final path = uri?.path.toLowerCase() ?? '';

    return type == 'pdf' || path.endsWith('.pdf');
  }

  @override
  void dispose() {
    _pdfController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResourceDetailBloc, ResourceDetailState>(
      builder: (context, state) {
        if (state.isLoading && state.resource == null) {
          return const _ResourceLoadingPage();
        }

        if (state.status == ResourceDetailStatus.failure && state.resource == null) {
          return _ResourceErrorPage(
            message: state.message ?? 'Unable to load this resource.',
            onRetry: _retryApi,
          );
        }

        final resource = state.resource;

        if (resource == null) {
          return const SizedBox.shrink();
        }

        final displayTitle = resource.title.trim().replaceAll('_', ' ');

        return Scaffold(
          backgroundColor: ColorUtils.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              onPressed: context.pop,
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: ColorUtils.primaryColor,
              ),
            ),
            title: const TtText(
              'Resource Detail',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ColorUtils.primaryColor,
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(
                  16,
                  14,
                  16,
                  14,
                ),
                color: Colors.white,
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE34D59).withValues(alpha: 0.10),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.picture_as_pdf_outlined,
                        color: Color(0xFFE34D59),
                      ),
                    ),
                    12.gw,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TtText(
                            displayTitle,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: ColorUtils.primaryColor,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          5.gh,
                          TtText(
                            resource.fileType.toUpperCase(),
                            fontSize: 14,
                            color: ColorUtils.greyTextColor,
                          ),
                        ],
                      ),
                    ),
                    if (_pageCount > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: ColorUtils.secondaryBackgroundColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TtText(
                          '$_currentPage / $_pageCount',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: ColorUtils.primaryColor,
                        ),
                      ),
                  ],
                ),
              ),
              const Divider(
                height: 1,
                color: Color(0xFFE6E9ED),
              ),
              Expanded(
                child: _isPdf(resource)
                    ? _buildPdfViewer(
                        resource,
                        state.localFilePath,
                      )
                    : _UnsupportedResourceView(
                        fileType: resource.fileType,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPdfViewer(
      ChapterResourceModel resource,
      String? localFilePath,
      ) {
    if (_documentError != null) {
      return _PdfErrorView(
        message: _documentError!,
        onRetry: () {
          setState(() {
            _documentError = null;
            _isDocumentLoading = true;
          });
        },
      );
    }

    final localPath = localFilePath?.trim();

    final localFile = localPath == null ||
        localPath.isEmpty
        ? null
        : File(localPath);

    final hasLocalFile =
        localFile != null && localFile.existsSync();

    void handleDocumentLoaded(
        PdfDocumentLoadedDetails details,
        ) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isDocumentLoading = false;
        _documentError = null;
        _pageCount = details.document.pages.count;
        _currentPage = 1;
      });
    }

    void handlePageChanged(
        PdfPageChangedDetails details,
        ) {
      if (!mounted) {
        return;
      }

      setState(() {
        _currentPage = details.newPageNumber;
      });
    }

    void handleLoadFailed(
        PdfDocumentLoadFailedDetails details,
        ) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isDocumentLoading = false;
        _documentError = details.description.isEmpty
            ? 'Unable to open this PDF.'
            : details.description;
      });
    }

    final Widget viewer;

    if (hasLocalFile) {
      viewer = SfPdfViewer.file(
        localFile,
        key: ValueKey(
          'local:${localFile.path}',
        ),
        controller: _pdfController,
        canShowScrollHead: true,
        canShowScrollStatus: true,
        canShowPaginationDialog: true,
        enableDoubleTapZooming: true,
        enableTextSelection: true,
        pageSpacing: 8,
        onDocumentLoaded: handleDocumentLoaded,
        onPageChanged: handlePageChanged,
        onDocumentLoadFailed: handleLoadFailed,
      );
    } else {
      viewer = SfPdfViewer.network(
        resource.fileUrl,
        key: ValueKey(
          'network:${resource.fileUrl}',
        ),
        controller: _pdfController,
        canShowScrollHead: true,
        canShowScrollStatus: true,
        canShowPaginationDialog: true,
        enableDoubleTapZooming: true,
        enableTextSelection: true,
        pageSpacing: 8,
        onDocumentLoaded: handleDocumentLoaded,
        onPageChanged: handlePageChanged,
        onDocumentLoadFailed: handleLoadFailed,
      );
    }

    return Stack(
      children: [
        Positioned.fill(
          child: viewer,
        ),
        if (_isDocumentLoading)
          Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: TtText(
              hasLocalFile
                  ? 'Opening downloaded resource...'
                  : 'Opening resource...',
              fontSize: 14,
              color: ColorUtils.greyTextColor,
            ),
          ),
      ],
    );
  }
}

class _UnsupportedResourceView extends StatelessWidget {
  final String fileType;

  const _UnsupportedResourceView({
    required this.fileType,
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
              Icons.insert_drive_file_outlined,
              size: 56,
              color: ColorUtils.greyTextColor,
            ),
            14.gh,
            const TtText(
              'Preview is unavailable',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ColorUtils.primaryColor,
            ),
            8.gh,
            TtText(
              '${fileType.toUpperCase()} files cannot '
              'currently be displayed inside the app.',
              fontSize: 14,
              height: 1.4,
              color: ColorUtils.greyTextColor,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _PdfErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _PdfErrorView({
    required this.message,
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
              Icons.error_outline_rounded,
              size: 52,
              color: Colors.red,
            ),
            12.gh,
            TtText(
              message,
              fontSize: 14,
              height: 1.4,
              color: ColorUtils.greyTextColor,
              textAlign: TextAlign.center,
            ),
            18.gh,
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResourceLoadingPage extends StatelessWidget {
  const _ResourceLoadingPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: context.pop,
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: ColorUtils.primaryColor,
          ),
        ),
        title: const TtText(
          'Resource Detail',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: ColorUtils.primaryColor,
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: CircularProgressIndicator(
          color: ColorUtils.secondaryColor,
        ),
      ),
    );
  }
}

class _ResourceErrorPage extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ResourceErrorPage({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: context.pop,
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: ColorUtils.primaryColor,
          ),
        ),
        title: const TtText(
          'Resource Detail',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: ColorUtils.primaryColor,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.folder_off_outlined,
                size: 52,
                color: ColorUtils.greyTextColor,
              ),
              12.gh,
              TtText(
                message,
                fontSize: 14,
                height: 1.4,
                color: ColorUtils.greyTextColor,
                textAlign: TextAlign.center,
              ),
              18.gh,
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(
                  Icons.refresh_rounded,
                ),
                label: const Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
