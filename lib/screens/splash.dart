import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';

import 'package:flut_mart/services/token.service.dart';
import 'package:flut_mart/utils/constants/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Check if the user is logged in
  Future<bool> _isLoggedIn() async {
    final token = await TokenService.getToken();
    return token != null;
  }

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), () {
        _isLoggedIn().then((isLoggedIn) {
          if (mounted) {
            if (isLoggedIn) {
              context.go(KRoutes.home);
            } else {
              context.go(KRoutes.login);
            }
          }
        });
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
