import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/bloc.dart';
import '../view/add_product_screen.dart';

class Manager extends StatelessWidget {
  const Manager({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        print("Current state: ${state.status}");

        if (state.status.isSuccess) {
          return BlocProvider.value(
            value: context.read<ProductBloc>(),
            child: const AddProductScreen(),
          );
        } else if (state.status.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.status.isError) {
          return const Center(child: Text('Error'));
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
