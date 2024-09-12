import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// screens
import 'package:flut_mart/screens/app.dart';
import 'package:flut_mart/screens/products/products.dart';
import 'package:flut_mart/screens/products/product_detail.dart';
import 'package:flut_mart/screens/splash.dart';
import 'package:flut_mart/screens/auth/login.dart';
import 'package:flut_mart/screens/auth/signup.dart';

// utils
import 'package:flut_mart/utils/theme/theme.dart';

void main() {
  // lock the orientation to portrait
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: KThemeData.lightTheme,
      // darkTheme: KThemeData.darkTheme,
      routes: {
        SplashScreen.routeName: (context) => const SplashScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        SignUpScreen.routeName: (context) => const SignUpScreen(),
        AppScreen.routeName: (context) => const AppScreen(),
        ProductsScreen.routeName: (context) => const ProductsScreen(),
        ProductDetailsScreen.routeName: (context) =>
            const ProductDetailsScreen(),
      },
      initialRoute: '/',
    );
  }
}
