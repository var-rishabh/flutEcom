import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flut_mart/utils/constants/routes.dart';
import 'package:flut_mart/utils/helper/routes.dart';
import 'package:flut_mart/services/cart.service.dart';
import 'package:flut_mart/services/favourite.service.dart';
import 'package:flut_mart/services/token.service.dart';

import 'package:flut_mart/widgets/icon_button.dart';
import 'package:flut_mart/widgets/location_text.dart';
import 'package:flut_mart/widgets/search_bar.dart';
import 'package:flut_mart/widgets/snackbar.dart';

class WebAppBar extends StatefulWidget {
  const WebAppBar({
    super.key,
  });

  @override
  State<WebAppBar> createState() => _WebAppBarState();
}

class _WebAppBarState extends State<WebAppBar> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            child: KSearchBar(
              controller: _searchController,
              hintText: 'What are you looking for?',
              onChanged: (query) {
                setState(() {
                  searchQuery = query;
                });
              },
            ),
          ),
          const Spacer(),
          const LocationText(),
          const SizedBox(
            width: 20,
          ),
          KIconButton(
            icon: Icons.shopping_cart,
            isActive: matchRoute(context, KRoutes.cart),
            onTap: () {
              context.go(KRoutes.cart);
            },
          ),
          KIconButton(
            icon: Icons.favorite,
            isActive: matchRoute(context, KRoutes.favorites),
            onTap: () {
              context.go(KRoutes.favorites);
            },
          ),
          KIconButton(
            icon: Icons.logout,
            isActive: matchRoute(context, KRoutes.login),
            onTap: () async {
              await TokenService.deleteToken();
              await CartService().clearCart();
              await FavoritesService().clearFavorites();

              context.go(KRoutes.login);
              KSnackBar.show(
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
