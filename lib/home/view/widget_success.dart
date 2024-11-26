import 'package:circular_menu/circular_menu.dart';
import 'package:container_body/container_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:horizontal_week_calendar/horizontal_week_calendar.dart';
import '../../statistics/home/home.dart';
import 'widgets/header_title.dart';
import 'package:menu_repository/model/model.dart';
import '../../authorization/app/bloc/app_bloc.dart';
import '../../products/view/add_product_screen.dart';
import '../bloc/bloc.dart';


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


    return Scaffold(
      backgroundColor: Colors.grey[200],
      body:  Column(
        children: [
            const HeaderTitle(),
            ContainerBody(
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
                      context.read<MenuBloc>().add(
                          GetMenuWithDate(
                              date: _selectedDate,
                              dateRepository: _selectedDate,
                              userId: context.read<AppBloc>().state.user.id
                          )
                      );
                    }
                  },
                ),

                widget.menu != null && widget.menu!.isNotEmpty
                    ? SizedBox(
                  height: MediaQuery.of(context).size.height * .15,
                  child: ListView.separated(
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemCount: widget.menu!.first.Names.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return  Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          widget.menu!.first.Names[index],
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                )
                    : SizedBox.shrink(),

              ],
            ),
          ],
      ),
      floatingActionButton: CircularMenu(
          alignment: Alignment.bottomCenter,
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
            ),
            CircularMenuItem(
                icon: Icons.bar_chart,
                color: Colors.redAccent,
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const HomeStats(),
                    ),
                  );
                }
            )
          ]
      )
    );
  }
}
