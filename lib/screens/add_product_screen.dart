import 'package:flutter/material.dart';
import 'dart:io';
import 'product_list_screen.dart';
import '../models/product_model.dart';
import '../services/firebase_service.dart';
import 'package:image_picker/image_picker.dart';

class AddProductScreen extends StatefulWidget {
  final List<Product> products;
  final String shopId; // Pass the shop ID dynamically
  final Product? productToEdit; // For editing functionality

  AddProductScreen({required this.products, required this.shopId, this.productToEdit});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();

  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if (widget.productToEdit != null) {
      _productNameController.text = widget.productToEdit!.name;
      _categoryController.text = widget.productToEdit!.category;
      _quantityController.text = widget.productToEdit!.quantity.toString();
      _priceController.text = widget.productToEdit!.price.toString();
      _image = XFile(widget.productToEdit!.imageUrl);
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = pickedImage;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('No image selected'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      if (_image == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please upload an image'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        // Upload the image
        String? imageUrl = await _firebaseService.uploadImageToStorage(File(_image!.path));

        if (imageUrl == null) {
          throw Exception('Image upload failed');
        }

        // Create or update the product
        Product newProduct = Product(
          id: widget.productToEdit?.id ?? '',
          name: _productNameController.text,
          category: _categoryController.text,
          imageUrl: imageUrl,
          quantity: int.parse(_quantityController.text),
          price: double.parse(_priceController.text),
        );

        // Save the product under the shop in Firestore
        if (widget.productToEdit == null) {
          await _firebaseService.addProductToShop(
            widget.shopId,
            newProduct.name,
            imageUrl,
            newProduct.price,
            newProduct.quantity,
          );
        } else {
          await _firebaseService.updateProductInShop(
            widget.shopId,
            widget.productToEdit!.id,
            newProduct.name,
            imageUrl,
            newProduct.price,
            newProduct.quantity,
          );
        }

        // Navigate to ProductListScreen with updated data
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductListScreen(products: widget.products, shopId: widget.shopId),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save product: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(widget.productToEdit == null ? 'Add Product' : 'Edit Product'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _productNameController,
                    decoration: InputDecoration(labelText: 'Name of the Product'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the product name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _categoryController,
                    decoration: InputDecoration(labelText: 'Category'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the category';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: _image == null
                          ? Icon(Icons.add_photo_alternate, color: Colors.grey, size: 50)
                          : Image.file(File(_image!.path), fit: BoxFit.cover),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Quantity'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the quantity';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Price'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the price';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveProduct,
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(widget.productToEdit == null ? 'Add Product' : 'Update Product'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
