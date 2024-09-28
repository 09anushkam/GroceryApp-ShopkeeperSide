import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(product.imageUrl),
        title: Text(product.name),
        subtitle: Text('Quantity: ${product.quantity} \nPrice: ${product.price}'),
        trailing: Icon(Icons.edit),
        onTap: () {
          // Add product editing functionality
        },
      ),
    );
  }
}
