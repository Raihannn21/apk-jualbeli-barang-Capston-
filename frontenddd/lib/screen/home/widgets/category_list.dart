import 'package:flutter/material.dart';
import '../../../models/category.dart';
import '../../../services/product_service.dart';

class CategoryList extends StatefulWidget {
  final Function(String?) onCategorySelected;

  const CategoryList({super.key, required this.onCategorySelected});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  late Future<List<Category>> _categoriesFuture;
  String? _selectedCategorySlug;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = ProductService().getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
      future: _categoriesFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(
              height: 50, child: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError) {
          return const SizedBox(
              height: 50, child: Center(child: Text('Gagal memuat kategori')));
        }
        final categories = snapshot.data!;

        return Container(
          height: 50,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                final isSelected = _selectedCategorySlug == null;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ActionChip(
                    label: const Text('Semua'),
                    backgroundColor: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade200,
                    labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black),
                    onPressed: () {
                      setState(() {
                        _selectedCategorySlug = null;
                      });
                      widget.onCategorySelected(null);
                    },
                  ),
                );
              }
              final category = categories[index - 1];
              final isSelected = _selectedCategorySlug == category.slug;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ActionChip(
                  label: Text(category.name),
                  backgroundColor: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey.shade200,
                  labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black),
                  onPressed: () {
                    setState(() {
                      _selectedCategorySlug = category.slug;
                    });
                    widget.onCategorySelected(category.slug);
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
