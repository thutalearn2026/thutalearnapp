import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/home/home.dart';
import 'package:thuta_learn/features/learn/learn.dart';
import 'package:thuta_learn/features/profile/profile.dart';
import 'package:thuta_learn/features/reels/reels.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({
    super.key,
  });

  @override
  State<BottomNav> createState() {
    return _BottomNavState();
  }
}

class _BottomNavState
    extends State<BottomNav>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 4,
      vsync: this,
    );

    _tabController.addListener(
      _handleTabChanged,
    );
  }

  void _handleTabChanged() {
    final index = _tabController.index;

    if (_currentIndex == index) {
      return;
    }

    setState(() {
      _currentIndex = index;
    });
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
    return Stack(
      children: [
        Positioned.fill(
          child: TabBarView(
            controller: _tabController,
            physics:
            const NeverScrollableScrollPhysics(),
            children: [
              const HomePage(),
              const LearnPage(),
              ReelsPage(
                isActive: _currentIndex == 2,
              ),
              const ProfilePage(),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: BottomNavSectionView(
            controller: _tabController,
          ),
        ),
      ],
    );
  }
}

class BottomNavSectionView
    extends StatelessWidget {
  final TabController controller;

  const BottomNavSectionView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8,
        right: 8,
        bottom: 16,
      ),
      child: Row(
        spacing: 4,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
              BorderRadius.circular(48),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 10,
                  sigmaY: 8,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(48),
                    border: Border.all(
                      color:
                      Colors.white.withValues(
                        alpha: 0.9,
                      ),
                      width: 1.5,
                    ),
                    gradient:
                    const LinearGradient(
                      begin: Alignment.topLeft,
                      end:
                      Alignment.bottomRight,
                      colors: [
                        Color.fromRGBO(
                          241,
                          241,
                          241,
                          0.90,
                        ),
                        Color.fromRGBO(
                          255,
                          255,
                          255,
                          0.72,
                        ),
                        Color.fromRGBO(
                          241,
                          241,
                          241,
                          0.58,
                        ),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withValues(
                          alpha: 0.1,
                        ),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset:
                        const Offset(1, -1),
                      ),
                    ],
                  ),
                  child: TabBar(
                    controller: controller,
                    splashFactory:
                    NoSplash.splashFactory,
                    indicatorSize:
                    TabBarIndicatorSize.tab,
                    indicatorPadding:
                    const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 4,
                    ),
                    labelColor: Colors.white,
                    labelStyle:
                    const TextStyle(
                      fontSize: 11,
                      fontWeight:
                      FontWeight.bold,
                    ),
                    unselectedLabelColor:
                    ColorUtils.primaryColor,
                    unselectedLabelStyle:
                    const TextStyle(
                      fontWeight:
                      FontWeight.w400,
                      fontSize: 11,
                    ),
                    indicatorWeight: 0,
                    dividerHeight: 0,
                    indicator: BoxDecoration(
                      color:
                      ColorUtils.primaryColor,
                      borderRadius:
                      BorderRadius.circular(48),
                    ),
                    tabs: const [
                      Tab(
                        icon: Icon(Icons.home),
                        text: 'Home',
                      ),
                      Tab(
                        icon: Icon(
                          Icons.menu_book_outlined,
                        ),
                        text: 'Learn',
                      ),
                      Tab(
                        icon: Icon(
                          Icons
                              .smart_display_outlined,
                        ),
                        text: 'Reels',
                      ),
                      Tab(
                        icon: Icon(
                          Icons.person_outline,
                        ),
                        text: 'Profile',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          TtZoomTap(
            onTap: () {
              context.push(Routes.search);
            },
            child: ClipRRect(
              borderRadius:
              BorderRadius.circular(200),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 10,
                  sigmaY: 8,
                ),
                child: Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color:
                      Colors.white.withValues(
                        alpha: 0.7,
                      ),
                      width: 1.5,
                    ),
                    gradient:
                    const LinearGradient(
                      begin: Alignment.topLeft,
                      end:
                      Alignment.bottomRight,
                      colors: [
                        Color.fromRGBO(
                          241,
                          241,
                          241,
                          0.90,
                        ),
                        Color.fromRGBO(
                          255,
                          255,
                          255,
                          0.72,
                        ),
                        Color.fromRGBO(
                          241,
                          241,
                          241,
                          0.58,
                        ),
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.search,
                    color:
                    ColorUtils.primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}