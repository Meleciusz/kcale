import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kcale/products/home/manager.dart';
import 'package:product_repository/service/firestore_service.dart';
import '../bloc/bloc.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  static Page<void> page() => const MaterialPage<void>(child: Home());

  @override
  Widget build(BuildContext context) {
    return
      RepositoryProvider(
        create: (context) => FirestoreProductService(),
        child: BlocProvider<ProductBloc>(
          create: (context) =>
          ProductBloc(
            productRepository: context.read<FirestoreProductService>(),
          )
              ..add(LoadProducts()),
          child: const Manager(),
        ),
      );
  }
}
