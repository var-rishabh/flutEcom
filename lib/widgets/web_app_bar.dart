import 'package:flutter/material.dart';

import 'package:flut_mart/widgets/icon_button.dart';
import 'package:flut_mart/widgets/search_bar.dart';

class WebAppBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTabSelected;

  const WebAppBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
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
            onTap: () => widget.onTabSelected(0),
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
          Row(
            children: [
              Icon(
                Icons.location_pin,
                size: 20,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 5),
              Text(
                'Deliver to ',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
              ),
              Text(
                'Hitech City, Hyderabad',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
              ),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 20,
              ),
            ],
          ),
          const SizedBox(
            width: 20,
          ),
          KIconButton(
            icon: Icons.shopping_cart,
            isActive: widget.currentIndex == 4,
            onTap: () => widget.onTabSelected(4),
          ),
          KIconButton(
            icon: Icons.favorite,
            isActive: widget.currentIndex == 2,
            onTap: () => widget.onTabSelected(2),
          ),
        ],
      ),
    );
  }
}
