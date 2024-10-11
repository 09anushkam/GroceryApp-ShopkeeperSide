import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/firebase_service.dart';
import 'edit_product_screen.dart';
import 'registration_screen.dart'; // Import the home page

class ShopProductsScreen extends StatefulWidget {
  final String shopId;

  ShopProductsScreen({required this.shopId, required List<Product> products});

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
    _productListFuture = _fetchProducts();
  }

  Future<String> _fetchShopName() async {
    var shopDoc = await _firebaseService.fetchShopById(widget.shopId);
    return shopDoc['name'];
  }

  Future<List<Product>> _fetchProducts() async {
    return await _firebaseService.fetchProductsForShop(widget.shopId);
  }

  // Function to delete a product
  void _deleteProduct(Product product) async {
    await _firebaseService.deleteProductFromShop(widget.shopId, product.id);
    setState(() {
      _productListFuture = _fetchProducts(); // Update the UI after deletion
    });
  }

  // Function to show a success message and redirect
  void _showSuccessMessageAndRedirect() {
    final snackBar = SnackBar(
      content: Text('Shop created successfully! Products added to the shop.'),
      duration: Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    // Wait for 3 seconds before redirecting
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RegistrationScreen()),
      );
    });
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
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.green),
                            onPressed: () {
                              // Navigate to edit product screen
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
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _deleteProduct(product); // Delete product
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: _showSuccessMessageAndRedirect,
                  child: Text('Save and Finish'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    fixedSize: Size(double.infinity, 50), // Full width button
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
