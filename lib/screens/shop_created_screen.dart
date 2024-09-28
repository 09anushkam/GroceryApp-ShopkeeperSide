import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/firebase_service.dart';
import 'product_list_screen.dart';

class ShopCreatedScreen extends StatefulWidget {
  final String shopName;
  final List<Product> products;

  const ShopCreatedScreen({required this.shopName, required this.products});

  @override
  _ShopCreatedScreenState createState() => _ShopCreatedScreenState();
}

class _ShopCreatedScreenState extends State<ShopCreatedScreen> {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    _createShopAndAddProducts();
  }

  Future<void> _createShopAndAddProducts() async {
    // Step 1: Add shop if it does not exist
    String? shopId = await _firebaseService.addShopIfNotExists(widget.shopName);

    if (shopId == null) {
      // If there's an error creating the shop, show an error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to create or find the shop'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    // Step 2: Add each product to the created shop
    for (var product in widget.products) {
      await _firebaseService.addProductToShop(shopId, product);
    }

    // Step 3: Navigate to the ProductListScreen after adding all products
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductListScreen(products: widget.products, shopName: widget.shopName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Creating Shop'),
        ),
        body: Center(
            child: CircularProgressIndicator(),
            ),
        );
    }
}