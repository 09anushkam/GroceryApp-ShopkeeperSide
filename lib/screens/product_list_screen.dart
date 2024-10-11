import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/firebase_service.dart';
import 'add_product_screen.dart';
import 'shop_products_screen.dart'; // Import the new screen

class ProductListScreen extends StatefulWidget {
  final List<Product> products;
  final String shopId;

  ProductListScreen({required this.products, required this.shopId});

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Product>> _productListFuture;
  final FirebaseService _firebaseService = FirebaseService();
  List<Product> _products = []; // State variable to hold fetched products

  @override
  void initState() {
    super.initState();
    _productListFuture = _fetchProducts(); // Fetch products when screen initializes
  }

  Future<List<Product>> _fetchProducts() async {
    return await _firebaseService.fetchProductsForShop(widget.shopId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
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

          // Store fetched products in the state variable
          _products = snapshot.data!;

          return ListView.builder(
            itemCount: _products.length,
            itemBuilder: (context, index) {
              final product = _products[index];
              return ListTile(
                title: Text(product.name),
                subtitle: Text('Price: ${product.price} | Quantity: ${product.quantity}'),
                leading: Image.network(product.imageUrl, fit: BoxFit.cover),
                onTap: () {
                  // Navigate to edit product
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddProductScreen(
                        shopId: widget.shopId,
                        productToEdit: product,
                        products: [], // Pass products as needed
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddProductScreen(
                        shopId: widget.shopId,
                        products: [], // Pass products as needed
                      ),
                    ),
                  );
                },
                child: Text('Add Items'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  fixedSize: Size(150, 50),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the Shop Products screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShopProductsScreen(
                        shopId: widget.shopId,
                        products: _products, // Use the state variable
                      ),
                    ),
                  );
                },
                child: Text('Save and Next'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  fixedSize: Size(150, 50),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
