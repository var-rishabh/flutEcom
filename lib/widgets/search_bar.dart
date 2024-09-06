import 'package:flutter/material.dart';

class KSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;

  const KSearchBar({
    super.key,
    required this.controller,
    this.hintText = 'Search...',
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          hintStyle: TextStyle(
            color: Colors.grey[600],
          ),
          labelStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
          icon: Icon(
            Icons.search,
            color: Theme.of(context).iconTheme.color,
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear,
                      color: Theme.of(context).colorScheme.secondary),
                  onPressed: () {
                    controller.clear();
                    onChanged(''); // Trigger search reset
                  },
                )
              : null,
        ),
      ),
    );
  }
}
