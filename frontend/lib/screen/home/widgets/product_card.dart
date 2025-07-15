import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/product.dart';
import '../../product/product_detail_screen.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final bool hasDiscount =
        product.discountPrice != null && product.discountPrice != product.price;
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final displayPriceString =
        hasDiscount ? product.discountPrice! : product.price;
    final formattedDisplayPrice =
        formatter.format(double.tryParse(displayPriceString) ?? 0);
    final formattedOriginalPrice =
        formatter.format(double.tryParse(product.price) ?? 0);

    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductDetailScreen(product: product))),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(product.imageUrl),
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(formattedDisplayPrice,
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                  color: hasDiscount
                                      ? Theme.of(context).colorScheme.secondary
                                      : Theme.of(context).primaryColor)),
                          if (hasDiscount)
                            Text(formattedOriginalPrice,
                                style: const TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey,
                                    fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // --- BAGIAN BARU: RATING & PENJUALAN ---
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(product.averageRating.toStringAsFixed(1),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12)),
                          const SizedBox(width: 6),
                          Text('(${product.reviewsCount})',
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 12)),
                          const Spacer(),
                          Text('${product.soldCount} terjual',
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 12)),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            if (hasDiscount && product.discountPercent != null)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                      color: Colors.red.shade700,
                      borderRadius: BorderRadius.circular(4)),
                  child: Text('${product.discountPercent}% OFF',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10)),
                ),
              )
          ],
        ),
      ),
    );
  }
}
