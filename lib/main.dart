import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flut_mart/utils/theme/theme.dart';
import 'package:flut_mart/utils/constants/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: KThemeData.lightTheme,
      darkTheme: KThemeData.darkTheme,
      routerConfig: KRoutes.routerConfig,
    );
  }
}
