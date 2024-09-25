import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:flut_mart/provider/routes.dart';
import 'package:flut_mart/utils/constants/routes.dart';
import 'package:flut_mart/utils/helper/responsive.dart';
import 'package:flut_mart/utils/helper/routes.dart';

import 'package:flut_mart/widgets/app_bar.dart';
import 'package:flut_mart/widgets/bottom_navigation_bar.dart';

class AppScreen extends StatefulWidget {
  final Widget childWidget;

  const AppScreen({
    super.key,
    required this.childWidget,
  });

  @override
  State<AppScreen> createState() => _AppState();
}

class _AppState extends State<AppScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: Responsive.isDesktop(context) ? null : const KAppBar(),
      floatingActionButton: Responsive.isDesktop(context)
          ? null
          : FloatingActionButton(
              onPressed: () {
                context.go(KRoutes.cart);
              },
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              elevation: 5,
              child: Icon(
                Icons.shopping_cart,
                color: matchRoute(context, "/cart")
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).iconTheme.color,
                size: matchRoute(context, "/cart") ? 28 : 24,
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar:
          Responsive.isDesktop(context) ? null : const KBottomNavigationBar(),
      body: widget.childWidget,
    );
  }
}
