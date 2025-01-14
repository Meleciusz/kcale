import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kcale/products/view/product_details.dart';
import 'package:kcale/products/view/widgets/MealProductItem.dart';
import '../../home/bloc/bloc.dart';
import '../bloc/bloc.dart';

class MealProductListScreen extends StatelessWidget {
  final DateTime date;
  final String userId;
  const MealProductListScreen({super.key, required this.date, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                  onTap: () async {
                    final shouldRefresh = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsScreen(
                          product: product,
                          date: date,
                          userId: userId,
                        ),
                      ),
                    );

                    if (shouldRefresh == true) {
                      Navigator.pop(context, true);
                    }
                  },
                );
              },
            );
          } else {
            return Center(
              child: Text(
                state.message ?? 'Products loading error.',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
        },
      ),
    );
  }
}
