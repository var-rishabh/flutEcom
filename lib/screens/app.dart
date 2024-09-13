import 'package:flutter/material.dart';

import 'package:flut_mart/utils/helper/responsive.dart';

import 'package:flut_mart/screens/navigation/cart.dart';
import 'package:flut_mart/screens/navigation/explore.dart';
import 'package:flut_mart/screens/navigation/favourite.dart';
import 'package:flut_mart/screens/navigation/home.dart';
import 'package:flut_mart/screens/navigation/profile.dart';

import 'package:flut_mart/widgets/app_bar.dart';
import 'package:flut_mart/widgets/bottom_navigation_bar.dart';

class AppScreen extends StatefulWidget {
  static const String routeName = '/app';

  const AppScreen({super.key});

  @override
  State<AppScreen> createState() => _AppState();
}

class _AppState extends State<AppScreen> {
  int _selectedIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeScreen(
        currentIndex: _selectedIndex,
        onTabSelected: _onTabSelected,
      ),
      ExploreScreen(
        currentIndex: _selectedIndex,
        onTabSelected: _onTabSelected,
      ),
      FavoritesScreen(
        currentIndex: _selectedIndex,
        onTabSelected: _onTabSelected,
      ),
      const ProfileScreen(),
      CartScreen(
        currentIndex: _selectedIndex,
        onTabSelected: _onTabSelected,
      ),
    ];
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: Responsive.isDesktop(context)
          ? null
          : KAppBar(
              currentIndex: _selectedIndex,
              onTabSelected: _onTabSelected,
            ),
      floatingActionButton: Responsive.isDesktop(context)
          ? null
          : FloatingActionButton(
              onPressed: () {
                _onTabSelected(4);
              },
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              elevation: 5,
              child: Icon(
                Icons.shopping_cart,
                color: _selectedIndex == 4
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).iconTheme.color,
                size: _selectedIndex == 4 ? 28 : 24,
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Responsive.isDesktop(context)
          ? null
          : KBottomNavigationBar(
              currentIndex: _selectedIndex,
              onTabSelected: _onTabSelected,
            ),
      body: pages[_selectedIndex],
    );
  }
}
