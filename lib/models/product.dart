class Product {
  final int id;
  final String name;
  final String image;
  final double price;
  final double discount;
  final String description;
  final int categoryId;
  final double rating;
  final int noOfReviews;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.discount,
    required this.description,
    required this.categoryId,
    this.rating = 0,
    this.noOfReviews = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'price': price,
      'discount': discount,
      'description': description,
      'categoryId': categoryId,
      'rating': rating,
      'noOfReviews': noOfReviews,
    };
  }

  // Get discounted price
  double get discountedPrice {
    if (discount > 0) {
      return price - (price * discount / 100);
    } else {
      return price;
    }
  }
}
