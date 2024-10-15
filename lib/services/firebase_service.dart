import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';  // Import FirebaseAuth for user info
import 'dart:io';
import '../models/product_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;  // FirebaseAuth instance

  // Add Shop if it doesn't exist, and return the shop ID
  Future<String?> addShopIfNotExists(String shopName) async {
    try {
      String? userId = _auth.currentUser?.uid;  // Get current user ID
      if (userId == null) throw Exception('No user logged in');

      QuerySnapshot query = await _firestore.collection('shops')
          .where('name', isEqualTo: shopName)
          .where('userId', isEqualTo: userId)  // Check for existing shop by the logged-in user
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        return query.docs.first.id; // Return existing shop ID
      } else {
        DocumentReference newShopRef = await _firestore.collection('shops').add({
          'name': shopName,
          'userId': userId,  // Associate shop with the logged-in user
          'createdAt': FieldValue.serverTimestamp(),
        });
        return newShopRef.id; // Return newly created shop ID
      }
    } catch (e) {
      print('Error adding or checking shop: $e');
      return null;
    }
  }

  // Upload image to Firebase Storage and get the image URL
  Future<String?> uploadImageToStorage(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = _storage.ref().child('product_images').child(fileName);
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;

      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // Add product to a specific shop
  Future<void> addProductToShop(String shopId, String productName, String imageUrl, double price, int quantity) async {
    try {
      String? userId = _auth.currentUser?.uid;  // Get current user ID
      if (userId == null) throw Exception('No user logged in');

      await _firestore.collection('shops').doc(shopId).collection('products').add({
        'name': productName,
        'imageUrl': imageUrl,
        'price': price,
        'quantity': quantity,
        'userId': userId,  // Associate product with the logged-in user
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('Product added successfully to shop: $shopId');
    } catch (e) {
      print('Error adding product to shop: $e');
    }
  }

  // Fetch products for a specific shop (for the logged-in user)
  Future<List<Product>> fetchProductsForShop(String shopId) async {
    try {
      String? userId = _auth.currentUser?.uid;  // Get current user ID
      if (userId == null) throw Exception('No user logged in');

      QuerySnapshot querySnapshot = await _firestore.collection('shops').doc(shopId)
          .collection('products')
          .where('userId', isEqualTo: userId)  // Fetch only products added by the logged-in user
          .get();

      return querySnapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error fetching products for shop: $e');
      return [];
    }
  }

  // Fetch shops only for the logged-in user
  Future<List<DocumentSnapshot>> fetchShopsForUser() async {
    try {
      String? userId = _auth.currentUser?.uid;  // Get current user ID
      if (userId == null) throw Exception('No user logged in');

      QuerySnapshot querySnapshot = await _firestore.collection('shops')
          .where('userId', isEqualTo: userId)  // Fetch only shops created by the logged-in user
          .get();

      return querySnapshot.docs;
    } catch (e) {
      print('Error fetching shops: $e');
      return [];
    }
  }

  // Fetch shop by ID (only if it belongs to the logged-in user)
  Future<DocumentSnapshot?> fetchShopById(String shopId) async {
    try {
      String? userId = _auth.currentUser?.uid;  // Get current user ID
      if (userId == null) throw Exception('No user logged in');

      DocumentSnapshot shop = await _firestore.collection('shops').doc(shopId).get();

      // Ensure the shop belongs to the logged-in user
      if (shop.exists && (shop.data() as Map<String, dynamic>?)?['userId'] == userId) {
        return shop;
      } else {
        throw Exception('Shop does not belong to the logged-in user.');
      }
    } catch (e) {
      print('Error fetching shop by ID: $e');
      return null;
    }
  }

  // Delete product from a shop (only if it belongs to the logged-in user)
  Future<void> deleteProductFromShop(String shopId, String productId) async {
    try {
      String? userId = _auth.currentUser?.uid;  // Get current user ID
      if (userId == null) throw Exception('No user logged in');

      // Ensure the product belongs to the logged-in user
      DocumentSnapshot product = await _firestore.collection('shops')
          .doc(shopId)
          .collection('products')
          .doc(productId)
          .get();

      if (product.exists && (product.data() as Map<String, dynamic>?)?['userId'] == userId) {
        await _firestore.collection('shops').doc(shopId).collection('products').doc(productId).delete();
        print('Product deleted successfully: $productId');
      } else {
        throw Exception('Product does not belong to the logged-in user.');
      }
    } catch (e) {
      print('Error deleting product: $e');
    }
  }

  // Update product in a shop (only if it belongs to the logged-in user)
  Future<void> updateProductInShop(String shopId, String productId, String name, String imageUrl, double price, int quantity) async {
    try {
      String? userId = _auth.currentUser?.uid;  // Get current user ID
      if (userId == null) throw Exception('No user logged in');

      // Ensure the product belongs to the logged-in user
      DocumentSnapshot product = await _firestore.collection('shops')
          .doc(shopId)
          .collection('products')
          .doc(productId)
          .get();

      if (product.exists && (product.data() as Map<String, dynamic>?)?['userId'] == userId) {
        await _firestore.collection('shops').doc(shopId).collection('products').doc(productId).update({
          'name': name,
          'imageUrl': imageUrl,
          'price': price,
          'quantity': quantity,
        });
        print('Product updated successfully: $productId');
      } else {
        throw Exception('Product does not belong to the logged-in user.');
      }
    } catch (e) {
      print('Error updating product: $e');
    }
  }
}
