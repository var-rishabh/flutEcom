import 'package:flutter/material.dart';

class KIconButton extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const KIconButton({
    super.key,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon,
        // color: isActive ? Colors.white : Colors.white70,
        color: isActive
            ? Theme.of(context).primaryColor
            : Theme.of(context).iconTheme.color,
        size: 28,
      ),
      onPressed: onTap,
    );
  }
}
