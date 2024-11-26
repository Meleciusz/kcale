import 'package:flutter/material.dart';
import 'package:menu_repository/menu_repository.dart';

import 'widgets/widgets.dart';

class WidgetSuccessStats extends StatefulWidget {
  const WidgetSuccessStats({super.key, required this.menu});

  final List<Menu>? menu;


  @override
  State<WidgetSuccessStats> createState() => _WidgetSuccessState();
}

class _WidgetSuccessState extends State<WidgetSuccessStats> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static final List<Widget> _screens = <Widget>[
    StatsScreen(tytul: 'Statystyki Dzienne'),
    StatsScreen(tytul: 'Statystyki Tygodniowe'),
    StatsScreen(tytul: 'Statystyki Miesięczne'),
  ];

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text('Statystyki'),
          ),
          body: Center(
            child: _screens.elementAt(_selectedIndex),
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
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.blue,
            onTap: _onItemTapped,
          ),
        )
    );
  }
}
