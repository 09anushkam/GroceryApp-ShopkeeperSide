import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  final int quantity;
  final double price;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.quantity,
    required this.price,
  });

  // Convert Product object to a Map for saving to Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'price': price,
    };
  }

  // Factory constructor to create a Product from Firestore DocumentSnapshot
  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id, // Firestore document ID
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      quantity: (data['quantity'] ?? 0).toInt(),
      price: (data['price'] ?? 0.0).toDouble(),
    );
  }

  // Method to create a Product from a Map, useful for other data sources
  static Product fromMap(Map<String, dynamic> map, String documentId) {
    return Product(
      id: documentId, // ID passed in case you're using it from elsewhere
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      quantity: (map['quantity'] ?? 0).toInt(),
      price: (map['price'] ?? 0.0).toDouble(),
    );
  }

  // Converts the Product object back to a map for updating or adding new records
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'category': category,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'price': price,
    };
  }
}
