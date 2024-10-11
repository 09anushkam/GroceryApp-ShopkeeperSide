import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../models/product_model.dart'; // Ensure this import points to your Product model

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Add Shop if it doesn't exist, and return the shop ID
  Future<String?> addShopIfNotExists(String shopName) async {
    try {
      QuerySnapshot query = await _firestore.collection('shops')
          .where('name', isEqualTo: shopName)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        return query.docs.first.id; // Return existing shop ID
      } else {
        DocumentReference newShopRef = await _firestore.collection('shops').add({
          'name': shopName,
          'createdAt': FieldValue.serverTimestamp(),
        });
        return newShopRef.id; // Return newly created shop ID
      }
    } catch (e) {
      print('Error adding or checking shop: $e');
      return null; // Return null on error
    }
  }

  // Upload image to Firebase Storage and get the image URL
  Future<String?> uploadImageToStorage(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = _storage.ref().child('product_images').child(fileName);
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;

      // Ensure that we wait for the upload to complete
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl; // Return the image URL
    } catch (e) {
      print('Error uploading image: $e');
      return null; // Return null if upload fails
    }
  }

  // Add product to a specific shop
  Future<void> addProductToShop(String shopId, String productName, String imageUrl, double price, int quantity) async {
    try {
      await _firestore.collection('shops').doc(shopId).collection('products').add({
        'name': productName,
        'imageUrl': imageUrl,
        'price': price,
        'quantity': quantity,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('Product added successfully to shop: $shopId');
    } catch (e) {
      print('Error adding product to shop: $e');
    }
  }

  // Fetch products for a specific shop
  Future<List<Product>> fetchProductsForShop(String shopId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('shops')
          .doc(shopId)
          .collection('products')
          .get();

      // Map documents to Product model instances
      return querySnapshot.docs.map((doc) {
        return Product(
          id: doc.id, // Ensure your Product model has an id field
          name: doc['name'],
          imageUrl: doc['imageUrl'],
          price: doc['price'].toDouble(),
          quantity: doc['quantity'],
          category: '', // Add category if needed
        );
      }).toList();
    } catch (e) {
      print('Error fetching products: $e');
      return []; // Return empty list on error
    }
  }

  // Delete a product from a shop
  Future<void> deleteProductFromShop(String shopId, String productId) async {
    try {
      await _firestore.collection('shops').doc(shopId).collection('products').doc(productId).delete();
      print('Product deleted successfully: $productId');
    } catch (e) {
      print('Error deleting product: $e');
    }
  }

  // Update product details in a shop
  Future<void> updateProductInShop(String shopId, String productId, String name, String imageUrl, double price, int quantity) async {
    try {
      await _firestore.collection('shops').doc(shopId).collection('products').doc(productId).update({
        'name': name,
        'imageUrl': imageUrl,
        'price': price,
        'quantity': quantity,
      });
      print('Product updated successfully: $productId');
    } catch (e) {
      print('Error updating product: $e');
    }
  }

  // Fetch shop by ID (for retrieving shop details)
  Future<Map<String, dynamic>> fetchShopById(String shopId) async {
    try {
      DocumentSnapshot shopDoc = await _firestore.collection('shops').doc(shopId).get();
      if (shopDoc.exists) {
        return shopDoc.data() as Map<String, dynamic>; // Return the shop document as a Map
      } else {
        throw Exception("Shop not found");
      }
    } catch (e) {
      print('Error fetching shop: $e');
      throw e; // Rethrow error for handling in UI
    }
  }
}
