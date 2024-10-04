import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:flut_mart/provider/location.dart';
import 'package:flut_mart/provider/routes.dart';
import 'package:flut_mart/utils/constants/routes.dart';
import 'package:flut_mart/services/token.service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<bool> _isLoggedIn() async {
    final token = await TokenService.getToken();
    return token != null;
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      _isLoggedIn().then((isLoggedIn) {
        if (mounted) {
          final routeProvider =
              Provider.of<RoutesProvider>(context, listen: false);
          if (isLoggedIn) {
            context.go(KRoutes.home);
            routeProvider.setCurrentRoute(KRoutes.home);

            Provider.of<LocationProvider>(
              context,
              listen: false,
            ).getCurrentLocation();
          } else {
            context.go(KRoutes.login);
            routeProvider.setCurrentRoute(KRoutes.login);
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Runo Store',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            Lottie.asset(
              'assets/animations/loader.json',
              height: 80,
            ),
          ],
        ),
      ),
    );
  }
}
