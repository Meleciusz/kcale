import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:product_repository/models/product.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  final Function() onTap; // Funkcja, która będzie wywoływana po kliknięciu

  const ProductItem({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Wywołanie funkcji onTap po kliknięciu
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16.0),
          title: Text(product.Name, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('Calories: ${product.Calories} kcal'),
        ),
      ),
    );
  }
}
