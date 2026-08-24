import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mason/mason.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/home/home.dart';
import 'package:thuta_learn/features/learn/learn.dart';
import 'package:thuta_learn/features/profile/profile.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Stack(
        children: [
          Positioned.fill(
            child: TabBarView(
              children: [
                HomePage(),
                LearnPage(),
                Container(
                  color: Colors.yellow,
                ),
                ProfilePage(),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomNavSectionView(),
          ),
        ],
      ),
    );
  }
}

class BottomNavSectionView extends StatelessWidget {
  const BottomNavSectionView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 8,
        right: 8,
        bottom: 16,
      ),
      child: Row(
        spacing: 4,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(48),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    // color: Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(48),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 1),
                      width: 1.5,
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromRGBO(241, 241, 241, 0.9),
                        Colors.white.withValues(alpha: 0.7),
                        Color.fromRGBO(241, 241, 241, 0.5),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(1, -1),
                      ),
                    ],
                  ),
                  child: TabBar(
                    splashFactory: NoSplash.splashFactory,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    labelColor: Colors.white,
                    labelStyle: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                    unselectedLabelColor: ColorUtils.primaryColor,
                    unselectedLabelStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 11,
                    ),
                    indicatorWeight: 0,
                    dividerHeight: 0,
                    indicator: BoxDecoration(
                      color: ColorUtils.primaryColor,
                      borderRadius: BorderRadius.circular(48),
                    ),
                    tabs: [
                      Tab(
                        icon: Icon(
                          Icons.home,
                        ),
                        text: "Home",
                      ),
                      Tab(
                        icon: Icon(
                          Icons.menu_book_outlined,
                        ),
                        text: "Learn",
                      ),
                      Tab(
                        icon: Icon(
                          Icons.video_library_outlined,
                        ),
                        text: "Reels",
                      ),
                      Tab(
                        icon: Icon(
                          Icons.person_outline,
                        ),
                        text: "Profile",
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
              borderRadius: BorderRadius.circular(200),
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
                      color: Colors.white.withValues(alpha: 0.5),
                      width: 1.5,
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color.fromRGBO(
                          241,
                          241,
                          241,
                          0.9,
                        ),
                        Colors.white.withValues(alpha: 0.7),
                        const Color.fromRGBO(
                          241,
                          241,
                          241,
                          0.5,
                        ),
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.search,
                    color: ColorUtils.primaryColor,
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
