// lib/models/shop_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Shop {
  final String id;
  final String name;
  final String userId;
  final DateTime? createdAt;

  Shop({
    required this.id,
    required this.name,
    required this.userId,
    this.createdAt,
  });

  // Convert Shop object to a Map for saving to Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'userId': userId,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  // Factory constructor to create a Shop from Firestore DocumentSnapshot
  factory Shop.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Shop(
      id: doc.id,
      name: data['name'] ?? '',
      userId: data['userId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
