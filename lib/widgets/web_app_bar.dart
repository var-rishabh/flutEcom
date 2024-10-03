import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:flut_mart/provider/routes.dart';
import 'package:flut_mart/utils/constants/routes.dart';
import 'package:flut_mart/services/cart.service.dart';
import 'package:flut_mart/services/favourite.service.dart';
import 'package:flut_mart/services/token.service.dart';

import 'package:flut_mart/widgets/icon_button.dart';
import 'package:flut_mart/widgets/location_text.dart';
import 'package:flut_mart/widgets/search_bar.dart';
import 'package:flut_mart/widgets/notification.dart';

class WebAppBar extends StatefulWidget {
  const WebAppBar({
    super.key,
  });

  @override
  State<WebAppBar> createState() => _WebAppBarState();
}

class _WebAppBarState extends State<WebAppBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final RoutesProvider routesProvider = Provider.of<RoutesProvider>(context);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 30,
            spreadRadius: 10,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              context.go(KRoutes.home);
              routesProvider.setCurrentRoute(KRoutes.home);
            },
            child: Text(
              'RunoStore',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const Spacer(),
          Expanded(
            flex: 5,
            child: KProductSearchBar(
              controller: _searchController,
              hintText: 'What are you looking for?',
            ),
          ),
          const Spacer(),
          const LocationText(),
          const SizedBox(
            width: 20,
          ),
          KIconButton(
            icon: Icons.explore,
            isActive: routesProvider.currentRoute == KRoutes.explore,
            onTap: () {
              context.go(KRoutes.explore);
              routesProvider.setCurrentRoute(KRoutes.explore);
            },
          ),
          KIconButton(
            icon: Icons.shopping_cart,
            isActive: routesProvider.currentRoute == KRoutes.cart,
            onTap: () {
              context.go(KRoutes.cart);
              routesProvider.setCurrentRoute(KRoutes.cart);
            },
          ),
          KIconButton(
            icon: Icons.favorite,
            isActive: routesProvider.currentRoute == KRoutes.favorites,
            onTap: () {
              context.go(KRoutes.favorites);
              routesProvider.setCurrentRoute(KRoutes.favorites);
            },
          ),
          KIconButton(
            icon: Icons.logout,
            isActive: routesProvider.currentRoute == KRoutes.login,
            onTap: () async {
              await TokenService.deleteToken();
              await CartService().clearCart();
              await FavoritesService().clearFavorites();

              context.go(KRoutes.login);
              routesProvider.setCurrentRoute(KRoutes.login);
              KNotification.show(
                context: context,
                label: 'Logout Successful',
                type: 'success',
              );
            },
          ),
        ],
      ),
    );
  }
}
