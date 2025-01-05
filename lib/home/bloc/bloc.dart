import 'package:bloc/bloc.dart';
import 'package:menu_repository/service/firestore_service.dart';
import 'package:equatable/equatable.dart';
import 'package:menu_repository/model/model.dart';
import 'package:product_repository/models/product.dart';

part 'event.dart';
part 'state.dart';

/*
 * Main description:
This file describes every event that bloc can have and connects those events with the states and repositories
 */
class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc({
    required this.menuRepository,
  }) : super(const MenuState()) {
    on<GetMenuWithDate>(_mapGetMenuWithDateEvent);
    on<GetMenuWithUserID>(_mapGetMenuWithUserIDEvent);
    on<AddProductToMenu>(_mapAddProductToMenuEvent);
    on<RemoveProductFromMenu>(_mapRemoveProductFromMenuEvent);

  }

  final FirestoreMenuService menuRepository;

  void _mapGetMenuWithDateEvent(GetMenuWithDate event, Emitter<MenuState> emit) async {
    try {
      emit(state.copyWith(status: MenuStatus.loading));
      final menu = await menuRepository.getMenuWithDate(event.dateRepository, event.userId);
      emit(state.copyWith(status: MenuStatus.success, menu: menu, date: event.date));
    } catch (e) {
      emit(state.copyWith(status: MenuStatus.error));
    }
  }

  void _mapGetMenuWithUserIDEvent(GetMenuWithUserID event, Emitter<MenuState> emit) async {
    try {
      emit(state.copyWith(status: MenuStatus.loading));
      final menu = await menuRepository.getMenuWithUserID(event.userId);
      emit(state.copyWith(status: MenuStatus.success, menu: menu, date: DateTime.now()));
    } catch (e) {
      emit(state.copyWith(status: MenuStatus.error));
    }
  }


  void _mapAddProductToMenuEvent(AddProductToMenu event, Emitter<MenuState> emit) async {
    try {
      emit(state.copyWith(status: MenuStatus.loading));

      final String formattedDate = '${event.date.year}'
          '${event.date.month.toString().padLeft(2, '0')}'
          '${event.date.day.toString().padLeft(2, '0')}';
      final int dateNum = int.parse(formattedDate);

      final existingMenu = await menuRepository.getMenuForDateAndUser(dateNum, event.userId);

      if (existingMenu != null) {
        final updatedMenu = existingMenu.copyWith(
          CaloriesSum: existingMenu.CaloriesSum + event.product.Calories * (event.product.Weight / 100),
          CarbohydrateSum: existingMenu.CarbohydrateSum + event.product.Carbohydrates * (event.product.Weight / 100),
          FatSum: existingMenu.FatSum + event.product.Fat * (event.product.Weight / 100),
          ProteinSum: existingMenu.ProteinSum + event.product.Protein * (event.product.Weight / 100),
          SugarSum: existingMenu.SugarSum + event.product.Sugar * (event.product.Weight / 100),
          Names: [...existingMenu.Names, event.product.Name],
        );

        await menuRepository.updateMenu(updatedMenu);

        final updatedMenuList = await menuRepository.getMenuWithDate(event.date, event.userId);
        emit(state.copyWith(status: MenuStatus.success, menu: updatedMenuList, date: event.date));
      } else {
        final newMenu = Menu(
          id: 'new_id',
          userId: event.userId,
          Names: [event.product.Name],
          CaloriesSum: event.product.Calories * (event.product.Weight / 100),
          CarbohydrateSum: event.product.Carbohydrates * (event.product.Weight / 100),
          FatSum: event.product.Fat * (event.product.Weight / 100),
          ProteinSum: event.product.Protein * (event.product.Weight / 100),
          SugarSum: event.product.Sugar * (event.product.Weight / 100),
          Date: dateNum,
        );

        await menuRepository.addMenu(newMenu);

        final updatedMenuList = await menuRepository.getMenuWithDate(event.date, event.userId);
        emit(state.copyWith(status: MenuStatus.success, menu: updatedMenuList, date: event.date));
      }
    } catch (e) {
      print('Error: $e');
      emit(state.copyWith(status: MenuStatus.error));
    }
  }
  void _mapRemoveProductFromMenuEvent(RemoveProductFromMenu event, Emitter<MenuState> emit) async {
    try {
      emit(state.copyWith(status: MenuStatus.loading));

      final String formattedDate = '${event.date.year}'
          '${event.date.month.toString().padLeft(2, '0')}'
          '${event.date.day.toString().padLeft(2, '0')}';
      final int dateNum = int.parse(formattedDate);

      final existingMenu = await menuRepository.getMenuForDateAndUser(dateNum, event.userId);

      if (existingMenu != null) {
        final updatedNames = List<String>.from(existingMenu.Names);
        updatedNames.remove(event.product.Name);

        final updatedMenu = existingMenu.copyWith(
          CaloriesSum: existingMenu.CaloriesSum - event.product.Calories * (event.product.Weight / 100),
          CarbohydrateSum: existingMenu.CarbohydrateSum - event.product.Carbohydrates * (event.product.Weight / 100),
          FatSum: existingMenu.FatSum - event.product.Fat * (event.product.Weight / 100),
          ProteinSum: existingMenu.ProteinSum - event.product.Protein * (event.product.Weight / 100),
          SugarSum: existingMenu.SugarSum - event.product.Sugar * (event.product.Weight / 100),
          Names: updatedNames,
        );

        await menuRepository.updateMenu(updatedMenu);

        final updatedMenuList = await menuRepository.getMenuWithDate(event.date, event.userId);
        emit(state.copyWith(status: MenuStatus.success, menu: updatedMenuList, date: event.date));
      }
    } catch (e) {
      print('Error: $e');
      emit(state.copyWith(status: MenuStatus.error));
    }
  }


}
