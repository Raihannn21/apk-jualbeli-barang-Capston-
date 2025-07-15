class ReviewUser {
  final int id;
  final String name;

  ReviewUser({required this.id, required this.name});

  factory ReviewUser.fromJson(Map<String, dynamic> json) {
    return ReviewUser(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Review {
  final int rating;
  final String? comment;
  final ReviewUser user;

  Review({
    required this.rating,
    this.comment,
    required this.user,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      rating: json['rating'],
      comment: json['comment'],
      user: ReviewUser.fromJson(json['user']),
    );
  }
}
