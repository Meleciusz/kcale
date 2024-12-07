import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_repository/models/product.dart';

import '../bloc/bloc.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;

  const EditProductScreen({super.key, required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();

  // Text controllers for form fields
  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();
  final _sugarController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Initialize controllers with current product values
    _nameController.text = widget.product.Name;
    _caloriesController.text = widget.product.Calories.toString();
    _proteinController.text = widget.product.Protein.toString();
    _carbsController.text = widget.product.Carbohydrates.toString();
    _fatController.text = widget.product.Fat.toString();
    _sugarController.text = widget.product.Sugar.toString();
  }

  @override
  void dispose() {
    // Dispose the controllers when screen is disposed
    _nameController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    _sugarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the product name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _caloriesController,
                decoration: const InputDecoration(labelText: 'Calories'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter calorie value';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _proteinController,
                decoration: const InputDecoration(labelText: 'Protein (g)'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _carbsController,
                decoration: const InputDecoration(labelText: 'Carbohydrates (g)'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _fatController,
                decoration: const InputDecoration(labelText: 'Fat (g)'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _sugarController,
                decoration: const InputDecoration(labelText: 'Sugar (g)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Create a new product with updated values
                    final updatedProduct = widget.product.copyWith(
                      Name: _nameController.text,
                      Calories: int.tryParse(_caloriesController.text) ?? 0,
                      Carbohydrates: double.tryParse(_carbsController.text) ?? 0,
                      Fat: double.tryParse(_fatController.text) ?? 0,
                      Protein: double.tryParse(_proteinController.text) ?? 0,
                      Sugar: double.tryParse(_sugarController.text) ?? 0,
                    );

                    // Update product in Firestore
                    context.read<ProductBloc>().add(UpdateProduct(product: updatedProduct));

                    // Go back to the previous screen
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
