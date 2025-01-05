import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_repository/menu_repository.dart';

import '../bloc/bloc.dart';
import 'widgets/widgets.dart';

class WidgetSuccessStats extends StatefulWidget {
  const WidgetSuccessStats({super.key, required this.menu, required this.actualIndex});

  final List<Menu>? menu;
  final int? actualIndex;

  @override
  State<WidgetSuccessStats> createState() => _WidgetSuccessState();
}

class _WidgetSuccessState extends State<WidgetSuccessStats> {
  late int selectedIndex;
  String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.actualIndex ?? 0;
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });

    if(index == 0){
      context.read<StatsBloc>().add(GetMenuWithTime(userId: userId, time: 0, actualIndex: selectedIndex));
    }else if(index == 1){
      context.read<StatsBloc>().add(GetMenuWithTime(userId: userId, time: 7, actualIndex: selectedIndex));
    }else{
      context.read<StatsBloc>().add(GetMenuWithTime(userId: userId, time: 30, actualIndex: selectedIndex));
    }
  }

  @override
  Widget build(BuildContext context) {

    final List<Widget> screens = <Widget>[
      StatsScreen(time: 0, menu: widget.menu!),
      StatsScreen(time: 7, menu: widget.menu!),
      StatsScreen(time: 30, menu: widget.menu!),
    ];

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Statystyki')),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Powrót do poprzedniego ekranu (Menu)
            },
          ),
        ),
        body: Center(
          child: screens.elementAt(selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.today),
              label: 'Dzień',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Tydzień',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: 'Miesiąc',
            ),
          ],
          currentIndex: selectedIndex,
          selectedItemColor: Colors.blue,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
