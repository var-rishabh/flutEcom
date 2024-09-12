import 'package:flutter/material.dart';

// widgets
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'RunoStore',
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
        ),
        KIconButton(
          icon: Icons.home,
          isActive: widget.currentIndex == 0,
          onTap: () => widget.onTabSelected(0),
        ),
        KIconButton(
          icon: Icons.explore,
          isActive: widget.currentIndex == 1,
          onTap: () => widget.onTabSelected(1),
        ),
        const Spacer(),
        Expanded(
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
        KIconButton(
          icon: Icons.home,
          isActive: widget.currentIndex == 0,
          onTap: () => widget.onTabSelected(0),
        ),
      ],
    );
    Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'RunoStore',
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
          KIconButton(
            icon: Icons.home,
            isActive: widget.currentIndex == 0,
            onTap: () => widget.onTabSelected(0),
          ),
          KIconButton(
            icon: Icons.explore,
            isActive: widget.currentIndex == 1,
            onTap: () => widget.onTabSelected(1),
          ),
          const Spacer(),
          KIconButton(
            icon: Icons.favorite,
            isActive: widget.currentIndex == 2,
            onTap: () => widget.onTabSelected(2),
          ),
          KIconButton(
            icon: Icons.person,
            isActive: widget.currentIndex == 3,
            onTap: () => widget.onTabSelected(3),
          )
        ],
      ),
    );
  }
}
