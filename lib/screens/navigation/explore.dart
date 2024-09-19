import 'package:flutter/material.dart';

import 'package:flut_mart/models/category.dart';
import 'package:flut_mart/services/category.service.dart';

import 'package:flut_mart/widgets/category_card.dart';
import 'package:flut_mart/widgets/search_bar.dart';

class ExploreScreen extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTabSelected;

  const ExploreScreen({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  final CategoryApiService _categoryApiService = CategoryApiService();
  List<ProductCategory> _categories = [];
  bool _isLoading = false;

  Future<void> fetchCategories() async {
    setState(() {
      _isLoading = true;
    });
    final List<ProductCategory> categories =
        await _categoryApiService.getCategories();
    setState(() {
      _categories = categories;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KSearchBar(
                  controller: _searchController,
                  hintText: 'What are you looking for?',
                  onChanged: (query) {
                    setState(() {
                      searchQuery = query;
                    });
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  'Categories',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 20,
                          mainAxisExtent: 130,
                        ),
                        itemCount: searchQuery.isEmpty
                            ? _categories.length
                            : _categories
                                .where((category) => category.name
                                    .toLowerCase()
                                    .contains(searchQuery.toLowerCase()))
                                .length,
                        itemBuilder: (context, index) {
                          final ProductCategory category = searchQuery.isEmpty
                              ? _categories[index]
                              : _categories
                                  .where((category) => category.name
                                      .toLowerCase()
                                      .contains(searchQuery.toLowerCase()))
                                  .toList()[index];
                          return CategoryCard(
                            id: category.id,
                            title: category.name,
                            image: category.image,
                            currentIndex: widget.currentIndex,
                            onTabSelected: widget.onTabSelected,
                          );
                        },
                      ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
