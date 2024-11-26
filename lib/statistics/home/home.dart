import 'package:firebase_auth/firebase_auth.dart';
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
class HomeStats extends StatelessWidget {
  const HomeStats({super.key});



  static Page<void> page() => const MaterialPage<void>(child: HomeStats());

  @override
  Widget build(BuildContext context) {
    return
      RepositoryProvider(
        create: (context) => FirestoreMenuService(),
        child: BlocProvider<StatsBloc>(
          create: (context) =>
          StatsBloc(
            menuRepository: context.read<FirestoreMenuService>(),
          )
            ..add(GetMenuWithTime(userId: FirebaseAuth.instance.currentUser!.uid, time: 0, actualIndex: 0)),
          child: const Manager(),
        ),
      );
  }
}
