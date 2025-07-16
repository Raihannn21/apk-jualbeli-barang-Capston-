import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import '../../models/product.dart';
import '../../models/product_image.dart';
import '../../services/cart_service.dart';
import 'widgets/review_section.dart';
import '../../services/notification_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _isLoading = false;
  int _quantity = 1;
  final CartService _cartService = CartService();
  int _currentImageIndex = 0;

  void _incrementQuantity() {
    setState(() {
      if (_quantity < widget.product.stock) {
        _quantity++;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Jumlah melebihi stok yang tersedia.'),
              backgroundColor: Colors.orange),
        );
      }
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (_quantity > 1) _quantity--;
    });
  }

  void _addToCart() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await _cartService.addToCart(widget.product.id, _quantity);
      if (mounted) {
        NotificationService.showSuccessNotification(context,
            '${widget.product.name} (x$_quantity) berhasil ditambahkan!');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Colors.red,
        ));
      }
    } finally {
      if (mounted)
        setState(() {
          _isLoading = false;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final allImages = [
      if (widget.product.imageUrl.isNotEmpty)
        ProductImage(id: 0, imageUrl: widget.product.imageUrl),
      ...widget.product.images,
    ];

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildSliverAppBar(allImages),
              SliverList(
                delegate: SliverChildListDelegate(
                  AnimationConfiguration.toStaggeredList(
                    duration: const Duration(milliseconds: 375),
                    childAnimationBuilder: (widget) => SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(child: widget),
                    ),
                    children: [
                      _buildProductInfoSection(),
                      ReviewSection(productId: widget.product.id),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(List<ProductImage> allImages) {
    final bool hasDiscount = widget.product.discountPercent != null &&
        widget.product.discountPercent! > 0;
    return SliverAppBar(
      expandedHeight: 350.0,
      pinned: true,
      stretch: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 1,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          widget.product.name,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontSize: 16.0,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (allImages.isNotEmpty)
              PageView.builder(
                itemCount: allImages.length,
                onPageChanged: (index) =>
                    setState(() => _currentImageIndex = index),
                itemBuilder: (context, index) {
                  return Image.network(allImages[index].imageUrl,
                      fit: BoxFit.cover);
                },
              )
            else
              const Center(child: Icon(Icons.image_not_supported, size: 50)),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.0, 0.5),
                  end: Alignment(0.0, 0.0),
                  colors: <Color>[Color(0x60000000), Color(0x00000000)],
                ),
              ),
            ),
            if (hasDiscount)
              Positioned(
                top: 60,
                left: 16,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      color: Colors.red.shade700,
                      borderRadius: BorderRadius.circular(8)),
                  child: Text('${widget.product.discountPercent}% OFF',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              )
          ],
        ),
      ),
      bottom: allImages.length > 1
          ? PreferredSize(
              preferredSize: const Size.fromHeight(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                    allImages.length,
                    (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: _currentImageIndex == index ? 12 : 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: _currentImageIndex == index
                                ? Theme.of(context).primaryColor
                                : Colors.grey.shade400,
                          ),
                        )),
              ),
            )
          : null,
    );
  }

  Widget _buildProductInfoSection() {
    final bool hasDiscount = widget.product.discountPrice != null &&
        widget.product.discountPrice != widget.product.price;
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final displayPriceString =
        hasDiscount ? widget.product.discountPrice! : widget.product.price;
    final formattedDisplayPrice =
        formatter.format(double.tryParse(displayPriceString) ?? 0);
    final formattedOriginalPrice =
        formatter.format(double.tryParse(widget.product.price) ?? 0);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.product.name,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.star, color: Colors.amber, size: 20),
              const SizedBox(width: 4),
              Text(
                  '${widget.product.averageRating.toStringAsFixed(1)} (${widget.product.reviewsCount} Ulasan) | ${widget.product.soldCount} terjual'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(formattedDisplayPrice,
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor)),
              if (hasDiscount) ...[
                const SizedBox(width: 8),
                Text(formattedOriginalPrice,
                    style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                        fontSize: 16)),
              ],
            ],
          ),
          const SizedBox(height: 16),
          Text('Stok tersedia: ${widget.product.stock} buah'),
          const Divider(height: 32),
          const Text('Deskripsi Produk',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(widget.product.description,
              style: const TextStyle(fontSize: 16, height: 1.5)),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)
            ]),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  IconButton(
                      onPressed: _decrementQuantity,
                      icon: const Icon(Icons.remove)),
                  Text(_quantity.toString(),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                      onPressed: _incrementQuantity,
                      icon: const Icon(Icons.add)),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _addToCart,
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16)),
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: Colors.white))
                    : const Text('Tambah ke Keranjang'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
