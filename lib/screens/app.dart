import 'package:flutter/material.dart';

// screens
import 'package:flut_mart/screens/navigation/explore.dart';
import 'package:flut_mart/screens/navigation/home.dart';

// widgets
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

  final List<Widget> _pages = [
    const HomeScreen(),
    const ExploreScreen(),
    const Center(child: Text('Favorites Screen')),
    const Center(child: Text('Profile Screen')),
    const Center(child: Text('Cart Screen')), // Floating Action Button page
  ];

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: KAppBar(
        currentIndex: _selectedIndex,
        onTabSelected: _onTabSelected,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _onTabSelected(4);
        },
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        // give shadow to the floating action button
        elevation: 5,
        child: Icon(
          Icons.shopping_cart,
          // color: _selectedIndex == 4 ? Colors.white : Colors.white70,
          color: _selectedIndex == 4
              ? Theme.of(context).primaryColor
              : Theme.of(context).iconTheme.color,
          size: _selectedIndex == 4 ? 28 : 24,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: KBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTabSelected: _onTabSelected,
      ),
      body: _pages[_selectedIndex],
    );
  }
}
