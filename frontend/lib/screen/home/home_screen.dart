import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../models/category.dart';
import '../../models/product.dart';
import '../../services/product_service.dart';
import '../cart/cart_screen.dart';
import 'widgets/category_list.dart';
import 'widgets/product_card.dart';
import 'widgets/product_grid_loading.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Product>> _productsFuture;
  late Future<List<Category>> _categoriesFuture;
  late Future<List<Product>> _latestProductsFuture;

  String? _selectedCategorySlug;
  final TextEditingController _searchController = TextEditingController();
  List<Product>? _searchResults;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  void _fetchInitialData() {
    setState(() {
      _selectedCategorySlug = null;
      _isSearching = false;
      _searchController.clear();
      _categoriesFuture = ProductService().getCategories();
      _latestProductsFuture = ProductService().getLatestProducts();
      _productsFuture = ProductService().getProducts();
    });
  }

  void _filterProductsByCategory(String? slug) {
    setState(() {
      _selectedCategorySlug = slug;
      _isSearching = false;
      _searchController.clear();
      _productsFuture =
          ProductService().getProducts(categorySlug: _selectedCategorySlug);
    });
  }

  // Fungsi untuk menangani logika pencarian
  void _searchProducts(String query) async {
    if (query.isEmpty) return;
    setState(() {
      _isSearching = true;
      _searchResults = null;
    });
    try {
      final results = await ProductService().searchProducts(query);
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      // Handle error
    }
  }

  // Fungsi untuk membersihkan hasil pencarian
  void _clearSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Cari produk...',
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            ),
            textInputAction: TextInputAction.search,
            onSubmitted: _searchProducts,
          ),
        ),
        // --- APPBAR ACTIONS DIRAPIKAN ---
        actions: [
          if (_isSearching)
            IconButton(icon: const Icon(Icons.close), onPressed: _clearSearch),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const CartScreen())),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _fetchInitialData(),
        child: ListView(
          children: [
            _buildSectionTitle('Produk Terbaru'),
            _buildLatestProductsSection(),
            _buildSectionTitle('Kategori'),
            CategoryList(onCategorySelected: _filterProductsByCategory),
            _buildSectionTitle(
                _isSearching ? 'Hasil Pencarian' : 'Semua Produk'),
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 12.0),
              child: _isSearching ? _buildSearchResults() : _buildProductList(),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk judul setiap section
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 8.0),
      child: Text(title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }

  // Widget untuk menampilkan section produk terbaru (horizontal scroll)
  Widget _buildLatestProductsSection() {
    return FutureBuilder<List<Product>>(
      future: _latestProductsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
              height: 250,
              child: ProductGridLoading(
                  itemCount: 3, scrollDirection: Axis.horizontal));
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink(); // Sembunyikan jika error atau kosong
        }
        final products = snapshot.data!;
        return Container(
          height: 260,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return Container(
                width: 160,
                margin: const EdgeInsets.only(right: 12),
                child: ProductCard(product: products[index]),
              );
            },
          ),
        );
      },
    );
  }

  // Widget untuk menampilkan grid produk utama atau yang terfilter
  Widget _buildProductList() {
    return FutureBuilder<List<Product>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        // --- PENANGANAN ERROR DIPERBAIKI DI SINI ---
        if (snapshot.hasError) {
          // Jika ada error, tampilkan pesan dan HENTIKAN proses (return)
          return Center(child: Text('Gagal memuat data: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ProductGridLoading();
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
              child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text('Tidak ada produk untuk kategori ini.')));
        }
        // --- AKHIR PERBAIKAN ---

        final products = snapshot.data!;
        return AnimationLimiter(
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2 / 3.2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return AnimationConfiguration.staggeredGrid(
                position: index,
                duration: const Duration(milliseconds: 500),
                columnCount: 2,
                child: ScaleAnimation(
                    child:
                        FadeInAnimation(child: ProductCard(product: product))),
              );
            },
          ),
        );
      },
    );
  }

  // Widget untuk menampilkan hasil pencarian
  Widget _buildSearchResults() {
    if (_searchResults == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_searchResults!.isEmpty) {
      return const Center(
          child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Text('Produk tidak ditemukan.')));
    }
    return GridView.builder(
      shrinkWrap: true, // Wajib
      physics: const NeverScrollableScrollPhysics(), // Wajib
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2 / 3.2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12),
      itemCount: _searchResults!.length,
      itemBuilder: (context, index) {
        final product = _searchResults![index];
        return ProductCard(product: product);
      },
    );
  }
}
