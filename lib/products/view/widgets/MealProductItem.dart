import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:product_repository/models/product.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  final Function() onTap;

  const ProductItem({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16.0),
          title: Text(product.Name, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Calories: ${product.Calories} kcal'),
              Text('Carbohydrates: ${product.Carbohydrates} g'),
              Text('Fat: ${product.Fat} g'),
              Text('Protein: ${product.Protein} g'),
            ],
          ),
        ),
      ),
    );
  }
}