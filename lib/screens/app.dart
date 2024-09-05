import 'package:flutter/material.dart';

// widgets
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
    const Center(child: Text('Home Screen')),
    const Center(child: Text('Explore Screen')),
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
      // appBar: AppBar(
      //   title: const Text('Home'),
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _onTabSelected(4);
        },
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(
          Icons.shopping_cart,
          color: _selectedIndex == 4 ? Colors.white : Colors.white70,
          size: _selectedIndex == 4 ? 24 : 22,
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
