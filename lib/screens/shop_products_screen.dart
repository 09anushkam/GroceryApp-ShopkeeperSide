import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/firebase_service.dart';
import 'edit_product_screen.dart';

class ShopProductsScreen extends StatefulWidget {
  final String shopId;

  ShopProductsScreen({required this.shopId});

  @override
  _ShopProductsScreenState createState() => _ShopProductsScreenState();
}

class _ShopProductsScreenState extends State<ShopProductsScreen> {
  late Future<String> _shopNameFuture;
  late Future<List<Product>> _productListFuture;
  final FirebaseService _firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    _shopNameFuture = _fetchShopName();
    _productListFuture = _fetchProducts(); // Fetch products when screen initializes
  }

  Future<String> _fetchShopName() async {
    // Fetch shop name from Firestore using shopId
    var shopDoc = await _firebaseService.fetchShopById(widget.shopId);
    return shopDoc['name'];
  }

  Future<List<Product>> _fetchProducts() async {
    return await _firebaseService.fetchProductsForShop(widget.shopId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop Products'),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<List<Product>>(
        future: _productListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products found.'));
          }

          final products = snapshot.data!;

          return Column(
            children: [
              FutureBuilder<String>(
                future: _shopNameFuture,
                builder: (context, shopNameSnapshot) {
                  if (shopNameSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (shopNameSnapshot.hasError) {
                    return Center(child: Text('Error fetching shop name'));
                  }
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      shopNameSnapshot.data!,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ListTile(
                      title: Text(product.name),
                      subtitle: Text('Price: ${product.price} | Quantity: ${product.quantity}'),
                      leading: Image.network(product.imageUrl, fit: BoxFit.cover),
                      onTap: () {
                        // Navigate to edit product
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProductScreen(
                              products: products,
                              shopId: widget.shopId,
                              productToEdit: product,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
