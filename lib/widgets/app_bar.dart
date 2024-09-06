import 'package:flutter/material.dart';

class KAppBar extends StatefulWidget implements PreferredSizeWidget {
  final int currentIndex;
  final Function(int) onTabSelected;

  @override
  final Size preferredSize;

  const KAppBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
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
      leading: Padding(
        padding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
        child: IconButton(
          icon: Icon(
            Icons.bento,
            color: widget.currentIndex == 1
                ? Theme.of(context).primaryColor
                : Colors.grey,
            size: 25,
          ),
          onPressed: () {
            widget.onTabSelected(1);
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
              widget.onTabSelected(2);
            },
          ),
        ),
      ],
    );
  }
}
