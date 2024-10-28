import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/*
* Main description:
This class is responsible for displaying the home page of the app.

* Navigator:
User can navigate to gym mode page
 */

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: HomePage());

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {


    return const Scaffold(
      body: Align(
        alignment: Alignment(0, -2/3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            Text(
              "Welcome"
            ),

            SizedBox(height: 8),
            SizedBox(height: 20),
            SizedBox(height: 40),
            SizedBox(height: 40),
          ],
        ),
      ),
      // drawer: const DrawerWidget(),
    );
  }
}
