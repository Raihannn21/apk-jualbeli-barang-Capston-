// lib/screens/product/widgets/review_section.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/review.dart';
import '../../../services/review_service.dart';

class ReviewSection extends StatefulWidget {
  final int productId;
  const ReviewSection({super.key, required this.productId});

  @override
  State<ReviewSection> createState() => _ReviewSectionState();
}

class _ReviewSectionState extends State<ReviewSection> {
  late Future<List<Review>> _reviewsFuture;

  @override
  void initState() {
    super.initState();
    // Panggil API berdasarkan productId yang diterima
    _reviewsFuture = ReviewService().getReviews(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Divider(),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Ulasan Produk',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        // FutureBuilder sekarang ada di dalam widget ini
        FutureBuilder<List<Review>>(
          future: _reviewsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('Gagal memuat ulasan: ${snapshot.error}'),
              );
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('Belum ada ulasan untuk produk ini.'),
              );
            }

            final reviews = snapshot.data!;
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(child: Icon(Icons.person)),
                            const SizedBox(width: 8),
                            Text(review.user.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: List.generate(
                              5,
                              (i) => Icon(
                                    i < review.rating
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                    size: 20,
                                  )),
                        ),
                        if (review.comment != null &&
                            review.comment!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(review.comment!),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
