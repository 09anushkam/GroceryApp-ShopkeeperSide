import 'package:flutter/material.dart';
import 'dart:io';
import '../models/product_model.dart';
import 'add_product_screen.dart'; // Import your AddProductScreen here
import 'shop_created_screen.dart';

class ProductListScreen extends StatefulWidget {
  final List<Product> products;
  final String shopName; // Add shop name

  ProductListScreen({required this.products, required this.shopName});

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  Widget build(BuildContext context) {
    print('Shop Name: ${widget.shopName}');
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text(widget.shopName, style: TextStyle(color: Colors.white)),
          actions: [
            IconButton(
              icon: Icon(Icons.location_on),
              onPressed: () {
                // Location action here
              },
            ),
          ],
        ),
        body: widget.products.isEmpty
            ? Center(child: Text('No products available.'))
            : ListView.builder(
          itemCount: widget.products.length,
          itemBuilder: (context, index) {
            final product = widget.products[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: product.imageUrl == null || product.imageUrl.isEmpty
                    ? Icon(Icons.image, size: 50)
                    : Image.file(File(product.imageUrl), width: 50, height: 50, fit: BoxFit.cover),
                title: Text(product.name),
                subtitle: Text('${product.category} - Rs. ${product.price}'),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {
                    // Pass the product to the AddProductScreen for editing
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddProductScreen(
                          products: widget.products,
                          productToEdit: product, shopId: '', // Pass the product to be edited
                        ),
                      ),
                    );
                  },
                  child: Text('Edit'),
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: BottomAppBar(
          // child: Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left Button: Add more items
                ElevatedButton(
                  onPressed: () {
                    // Navigate back to AddProductScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddProductScreen(products: widget.products, shopId: '',)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Green button
                    // padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    'Add more items',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white), // Set text color here
                  ),
                ),

                // Right Button: Save & Next
                ElevatedButton(
                  onPressed: () {
                    // Add logic for Save & Next action
                    // Navigate to ShopCreatedScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShopCreatedScreen(
                          products: widget.products,
                          shopName: widget.shopName,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Green button
                    // padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    'Save & Next',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white), // Set text color here
                  ),
                ),
              ],
            ),
            // ),
            ),
        );
    }
}