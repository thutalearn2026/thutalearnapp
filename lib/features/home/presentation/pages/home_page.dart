import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/home/home.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.scaffoldBackgroundColor,
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: ColorUtils.scaffoldBackgroundColor,
            automaticallyImplyLeading: false,
            expandedHeight: 412,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  LetsLearnTodaySectionView(),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: LearningProgressSectionView(),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                AskAiSectionView(),
                16.gh,
                CurrentLearningSectionView(),
                16.gh,
                ReviewSectionView(),
                100.gh,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
