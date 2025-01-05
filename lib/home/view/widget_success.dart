import 'package:circular_menu/circular_menu.dart';
import 'package:container_body/container_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:horizontal_week_calendar/horizontal_week_calendar.dart';
import 'package:product_repository/models/product.dart';
import '../../products/view/meal_product_list_screen.dart';
import '../../products/view/product_list_screen.dart';
import '../../statistics/home/home.dart';
import 'widgets/header_title.dart';
import 'package:menu_repository/model/model.dart';
import '../../authorization/app/bloc/app_bloc.dart';
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
      body: Column(
        children: [
          const HeaderTitle(),
          ContainerBody(
            children: [
              HorizontalWeekCalendar(
                minDate: initialDate.subtract(const Duration(days: 30)),
                maxDate: initialDate.add(const Duration(days: 1)),
                initialDate: _selectedDate,
                onDateChange: (DateTime newDate) {
                  if (newDate.isBefore(initialDate.add(const Duration(days: 1)))) {
                    setState(() {
                      _selectedDate = newDate;
                    });
                    context.read<MenuBloc>().add(
                      GetMenuWithDate(
                        date: _selectedDate,
                        dateRepository: _selectedDate,
                        userId: context.read<AppBloc>().state.user.id,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              BlocBuilder<MenuBloc, MenuState>(
                builder: (context, state) {
                  if (state.status == MenuStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.status == MenuStatus.success) {
                    final menu = state.menu;
                    if (menu != null && menu.isNotEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          ...menu.map((menuItem) {
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  ...menuItem.Names.map((name) {
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          ' $name',
                                          style: Theme.of(context).textTheme.titleLarge,
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.red),
                                          onPressed: () {
                                            final productToRemove = Product(
                                              id: 'id',
                                              Name: name,
                                              Weight: 0,
                                              Calories: 0,
                                              Carbohydrates: 0,
                                              Fat: 0,
                                              Protein: 0,
                                              Sugar: 0,
                                            );
                                            context.read<MenuBloc>().add(
                                              RemoveProductFromMenu(
                                                product: productToRemove,
                                                date: _selectedDate,
                                                userId: context.read<AppBloc>().state.user.id,
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      );
                    } else {
                      return const Text('No products for this day.');
                    }
                  } else {
                    return const Text('Loading menu error.');
                  }
                },
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final shouldRefresh = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MealProductListScreen(
                          date: _selectedDate,
                          userId: context.read<AppBloc>().state.user.id,
                        ),
                      ),
                    );
                    if (shouldRefresh == true) {
                      await Future.delayed(const Duration(milliseconds: 100));
                      context.read<MenuBloc>().add(
                        GetMenuWithDate(
                          date: _selectedDate,
                          dateRepository: _selectedDate,
                          userId: context.read<AppBloc>().state.user.id,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 12.0,
                    ),
                  ),
                  child: const Text(
                    'Add Product',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: CircularMenu(
              alignment: Alignment.bottomRight,
              items: [
                CircularMenuItem(
                  icon: Icons.exit_to_app,
                  color: Colors.grey,
                  onTap: () {
                    context.read<AppBloc>().add(const AppLogoutRequested());
                  },
                ),
                CircularMenuItem(
                  icon: Icons.bar_chart,
                  color: Colors.redAccent,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const HomeStats(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: IconButton(
                icon: const Icon(
                  Icons.dining_outlined,
                  color: Colors.green,
                  size: 60.0,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ProductListScreen(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
