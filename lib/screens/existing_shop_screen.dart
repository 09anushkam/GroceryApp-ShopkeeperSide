import 'package:flutter/material.dart';
import '../models/shop_model.dart';
import '../services/firebase_service.dart';
import 'product_list_screen.dart';

class ExistingShopsScreen extends StatelessWidget {
  final FirebaseService _firebaseService = FirebaseService();

  ExistingShopsScreen({Key? key, required String userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Existing Shops'),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<List<Shop>>(
        future: _firebaseService.fetchShopsForUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No shops found.'));
          }

          final shops = snapshot.data!;
          return ListView.builder(
            itemCount: shops.length,
            itemBuilder: (context, index) {
              final shop = shops[index];
              return ListTile(
                title: Text(shop.name),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductListScreen(
                        shopId: shop.id, products: [], // Ensure the constructor accepts this parameter
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
