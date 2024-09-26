import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:flut_mart/provider/routes.dart';
import 'package:flut_mart/utils/constants/routes.dart';

import 'package:flut_mart/widgets/icon_button.dart';

class KBottomNavigationBar extends StatelessWidget {
  const KBottomNavigationBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final RoutesProvider routesProvider = Provider.of<RoutesProvider>(context);

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color:
                Theme.of(context).dividerColor.withOpacity(0.1), // Shadow color
            spreadRadius: 5,
            blurRadius: 15,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: BottomAppBar(
        height: 65,
        elevation: 8,
        color: Theme.of(context).scaffoldBackgroundColor,
        shape: const CircularNotchedRectangle(),
        notchMargin: 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            KIconButton(
              icon: Icons.home,
              isActive: routesProvider.currentRoute == KRoutes.home,
              onTap: () {
                context.go(KRoutes.home);
                routesProvider.setCurrentRoute(KRoutes.home);
              },
            ),
            KIconButton(
              icon: Icons.explore,
              isActive: routesProvider.currentRoute == KRoutes.explore,
              onTap: () {
                context.go(KRoutes.explore);
                routesProvider.setCurrentRoute(KRoutes.explore);
              },
            ),
            const SizedBox(width: 80), // For the floating action button gap
            KIconButton(
              icon: Icons.favorite,
              isActive: routesProvider.currentRoute == KRoutes.favorites,
              onTap: () {
                context.go(KRoutes.favorites);
                routesProvider.setCurrentRoute(KRoutes.favorites);
              },
            ),
            KIconButton(
              icon: Icons.person,
              isActive: routesProvider.currentRoute == KRoutes.profile,
              onTap: () {
                context.go(KRoutes.profile);
                routesProvider.setCurrentRoute(KRoutes.profile);
              },
            ),
          ],
        ),
      ),
    );
  }
}
