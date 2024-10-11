import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/firebase_service.dart';

class EditProductScreen extends StatefulWidget {
  final List<Product> products;
  final String shopId;
  final Product productToEdit;

  EditProductScreen({required this.products, required this.shopId, required this.productToEdit});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.productToEdit.name);
    _priceController = TextEditingController(text: widget.productToEdit.price.toString());
    _quantityController = TextEditingController(text: widget.productToEdit.quantity.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _saveChanges() async {
    String updatedName = _nameController.text;
    String updatedImageUrl = widget.productToEdit.imageUrl; // Assuming the image URL is not changed
    double updatedPrice = double.parse(_priceController.text);
    int updatedQuantity = int.parse(_quantityController.text);

    await _firebaseService.updateProductInShop(
      widget.shopId,
      widget.productToEdit.id,
      updatedName,
      updatedImageUrl,
      updatedPrice,
      updatedQuantity,
    );

    Navigator.pop(context); // Return to the previous screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveChanges,
              child: Text('Save'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Button color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
