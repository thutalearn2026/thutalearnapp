import 'dart:io';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/authentication/data/data_sources/box/auth_session_box.dart';
import 'package:thuta_learn/features/learn/learn.dart';
import 'package:thuta_learn/features/onboarding/data/data_sources/box/onboarding_box.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'package:thuta_learn/features/learn/data/data_sources/box/courses_cache_box.dart';
import 'package:thuta_learn/features/profile/data/data_sources/box/profile_cache_box.dart';
import 'package:thuta_learn/features/learn/data/data_sources/box/course_detail_cache_box.dart';
import 'package:thuta_learn/features/learn/data/data_sources/box/module_lessons_cache_box.dart';
import 'package:thuta_learn/features/learn/data/data_sources/box/lesson_detail_cache_box.dart';
import 'package:thuta_learn/features/learn/data/data_sources/box/module_resources_cache_box.dart';
import 'package:thuta_learn/features/learn/data/data_sources/box/downloaded_resource_box.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterDownloader.initialize(
    debug: kDebugMode,
    ignoreSsl: false,
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await dotenv.load(fileName: '.env');

  await Hive.initFlutter();
  await Hive.openBox<dynamic>(AuthSessionBox.boxName);
  await Hive.openBox<dynamic>(OnboardingBox.boxName);
  await Hive.openBox<dynamic>(CoursesCacheBox.boxName);
  await Hive.openBox<dynamic>(ProfileCacheBox.boxName);
  await Hive.openBox<dynamic>(CourseDetailCacheBox.boxName);
  await Hive.openBox<dynamic>(ModuleLessonsCacheBox.boxName);
  await Hive.openBox<dynamic>(LessonDetailCacheBox.boxName);
  await Hive.openBox<dynamic>(ModuleResourcesCacheBox.boxName);
  await Hive.openBox<dynamic>(DownloadedResourceBox.boxName);
  await Hive.openBox<dynamic>(LessonVocabularyCacheBox.boxName);

  configureDependencies();

  await getIt<VideoDownloadService>().initialize();

  runApp(
    DevicePreview(
      enabled: false,
      builder: (_) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return SafeArea(
          top: false,
          bottom: true,
          child: MaterialApp.router(
            title: 'ThuTa Learn',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: "helvetica_neue",
              colorScheme: .fromSeed(seedColor: ColorUtils.primaryColor),
              pageTransitionsTheme: PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                },
              ),
            ),
            routerConfig: RouteClass.goRouter,
          ),
        );
      },
    );
  }
}
