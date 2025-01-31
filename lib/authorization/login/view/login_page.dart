import 'package:authorization_repository/authorization_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kcale/authorization/login/view/login_form.dart';

import '../cubit/login_cubit.dart';


/*
 * Main description:
This is the home page
This class is used to provide bloc and repository to layout and to display login page widget
 */
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: LoginPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocProvider(
          create: (_) => LoginCubit(context.read<AuthorizationRepository>()),
          child: const LoginForm(),
        ),
      ),
    );
  }
}