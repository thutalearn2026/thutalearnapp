import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:thuta_learn/core/core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  /// Initialize GetIt
  configureDependencies();

  runApp(const MyApp());
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
