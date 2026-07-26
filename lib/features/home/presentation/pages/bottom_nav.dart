import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mason/mason.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/home/home.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Stack(
        children: [
          Positioned.fill(
            child: TabBarView(
              children: [
                HomePage(),
                Container(color: Colors.yellow),
                Container(
                  color: Colors.blue,
                ),
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
        left: 16,
        right: 16,
        bottom: 16,
      ),
      child: Row(
        spacing: 8,
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
                      color: Colors.white.withValues(alpha: 0.5),
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
                  ),
                  child: TabBar(
                    splashFactory: NoSplash.splashFactory,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    labelColor: Colors.white,
                    labelStyle: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                    unselectedLabelColor: ColorUtils.primaryColor,
                    unselectedLabelStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
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
          ClipRRect(
            borderRadius: BorderRadius.circular(200),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 8.0),
              child: Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  // color: Colors.white.withValues(alpha: 0.7),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
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
                ),
                child: Icon(
                  Icons.search,
                  color: ColorUtils.primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
