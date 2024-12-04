import 'package:flutter/material.dart';

/*
ContainerBody - custom container for widgets
 */
class ContainerBody extends StatelessWidget {
  const ContainerBody({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.grey[200],
        ),
        child: ListView(
          children: children,
        ),
      ),
    );
  }
}