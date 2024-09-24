import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// create a getter to get the current route
String currentRoute(BuildContext context) {
  return (GoRouter.of(context).routerDelegate.currentConfiguration.uri)
      .toString();
}

bool matchRoute(BuildContext context, String route) {
  return currentRoute(context) == route;
}
