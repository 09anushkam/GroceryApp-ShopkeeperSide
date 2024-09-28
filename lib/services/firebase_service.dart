import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../models/product_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Add a new shop if it doesn't exist
  Future<String?> addShopIfNotExists(String shopName) async {
    QuerySnapshot shopSnapshot = await _firestore.collection('shops')
        .where('name', isEqualTo: shopName)
        .limit(1)
        .get();

    if (shopSnapshot.docs.isEmpty) {
      DocumentReference shopRef = await _firestore.collection('shops').add({
        'name': shopName,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return shopRef.id;  // Return the new shop ID
    } else {
      return shopSnapshot.docs.first.id;  // Return the existing shop ID
    }
  }

  // Add a new product under a shop
  Future<void> addProductToShop(String shopId, Product product) async {
    await _firestore.collection('shops').doc(shopId).collection('products').add(product.toMap());
  }

  // Upload an image to Firebase Storage and return its URL
  Future<String?> uploadImageToStorage(File imageFile) async {
    try {
      final ref = _storage.ref().child('product_images/${DateTime.now().toString()}');
      final uploadTask = await ref.putFile(imageFile);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // Update an existing product under a shop
  Future<void> updateProduct(String shopId, String productId, Product product) async {
    await _firestore.collection('shops').doc(shopId).collection('products').doc(productId).update(product.toMap());
  }

  // Stream of products under a specific shop
  Stream<List<Product>> getProducts(String shopId) {
    return _firestore
        .collection('shops')
        .doc(shopId)
        .collection('products')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Product.fromMap(doc.data() as Map<String, dynamic>))
        .toList());
    }
}