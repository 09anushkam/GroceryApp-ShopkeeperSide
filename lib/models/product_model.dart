class Product {
  String name;
  String category;
  String imageUrl;
  int quantity;
  double price;

  Product({
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'price': price,
    };
  }

  static Product fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'],
      category: map['category'],
      imageUrl: map['imageUrl'],
      quantity: map['quantity'],
      price: map['price'],
    );
  }
}
