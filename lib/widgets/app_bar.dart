import 'package:flutter/material.dart';

class KAppBar extends StatefulWidget implements PreferredSizeWidget {
  final int currentIndex;
  final Function(int) onTabSelected;
  final bool needBackButton;

  @override
  final Size preferredSize;

  const KAppBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
    this.needBackButton = false,
  }) : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  State<KAppBar> createState() => _KAppBarState();
}

class _KAppBarState extends State<KAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      leading: !widget.needBackButton
          ? Padding(
              padding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
              child: IconButton(
                icon: Icon(
                  Icons.grid_view_outlined,
                  color: widget.currentIndex == 1
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                  size: 25,
                ),
                onPressed: () {
                  widget.onTabSelected(1);
                },
              ),
            )
          : Padding(
              padding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Theme.of(context).primaryColor,
                  size: 25,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
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
              color: widget.currentIndex == 2
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
              size: 25,
            ),
            onPressed: () {
              // close all navigation drawers
              Navigator.of(context).popUntil((route) => route.isFirst);
              widget.onTabSelected(2);
            },
          ),
        ),
      ],
    );
  }
}
