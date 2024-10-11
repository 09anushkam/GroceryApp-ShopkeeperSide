import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/firebase_service.dart';
import 'add_product_screen.dart';


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
        backgroundColor: Colors.green, // Set app bar color to green
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


          return ListView.builder(
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
                      builder: (context) => AddProductScreen(
                        products: widget.products,
                        shopId: widget.shopId,
                        productToEdit: product,
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align buttons in a row
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddProductScreen(products: widget.products, shopId: widget.shopId),
                    ),
                  );
                },
                child: Text('Add Items'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Button color
                  fixedSize: Size(150, 50), // Fixed width and height
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ),
            SizedBox(width: 10), // Space between buttons
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Handle save and next functionality here
                  // Add your logic for saving products and navigating to the next screen
                  print("Save and Next button pressed"); // Placeholder for functionality
                },
                child: Text('Save and Next'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Button color
                  fixedSize: Size(150, 50), // Fixed width and height
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

