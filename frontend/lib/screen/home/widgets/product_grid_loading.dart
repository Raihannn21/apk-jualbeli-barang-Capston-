import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'product_card_skeleton.dart';

class ProductGridLoading extends StatelessWidget {
  // 1. Tambahkan parameter di constructor agar bisa diatur dari luar
  final int itemCount;
  final Axis scrollDirection;

  const ProductGridLoading({
    super.key,
    this.itemCount = 6, // Beri nilai default 6 jika tidak diatur
    this.scrollDirection = Axis.vertical, // Defaultnya vertikal
  });

  @override
  Widget build(BuildContext context) {
    // Widget Shimmer akan memberikan efek kilau pada child-nya
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,

      // 2. Gunakan logika 'if' untuk menentukan layout berdasarkan arah scroll
      child: scrollDirection == Axis.vertical

          // Jika vertikal, gunakan GridView seperti sebelumnya
          ? GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(12.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2 / 3.2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12),
              itemCount: itemCount, // Gunakan parameter itemCount
              itemBuilder: (context, index) => const ProductCardSkeleton(),
            )

          // Jika horizontal, gunakan ListView horizontal
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: itemCount, // Gunakan parameter itemCount
              itemBuilder: (context, index) {
                return Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 12),
                  child: const ProductCardSkeleton(),
                );
              },
            ),
    );
  }
}
