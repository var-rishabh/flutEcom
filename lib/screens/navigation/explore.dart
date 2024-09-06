import 'package:flutter/material.dart';

// models
import 'package:flut_mart/utils/models/category.model.dart';

// services
import 'package:flut_mart/services/category.service.dart';

// widgets
import 'package:flut_mart/widgets/category_card.dart';
import 'package:flut_mart/widgets/search_bar.dart';

class ExploreScreen extends StatefulWidget {
  final String? categoryName;

  const ExploreScreen({
    super.key,
    this.categoryName,
  });

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final CategoryApiService _categoryApiService = CategoryApiService();
    List<Category> _categories = [];

    Future<void> fetchCategories() async {
      final List<Category> categories =
          await _categoryApiService.getCategories();
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

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
          // if (widget.categoryName == null)
          //   FutureBuilder<List<Category>>(
          //     future: CategoryService().getCategories(),
          //     builder: (context, snapshot) {
          //       if (snapshot.hasData) {
          //         return Column(
          //           children: snapshot.data!
          //               .map((category) => KCategoryCard(category: category))
          //               .toList(),
          //         );
          //       } else if (snapshot.hasError) {
          //         return Text('Error: ${snapshot.error}');
          //       }
          //
          //       return const CircularProgressIndicator();
          //     },
          //   ),
        ],
      ),
    );
  }
}
