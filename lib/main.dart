import 'package:flutter/material.dart';

// screens
import 'package:flut_mart/screens/app.dart';
import 'package:flut_mart/screens/products.dart';
import 'package:flut_mart/screens/splash.dart';
import 'package:flut_mart/screens/auth/login.dart';
import 'package:flut_mart/screens/auth/signup.dart';

// utils
import 'package:flut_mart/utils/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: KThemeData.lightTheme,
      darkTheme: KThemeData.darkTheme,
      routes: {
        SplashScreen.routeName: (context) => const SplashScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        SignUpScreen.routeName: (context) => const SignUpScreen(),
        AppScreen.routeName: (context) => const AppScreen(),     
        ProductsScreen.routeName: (context) => const ProductsScreen(),   
      },
      initialRoute: '/',
    );
  }
}
