import 'package:flutter/material.dart';
import 'package:horizontal_week_calendar/horizontal_week_calendar.dart';
import 'package:menu_repository/model/model.dart';


class MenuSuccess extends StatefulWidget {
  const MenuSuccess({super.key, required this.menu});

  final List<Menu>? menu;

  @override
  State<MenuSuccess> createState() => _MenuSuccessState();
}

class _MenuSuccessState extends State<MenuSuccess> {
  DateTime _selectedDate = DateTime.now();
  final DateTime initialDate = DateTime.now();

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Calendar'),
        ),
      ),
      body: Column(
        children: [
          HorizontalWeekCalendar(
            minDate: initialDate.subtract(const Duration(days: 30)),
            maxDate: initialDate.add(const Duration(days: 1)),
            initialDate: initialDate,
            onDateChange: (DateTime newDate) {
              setState(() {
                _selectedDate = newDate;
              });
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (var menuItem in widget.menu!)
                    Container(
                      margin: EdgeInsets.all(8),
                      child: Text(
                        menuItem.Names.toString() + _selectedDate.toString(),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

  }
}
