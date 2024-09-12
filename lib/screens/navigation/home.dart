import 'package:flutter/material.dart';

// helpers
import 'package:flut_mart/utils/helper/responsive.dart';

// models
import 'package:flut_mart/utils/models/category.model.dart';

// services
import 'package:flut_mart/services/category.service.dart';

// widgets
import 'package:flut_mart/screens/navigation/carousel/carousel.dart';
import 'package:flut_mart/widgets/category_card.dart';
import 'package:flut_mart/widgets/search_bar.dart';
import 'package:flut_mart/widgets/web_app_bar.dart';

class HomeScreen extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTabSelected;

  const HomeScreen({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CategoryApiService _categoryApiService = CategoryApiService();
  List<Category> _categories = [];

  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  Future<void> fetchCategories() async {
    final List<Category> categories = await _categoryApiService.getCategories();
    setState(() {
      _categories = categories;
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
    final int halfLength = (_categories.length / 2).ceil();

    return SingleChildScrollView(
      child: Column(
        children: [
          Responsive.isDesktop(context)
              ? WebAppBar(
                  currentIndex: widget.currentIndex,
                  onTabSelected: widget.onTabSelected,
                )
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
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
                      const SizedBox(height: 15),
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
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                          ),
                          Text(
                            'Hitech City, Hyderabad',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            size: 20,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
          const SizedBox(height: 20),
          _categories.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    SizedBox(
                      height:
                          130, // Adjust the height according to the card size
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: halfLength,
                        itemBuilder: (context, index) {
                          final Category category = _categories[index];
                          return CategoryCard(
                            key: Key(category.id.toString()),
                            id: category.id,
                            title: category.name,
                            image: category.image,
                            boxSize: 80,
                            currentIndex: widget.currentIndex,
                            onTabSelected: widget.onTabSelected,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10), // Space between two rows
                    SizedBox(
                      height:
                          130, // Adjust the height according to the card size
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: _categories.length - halfLength,
                        itemBuilder: (context, index) {
                          final Category category =
                              _categories[halfLength + index];
                          return CategoryCard(
                            key: Key(category.id.toString()),
                            id: category.id,
                            title: category.name,
                            image: category.image,
                            boxSize: 80,
                            currentIndex: widget.currentIndex,
                            onTabSelected: widget.onTabSelected,
                          );
                        },
                      ),
                    ),
                  ],
                ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: KCarousel(),
          ),
        ],
      ),
    );
  }
}
