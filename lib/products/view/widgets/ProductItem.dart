import 'package:flutter/material.dart';
import 'package:product_repository/models/product.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  final VoidCallback onDelete;
  final VoidCallback onEdit;  // Dodanie callbacka dla edycji

  const ProductItem({
    super.key,
    required this.product,
    required this.onDelete,
    required this.onEdit,  // Dodanie parametru onEdit
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        title: Text(product.Name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Calories: ${product.Calories} kcal'),
            const SizedBox(height: 4),
            Text('Protein: ${product.Protein} g'),
            Text('Carbohydrates: ${product.Carbohydrates} g'),
            Text('Fat: ${product.Fat} g'),
            Text('Sugar: ${product.Sugar} g'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Przycisk edycji
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit, // Wywołanie callbacka dla edycji
            ),
            // Przycisk usuwania
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete, // Wywołanie callbacka dla usuwania
            ),
          ],
        ),
      ),
    );
  }
}
