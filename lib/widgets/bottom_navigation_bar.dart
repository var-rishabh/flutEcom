import 'package:flutter/material.dart';
import 'package:flut_mart/widgets/icon_button.dart';

class KBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;

  const KBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
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
              isActive: currentIndex == 0,
              onTap: () => onTabSelected(0),
            ),
            KIconButton(
              icon: Icons.explore,
              isActive: currentIndex == 1,
              onTap: () => onTabSelected(1),
            ),
            const SizedBox(width: 80), // For the floating action button gap
            KIconButton(
              icon: Icons.favorite,
              isActive: currentIndex == 2,
              onTap: () => onTabSelected(2),
            ),
            KIconButton(
              icon: Icons.person,
              isActive: currentIndex == 3,
              onTap: () => onTabSelected(3),
            ),
          ],
        ),
      ),
    );
  }
}
