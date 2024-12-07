import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kcale/products/view/widgets/MealProductItem.dart';

import '../bloc/bloc.dart';

class MealProductListScreen extends StatelessWidget {
  final String mealType; // Typ posiłku, do którego dodajemy produkt

  const MealProductListScreen({super.key, required this.mealType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wybierz produkt do $mealType'),
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state.status == ProductStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == ProductStatus.success) {
            final products = state.products;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductItem(
                  product: product,
                  onTap: () {
                    // Po kliknięciu dodajemy produkt do danego posiłku
                    Navigator.pop(context, product); // Zwróć produkt do poprzedniego ekranu
                  },
                );
              },
            );
          } else {
            return Center(
              child: Text(
                state.message ?? 'Błąd podczas ładowania produktów',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
        },
      ),
    );
  }
}
