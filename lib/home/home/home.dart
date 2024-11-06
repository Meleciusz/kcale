import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_repository/menu_repository.dart';
import '../bloc/bloc.dart';
import 'manager.dart';

/*
 * Main description:
This is the home page
This class is used to provide bloc and repository to layout
 */
class Home extends StatelessWidget {
  const Home({super.key});

  static Page<void> page() => const MaterialPage<void>(child: Home());

  @override
  Widget build(BuildContext context) {
    return
      RepositoryProvider(
        create: (context) => FirestoreMenuService(),
        child: BlocProvider<MenuBloc>(
          create: (context) =>
          MenuBloc(
            menuRepository: context.read<FirestoreMenuService>(),
          )
            ..add(GetMenu()),
          child: const Manager(),
        ),
      );
  }
}
