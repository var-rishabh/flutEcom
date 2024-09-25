import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:flut_mart/provider/routes.dart';
import 'package:flut_mart/utils/helper/routes.dart';
import 'package:flut_mart/utils/constants/routes.dart';

class KAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool needBackButton;

  @override
  final Size preferredSize;

  const KAppBar({
    super.key,
    this.needBackButton = false,
  }) : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  State<KAppBar> createState() => _KAppBarState();
}

class _KAppBarState extends State<KAppBar> {
  @override
  Widget build(BuildContext context) {
    final RoutesProvider routesProvider = Provider.of<RoutesProvider>(context);

    return AppBar(
      centerTitle: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      leading: widget.needBackButton
          ? Padding(
              padding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.grey,
                  size: 25,
                ),
                onPressed: () {
                  context.go(routesProvider.previousRoute);
                  routesProvider.setCurrentRoute(routesProvider.previousRoute);
                },
              ),
            )
          : Padding(
              padding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
              child: IconButton(
                icon: Icon(
                  Icons.grid_view_outlined,
                  color: matchRoute(context, KRoutes.explore)
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                  size: 25,
                ),
                onPressed: () {
                  context.go(KRoutes.explore);
                  routesProvider.setCurrentRoute(KRoutes.explore);
                },
              ),
            ),
      title: Padding(
        padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
        child: Text(
          'RunoStore',
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 10, 0),
          child: IconButton(
            icon: Icon(
              Icons.favorite,
              color: matchRoute(context, KRoutes.favorites)
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
              size: 25,
            ),
            onPressed: () {
              context.go(KRoutes.favorites);
              routesProvider.setCurrentRoute(KRoutes.favorites);
            },
          ),
        ),
      ],
    );
  }
}
