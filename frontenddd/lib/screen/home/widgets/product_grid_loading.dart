import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'product_card_skeleton.dart';

class ProductGridLoading extends StatelessWidget {
  final int itemCount;
  final Axis scrollDirection;

  const ProductGridLoading({
    super.key,
    this.itemCount = 6,
    this.scrollDirection = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: scrollDirection == Axis.vertical
          ? GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(12.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2 / 3.2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12),
              itemCount: itemCount,
              itemBuilder: (context, index) => const ProductCardSkeleton(),
            )
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: itemCount,
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
