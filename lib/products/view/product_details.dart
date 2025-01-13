import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kcale/home/bloc/bloc.dart';
import 'package:product_repository/models/product.dart';

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
        Weight: double.parse((_currentWeight).toStringAsFixed(2)),
        Calories: double.parse((widget.product.Calories * scaleFactor).toStringAsFixed(2)),
        Carbohydrates: double.parse((widget.product.Carbohydrates * scaleFactor).toStringAsFixed(2)),
        Fat: double.parse((widget.product.Fat * scaleFactor).toStringAsFixed(2)),
        Protein: double.parse((widget.product.Protein * scaleFactor).toStringAsFixed(2)),
        Sugar: double.parse((widget.product.Sugar * scaleFactor).toStringAsFixed(2)),
      );
    });
  }

  void _addToMenu() {
    final scaledProduct = widget.product.copyWith(
      Weight: double.parse((_currentWeight).toStringAsFixed(2)),
      Calories: double.parse((_scaledProduct.Calories).toStringAsFixed(2)),
      Carbohydrates: double.parse((_scaledProduct.Carbohydrates).toStringAsFixed(2)),
      Fat: double.parse((_scaledProduct.Fat).toStringAsFixed(2)),
      Protein: double.parse((_scaledProduct.Protein).toStringAsFixed(2)),
      Sugar: double.parse((_scaledProduct.Sugar).toStringAsFixed(2)),
      id: DateTime.now().millisecondsSinceEpoch.toString(),
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
