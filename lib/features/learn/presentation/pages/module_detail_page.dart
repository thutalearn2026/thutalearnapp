import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';

class ModuleDetailPage extends StatefulWidget {
  final LearnModuleItem module;

  const ModuleDetailPage({
    super.key,
    required this.module,
  });

  @override
  State<ModuleDetailPage> createState() =>
      _ModuleDetailPageState();
}

class _ModuleDetailPageState extends State<ModuleDetailPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  int _selectedTabIndex = 0;

  bool get _isLessonsTab => _selectedTabIndex == 0;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 3,
      vsync: this,
    );

    _tabController.addListener(_handleTabChanged);
  }

  void _handleTabChanged() {
    if (_selectedTabIndex != _tabController.index) {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    }
  }

  void _handleSecondaryAction() {
    if (_isLessonsTab) {
      // Open the overview video.
      return;
    }

    context.push(Routes.quiz);
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(_handleTabChanged)
      ..dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorUtils.primaryColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: context.pop,
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: ModuleDetailHeader(
                module: widget.module,
                onResume: () {
                  // Resume the current lesson.
                },
                secondaryActionLabel:
                _isLessonsTab ? 'Overview' : 'Take Quiz',
                secondaryActionIcon: _isLessonsTab
                    ? Icons.play_arrow_rounded
                    : Icons.lightbulb_outline_rounded,
                onSecondaryAction: _handleSecondaryAction,
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: ModuleTabBarDelegate(
                tabBar: TabBar(
                  controller: _tabController,
                  labelColor: ColorUtils.primaryColor,
                  unselectedLabelColor:
                  ColorUtils.primaryColor,
                  labelStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  indicatorColor: ColorUtils.secondaryColor,
                  indicatorWeight: 3,
                  dividerColor: const Color(0xFFE6E9ED),
                  tabs: const [
                    Tab(text: 'Lessons'),
                    Tab(text: 'Practice'),
                    Tab(text: 'Resources'),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: const [
            ModuleLessonsTabView(),
            ModulePracticeTabView(),
            ModuleResourcesTabView(),
          ],
        ),
      ),
    );
  }
}

class ModuleTabBarDelegate
    extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  ModuleTabBarDelegate({required this.tabBar});

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent,
      ) {
    return Material(
      color: Colors.white,
      elevation: overlapsContent ? 2 : 0,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(ModuleTabBarDelegate oldDelegate) {
    return oldDelegate.tabBar != tabBar;
  }
}