import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flut_mart/screens/app.dart';
import 'package:flut_mart/screens/splash.dart';
import 'package:flut_mart/screens/auth/login.dart';
import 'package:flut_mart/screens/auth/signup.dart';
import 'package:flut_mart/screens/navigation/home.dart';
import 'package:flut_mart/screens/navigation/cart.dart';
import 'package:flut_mart/screens/navigation/explore.dart';
import 'package:flut_mart/screens/navigation/favourite.dart';
import 'package:flut_mart/screens/navigation/profile.dart';
import 'package:flut_mart/screens/products/products.dart';
import 'package:flut_mart/screens/products/product_detail.dart';

class KRoutes {
  static const String splash = '/';

  static const String login = '/login';
  static const String signup = '/signup';

  static const String home = '/home';
  static const String cart = '/cart';
  static const String explore = '/explore';
  static const String favorites = '/favorites';
  static const String profile = '/profile';

  static const String products = '/category/:categoryId';
  static const String productDetails = '/product/:productId';

  // routing
  static GoRouter routerConfig() => GoRouter(
        initialLocation: KRoutes.splash,
        routes: [
          GoRoute(
            path: KRoutes.splash,
            builder: (context, state) => const SplashScreen(),
          ),
          GoRoute(
            path: KRoutes.login,
            builder: (context, state) => const LoginScreen(),
          ),
          GoRoute(
            path: KRoutes.signup,
            builder: (context, state) => const SignUpScreen(),
          ),
          ShellRoute(
            builder: (BuildContext context, GoRouterState state, Widget child) {
              return AppScreen(
                childWidget: child,
              );
            },
            routes: [
              GoRoute(
                path: KRoutes.home,
                builder: (context, state) => const HomeScreen(),
              ),
              GoRoute(
                path: KRoutes.cart,
                builder: (context, state) => const CartScreen(),
              ),
              GoRoute(
                path: KRoutes.explore,
                builder: (context, state) => const ExploreScreen(),
              ),
              GoRoute(
                path: KRoutes.favorites,
                builder: (context, state) => const FavouriteScreen(),
              ),
              GoRoute(
                path: KRoutes.profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
          GoRoute(
            path: KRoutes.products,
            builder: (context, state) {
              final int categoryId = state.extra as int;
              return ProductsScreen(
                categoryId: categoryId,
              );
            },
          ),
          GoRoute(
            path: KRoutes.productDetails,
            builder: (context, state) {
              final int categoryId = state.extra as int;
              final int productId =
                  int.parse(state.pathParameters['productId']!);
              return ProductDetailsScreen(
                categoryId: categoryId,
                productId: productId,
              );
            },
          ),
        ],
      );
}
