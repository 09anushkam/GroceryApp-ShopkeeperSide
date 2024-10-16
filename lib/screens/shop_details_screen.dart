import 'package:flutter/material.dart';
import 'add_product_screen.dart';
import '../services/firebase_service.dart';

class ShopDetailsScreen extends StatefulWidget {
  @override
  _ShopDetailsScreenState createState() => _ShopDetailsScreenState();
}

class _ShopDetailsScreenState extends State<ShopDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _shopTypeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();

  final FirebaseService _firebaseService = FirebaseService();
  bool _isLoading = false;

  Future<void> _saveShopDetails() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Add shop details
        String? shopId = await _firebaseService.addShopIfNotExists(_shopNameController.text);

        if (shopId != null) {
          // Navigate to the Add Product Screen with shop ID
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddProductScreen(products: [], shopId: shopId),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to create shop')),
          );
        }
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
        title: Text('Shop Details'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _shopNameController,
                    decoration: InputDecoration(labelText: 'Shop Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the shop name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  // Type of Shop
                  TextFormField(
                    controller: _shopTypeController,
                    decoration: InputDecoration(labelText: 'Type of Shop'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the type of shop';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  // Location
                  TextFormField(
                    controller: _locationController,
                    decoration: InputDecoration(labelText: 'Location'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the location';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  // Contact Number
                  TextFormField(
                    controller: _contactNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(labelText: 'Contact Number'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the contact number';
                      }
                      if (value.length != 10) {
                        return 'Please enter a valid 10-digit phone number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: _saveShopDetails,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: Text(
                      "Proceed to Add Products",
                      style: TextStyle(color: Colors.white), // Set the text color to white
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Center(child: CircularProgressIndicator()), // Display loading indicator
        ],
      ),
    );
  }
}
