import 'package:flutter/material.dart';

class StatsScreen extends StatelessWidget {
  final String tytul;

  const StatsScreen({Key? key, required this.tytul}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          tytul,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Expanded(
          child: Placeholder(), // Tutaj możesz dodać wykres lub inne statystyki
        ),
      ],
    );
  }
}