import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:horizontal_week_calendar/horizontal_week_calendar.dart';
import 'package:menu_repository/model/model.dart';
import '../../../authorization/app/bloc/app_bloc.dart';
import '../../../products/view/add_product_screen.dart';
import '../../bloc/bloc.dart';


class MenuSuccess extends StatefulWidget {
  const MenuSuccess({super.key, required this.menu, required this.date});

  final List<Menu>? menu;
  final DateTime? date;

  @override
  State<MenuSuccess> createState() => _MenuSuccessState();
}

class _MenuSuccessState extends State<MenuSuccess> {
  late DateTime _selectedDate;
  final DateTime initialDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.date ?? initialDate;
  }
  
  @override
  Widget build(BuildContext context) {
    const mainColor = Color.fromARGB(255, 196, 115, 115);


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
            initialDate: _selectedDate,
            onDateChange: (DateTime newDate) {
              if(newDate.isBefore(initialDate.add(const Duration(days:1)))){
                setState(() {
                  _selectedDate = newDate;
                });
                context.read<MenuBloc>().add(GetMenuWithDate(date: _selectedDate, dateRepository: _selectedDate));
              }
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
      floatingActionButton: CircularMenu(
          items: [
            CircularMenuItem(
                icon: Icons.add,
                color: Colors.blue,
                onTap: (){
                  Navigator.of(context).push(
                  MaterialPageRoute(
                  builder: (context) => const AddProductScreen(),
                   ),
                  );
                }
            ),
            CircularMenuItem(
                icon: Icons.exit_to_app,
                color: Colors.grey,
                onTap: (){
                  context.read<AppBloc>().add(const AppLogoutRequested());
                }
            )
          ]
      )
    );
  }
}
