import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kcale/products/view/widgets/ProductItem.dart';
import 'package:kcale/products/view/add_product_screen.dart';
import 'package:kcale/products/bloc/bloc.dart';
import 'edit_product_screen.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products list'),
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
                  onDelete: () {
                    context.read<ProductBloc>().add(DeleteProduct(productId: product.id));
                  },
                  onEdit: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EditProductScreen(product: product),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return Center(
              child: Text(
                state.message ?? 'Error during products loading.',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
        },
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 25.0, bottom: 16.0),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddProductScreen(),
                ),
              );
            },
            child: const Icon(Icons.add),
            backgroundColor: Colors.green,
          ),
        ),
      ),
    );
  }
}
