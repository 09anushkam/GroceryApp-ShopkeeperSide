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
  final FirebaseService _firebaseService = FirebaseService();
  bool _isLoading = false;

  Future<void> _saveShopDetails() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        String? shopId = await _firebaseService.addShopIfNotExists(_shopNameController.text);

        if (shopId != null) {
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
                  ElevatedButton(
                    onPressed: _saveShopDetails,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: Text('Proceed to Add Products'),
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
