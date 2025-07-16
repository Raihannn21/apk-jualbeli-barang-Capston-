import 'package:flutter/material.dart';

class ProductCardSkeleton extends StatelessWidget {
  const ProductCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.grey.shade300,
            height: 150,
            width: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.grey.shade300,
                  height: 14,
                  width: double.infinity,
                ),
                const SizedBox(height: 8),
                Container(
                  color: Colors.grey.shade300,
                  height: 16,
                  width: 100,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
