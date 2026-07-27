import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';

enum ModuleResourceType {
  pdf,
  word,
  audio,
}

class ModuleResourceItem {
  final String title;
  final String metadata;
  final ModuleResourceType type;

  const ModuleResourceItem({
    required this.title,
    required this.metadata,
    required this.type,
  });
}

class ModuleResourcesTabView extends StatelessWidget {
  const ModuleResourcesTabView({super.key});

  static const List<ModuleResourceItem> _resources = [
    ModuleResourceItem(
      title: 'Module 2 Learning Notes',
      metadata: '2.4 MB',
      type: ModuleResourceType.pdf,
    ),
    ModuleResourceItem(
      title: 'Vocabulary List',
      metadata: '12 min',
      type: ModuleResourceType.word,
    ),
    ModuleResourceItem(
      title: 'Audio Pronunciation Pack',
      metadata: '6 min',
      type: ModuleResourceType.audio,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      key: const PageStorageKey('module-resources'),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      itemCount: _resources.length,
      separatorBuilder: (context, index) => 14.gh,
      itemBuilder: (context, index) {
        return ModuleResourceCard(
          item: _resources[index],
          onDownload: () {
            // Download or open the resource later.
          },
        );
      },
    );
  }
}

class ModuleResourceCard extends StatelessWidget {
  final ModuleResourceItem item;
  final VoidCallback onDownload;

  const ModuleResourceCard({
    super.key,
    required this.item,
    required this.onDownload,
  });

  IconData get _icon {
    switch (item.type) {
      case ModuleResourceType.pdf:
        return Icons.description_outlined;
      case ModuleResourceType.word:
        return Icons.menu_book_outlined;
      case ModuleResourceType.audio:
        return Icons.headphones_outlined;
    }
  }

  String get _label {
    switch (item.type) {
      case ModuleResourceType.pdf:
        return 'PDF';
      case ModuleResourceType.word:
        return 'Word';
      case ModuleResourceType.audio:
        return 'MP3';
    }
  }

  Color get _labelColor {
    switch (item.type) {
      case ModuleResourceType.pdf:
        return ColorUtils.primaryColor;
      case ModuleResourceType.word:
        return ColorUtils.secondaryColor;
      case ModuleResourceType.audio:
        return const Color(0xFFF09A24);
    }
  }

  Color get _labelBackgroundColor {
    switch (item.type) {
      case ModuleResourceType.pdf:
        return const Color(0xFFE7EDF5);
      case ModuleResourceType.word:
        return ColorUtils.secondaryBackgroundColor;
      case ModuleResourceType.audio:
        return const Color(0xFFFFF0DD);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFE4E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFFF0F2F5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _icon,
              color: ColorUtils.primaryColor,
              size: 24,
            ),
          ),
          14.gw,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TtText(
                  item.title,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ColorUtils.primaryColor,
                ),
                8.gh,
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _labelBackgroundColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TtText(
                        _label,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: _labelColor,
                      ),
                    ),
                    8.gw,
                    const TtText(
                      '•',
                      fontSize: 14,
                      color: ColorUtils.greyTextColor,
                    ),
                    8.gw,
                    TtText(
                      item.metadata,
                      fontSize: 14,
                      color: ColorUtils.greyTextColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onDownload,
            icon: const Icon(
              Icons.download_outlined,
              color: ColorUtils.primaryColor,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}