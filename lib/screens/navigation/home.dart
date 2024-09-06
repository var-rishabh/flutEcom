import 'package:flutter/material.dart';

// models
import 'package:flut_mart/utils/models/category.model.dart';

// services
import 'package:flut_mart/services/category.service.dart';

// widgets
import 'package:flut_mart/screens/navigation/carousel/carousel.dart';
import 'package:flut_mart/widgets/category_card.dart';
import 'package:flut_mart/widgets/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CategoryApiService _categoryApiService = CategoryApiService();
  List<Category> _categories = [];

  List<Category> _cat1 = [];
  List<Category> _cat2 = [];

  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  Future<void> fetchCategories() async {
    final List<Category> categories = await _categoryApiService.getCategories();
    setState(() {
      _categories = categories;
      _cat1 = _categories.sublist(0, 8);
      _cat2 = _categories.sublist(4, 10);
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
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 130, // Adjust the height according to the card size
            child: _cat2.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _cat2.length,
                    itemBuilder: (context, index) {
                      final Category category = _cat2[index];
                      return CategoryCard(
                        key: Key(category.id.toString()),
                        id: category.id,
                        title: category.name,
                        image: category.image,
                        boxSize: 80, // Adjust the size of each category box
                      );
                    },
                  ),
          ),
          SizedBox(
            height: 130, // Adjust the height according to the card size
            child: _cat1.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _cat1.length,
                    itemBuilder: (context, index) {
                      final Category category = _cat1[index];
                      return CategoryCard(
                        key: Key(category.id.toString()),
                        id: category.id,
                        title: category.name,
                        image: category.image,
                        boxSize: 80, // Adjust the size of each category box
                      );
                    },
                  ),
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
