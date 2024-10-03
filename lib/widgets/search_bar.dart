import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'package:flut_mart/models/product.dart';
import 'package:flut_mart/provider/product.dart';
import 'package:flut_mart/provider/routes.dart';

class KProductSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const KProductSearchBar({
    super.key,
    required this.controller,
    this.hintText = 'Search...',
  });

  @override
  Widget build(BuildContext context) {
    final ProductProvider productProvider =
        Provider.of<ProductProvider>(context);
    final RoutesProvider routesProvider = Provider.of<RoutesProvider>(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: TypeAheadField(
        hideOnEmpty: true,
        controller: controller,
        builder: (BuildContext context, controller, focusNode) {
          return KTextField(
            controller: controller,
            hintText: hintText,
            focusNode: focusNode,
          );
        },
        constraints: const BoxConstraints(
          maxHeight: 500,
        ),
        loadingBuilder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        itemBuilder: (BuildContext context, suggestion) {
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!, width: 0.8),
              ),
            ),
            key: Key(suggestion),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  suggestion,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Colors.black87,
                      ),
                ),
                if (controller.text.isEmpty)
                  IconButton(
                    onPressed: () {
                      productProvider.removeSingleSearchHistory(suggestion);
                    },
                    icon: const Icon(Icons.close),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
              ],
            ),
          );
        },
        suggestionsCallback: (pattern) {
          List<String> searchData = controller.text.isEmpty
              ? productProvider.searchHistory.reversed.toList()
              : productProvider.products
                  .map((product) => product.name)
                  .toList();

          return searchData
              .where((element) =>
                  element.toLowerCase().contains(pattern.toLowerCase()))
              .toList();
        },
        onSelected: (suggestion) {
          productProvider.addToSearchHistory(suggestion);
          final Product product = productProvider.products.firstWhere(
            (product) => product.name == suggestion,
          );
          context.go(
            '/product/${product.id}',
            extra: product.categoryId,
          );
          routesProvider.setCurrentRoute(
            '/product/${product.id}',
          );
          productProvider.addToRecentlyViewed(product.id.toString());
          controller.clear();
        },
      ),
    );
  }
}

class KSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String)? onChanged;

  const KSearchBar({
    super.key,
    required this.controller,
    this.hintText = 'Search...',
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: KTextField(
        controller: controller,
        hintText: hintText,
        onChanged: onChanged,
      ),
    );
  }
}

class KTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final FocusNode? focusNode;
  final Function(String)? onChanged;

  const KTextField({
    super.key,
    required this.controller,
    this.hintText = 'Search...',
    this.focusNode,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: hintText,
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: Colors.grey[600],
        ),
        labelStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.secondary,
            ),
        icon: const Icon(
          Icons.search,
          color: Colors.black54,
        ),
      ),
    );
  }
}
