import 'dart:convert';

Products productFromJson(String str) => Products.fromJson(json.decode(str));

String productToJson(Products data) => json.encode(data.toJson());

class Products {
  List<Product> products;

  Products({
    required this.products,
  });

  factory Products.fromJson(Map<String, dynamic> json) => Products(
        products: List<Product>.from(
          json["products"].map((x) => Product.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };

  where(bool Function(Product) f) {
    return products.where(f);
  }
}

class Product {
  int id;
  String name;
  String image;
  int price;
  int discount;
  String description;
  int categoryId;
  double rating;
  int noOfReviews;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.discount,
    required this.description,
    required this.categoryId,
    required this.rating,
    required this.noOfReviews,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        price: json["price"],
        discount: json["discount"],
        description: json["description"],
        categoryId: json["categoryId"],
        rating: json["rating"]?.toDouble(),
        noOfReviews: json["noOfReviews"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "price": price,
        "discount": discount,
        "description": description,
        "categoryId": categoryId,
        "rating": rating,
        "noOfReviews": noOfReviews,
      };

  int get discountedPrice {
    if (discount > 0) {
      return (price - (price * discount / 100)).ceil();
    } else {
      return price;
    }
  }
}
