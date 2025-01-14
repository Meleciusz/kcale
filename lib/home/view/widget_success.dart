import 'package:circular_menu/circular_menu.dart';
import 'package:container_body/container_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:horizontal_week_calendar/horizontal_week_calendar.dart';
import 'package:product_repository/models/product.dart';
import '../../products/bloc/bloc.dart';
import '../../products/view/meal_product_list_screen.dart';
import '../../products/view/product_list_screen.dart';
import '../../statistics/home/home.dart';
import 'widgets/header_title.dart';
import 'package:menu_repository/model/model.dart';
import '../../authorization/app/bloc/app_bloc.dart';
import '../bloc/bloc.dart';

Product calculateMacros(ProductWeight productWeight, List<Product> allProducts) {
  final product = allProducts.firstWhere(
        (p) => p.Name.toLowerCase() == productWeight.name.toLowerCase(),
    orElse: () => Product(
      id: '',
      Name: productWeight.name,
      Weight: 0,
      Calories: 0,
      Carbohydrates: 0,
      Fat: 0,
      Protein: 0,
      Sugar: 0,
    ),
  );

  final factor = productWeight.weight / 100;
  return Product(
    id: product.id,
    Name: product.Name,
    Weight: productWeight.weight,
    Calories: product.Calories * factor,
    Carbohydrates: product.Carbohydrates * factor,
    Fat: product.Fat * factor,
    Protein: product.Protein * factor,
    Sugar: product.Sugar * factor,
  );
}



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
                    final allProducts = context.read<ProductBloc>().state.products;

                    if (menu != null && menu.isNotEmpty) {
                      final currentMenu = menu.first;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.0),
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Calories:', style: TextStyle(fontWeight: FontWeight.w500)),
                                    Text('${currentMenu.CaloriesSum.toStringAsFixed(1)} kcal'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Protein:', style: TextStyle(fontWeight: FontWeight.w500)),
                                    Text('${currentMenu.ProteinSum.toStringAsFixed(1)} g'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Carbohydrates:', style: TextStyle(fontWeight: FontWeight.w500)),
                                    Text('${currentMenu.CarbohydrateSum.toStringAsFixed(1)} g'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Fat:', style: TextStyle(fontWeight: FontWeight.w500)),
                                    Text('${currentMenu.FatSum.toStringAsFixed(1)} g'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Sugar:', style: TextStyle(fontWeight: FontWeight.w500)),
                                    Text('${currentMenu.SugarSum.toStringAsFixed(1)} g'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...menu.map((menuItem) => menuItem.products).expand((products) => products).map((productWeight) {
                            final enrichedProduct = calculateMacros(productWeight, allProducts);

                            return Container(
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.0),
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    enrichedProduct.Name,
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${enrichedProduct.Weight}g',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                                  ),
                                  const Divider(height: 16, thickness: 1, color: Colors.grey), // Dzielnik
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Calories:', style: TextStyle(fontWeight: FontWeight.w500)),
                                      Text('${enrichedProduct.Calories?.toStringAsFixed(1) ?? 'N/A'}'),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Protein:', style: TextStyle(fontWeight: FontWeight.w500)),
                                      Text('${enrichedProduct.Protein?.toStringAsFixed(1) ?? 'N/A'}g'),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Carbs:', style: TextStyle(fontWeight: FontWeight.w500)),
                                      Text('${enrichedProduct.Carbohydrates?.toStringAsFixed(1) ?? 'N/A'}g'),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Fat:', style: TextStyle(fontWeight: FontWeight.w500)),
                                      Text('${enrichedProduct.Fat?.toStringAsFixed(1) ?? 'N/A'}g'),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        context.read<MenuBloc>().add(
                                          RemoveProductFromMenu(
                                            productId: productWeight.id,
                                            productName: enrichedProduct.Name,
                                            date: _selectedDate,
                                            userId: context.read<AppBloc>().state.user.id,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
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
                      await Future.delayed(const Duration(milliseconds: 200));
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
