import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Importuj bibliotekę BLoC
import 'package:kcale/home/bloc/bloc.dart';
import 'package:product_repository/models/product.dart';

import '../../home/view/widget_success.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  final DateTime date;
  final String userId;

  const ProductDetailsScreen({super.key, required this.product, required this.date, required this.userId});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final TextEditingController _weightController = TextEditingController(text: '100');
  late double _currentWeight;
  late Product _scaledProduct;

  @override
  void initState() {
    super.initState();
    _currentWeight = 100;
    _scaledProduct = widget.product;
  }

  void _updateMacros() {
    setState(() {
      _currentWeight = double.tryParse(_weightController.text) ?? 100;
      final scaleFactor = _currentWeight / 100;

      _scaledProduct = widget.product.copyWith(
        Weight: _currentWeight.toDouble(),
        Calories: (widget.product.Calories * scaleFactor).toDouble(),
        Carbohydrates: (widget.product.Carbohydrates * scaleFactor).toDouble(),
        Fat: (widget.product.Fat * scaleFactor).toDouble(),
        Protein: (widget.product.Protein * scaleFactor).toDouble(),
        Sugar: (widget.product.Sugar * scaleFactor).toDouble(),
      );
    });
  }

  void _addToMenu() {
    final scaledProduct = widget.product.copyWith(
      Weight: _currentWeight.toDouble(),
      Calories: (_scaledProduct.Calories).toDouble(),
      Carbohydrates: (_scaledProduct.Carbohydrates).toDouble(),
      Fat: (_scaledProduct.Fat).toDouble(),
      Protein: (_scaledProduct.Protein).toDouble(),
      Sugar: (_scaledProduct.Sugar).toDouble(),
    );

    BlocProvider.of<MenuBloc>(context).add(
      AddProductToMenu(
        product: scaledProduct,
        date: widget.date,
        userId: widget.userId,
      ),
    );

    Navigator.pop(context, true);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.Name),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Adjust Weight (grams):',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),

            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Weight (g)',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: _updateMacros,
                ),
              ),
              onSubmitted: (_) => _updateMacros(),
            ),

            const SizedBox(height: 24),

            Text(
              'Nutritional Information:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),

            _buildNutritionalRow('Calories', _scaledProduct.Calories.toDouble(), 'kcal'),
            _buildNutritionalRow('Carbohydrates', _scaledProduct.Carbohydrates.toDouble(), 'g'),
            _buildNutritionalRow('Fat', _scaledProduct.Fat.toDouble(), 'g'),
            _buildNutritionalRow('Protein', _scaledProduct.Protein.toDouble(), 'g'),
            _buildNutritionalRow('Sugar', _scaledProduct.Sugar.toDouble(), 'g'),

            ElevatedButton(
              onPressed: _addToMenu,
              child: Text('Add to Menu'),

            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionalRow(String label, double value, String unit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          Text('${value.toStringAsFixed(2)} $unit',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[700])),
        ],
      ),
    );
  }
}
