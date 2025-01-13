import 'package:bloc/bloc.dart';
import 'package:menu_repository/service/firestore_service.dart';
import 'package:equatable/equatable.dart';
import 'package:menu_repository/model/model.dart';
import 'package:product_repository/models/product.dart';
import 'package:product_repository/product_repository.dart';

part 'event.dart';
part 'state.dart';

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

      // Format the date as num (yyyyMMdd)
      final String formattedDate = '${event.date.year}'
          '${event.date.month.toString().padLeft(2, '0')}'
          '${event.date.day.toString().padLeft(2, '0')}';
      final int dateNum = int.parse(formattedDate);

      final existingMenu = await menuRepository.getMenuForDateAndUser(dateNum, event.userId);

      if (existingMenu != null) {
        // Check if menu exists and add product
        final updatedMenu = existingMenu.copyWith(
          CaloriesSum: existingMenu.CaloriesSum + event.product.Calories,
          CarbohydrateSum: existingMenu.CarbohydrateSum + event.product.Carbohydrates,
          FatSum: existingMenu.FatSum + event.product.Fat,
          ProteinSum: existingMenu.ProteinSum + event.product.Protein,
          SugarSum: existingMenu.SugarSum + event.product.Sugar,
          products: [...existingMenu.products, ProductWeight(name: event.product.Name, weight: event.product.Weight, id: event.product.id)], // Add the id here
        );

        await menuRepository.updateMenu(updatedMenu);

        final updatedMenuList = await menuRepository.getMenuWithDate(event.date, event.userId);
        emit(state.copyWith(status: MenuStatus.success, menu: updatedMenuList, date: event.date));
      } else {
        // If the menu doesn't exist, create a new one with an id
        final newMenu = Menu(
          id: 'new_id',  // Add a unique id here, possibly generate or retrieve one from another source
          userId: event.userId,
          products: [ProductWeight(name: event.product.Name, weight: event.product.Weight, id: event.product.id)],  // Include product id
          CaloriesSum: event.product.Calories,
          CarbohydrateSum: event.product.Carbohydrates,
          FatSum: event.product.Fat,
          ProteinSum: event.product.Protein,
          SugarSum: event.product.Sugar,
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
        final updatedProducts = List<ProductWeight>.from(existingMenu.products);
        final removedProductWeight = updatedProducts.firstWhere(
              (product) => product.id == event.productId,
        );

        if (removedProductWeight != null) {
          updatedProducts.removeWhere((product) => product.id == event.productId);

          final productDetails = await menuRepository.getProductByName(event.productName);

          if (productDetails != null) {
            final factor = removedProductWeight.weight / 100;

            final caloriesToRemove = productDetails.Calories * factor;
            final carbohydratesToRemove = productDetails.Carbohydrates * factor;
            final fatToRemove = productDetails.Fat * factor;
            final proteinToRemove = productDetails.Protein * factor;
            final sugarToRemove = productDetails.Sugar * factor;

            final updatedMenu = existingMenu.copyWith(
              CaloriesSum: existingMenu.CaloriesSum - caloriesToRemove,
              CarbohydrateSum: existingMenu.CarbohydrateSum - carbohydratesToRemove,
              FatSum: existingMenu.FatSum - fatToRemove,
              ProteinSum: existingMenu.ProteinSum - proteinToRemove,
              SugarSum: existingMenu.SugarSum - sugarToRemove,
              products: updatedProducts,
            );

            await menuRepository.updateMenu(updatedMenu);

            final updatedMenuList = await menuRepository.getMenuWithDate(event.date, event.userId);
            emit(state.copyWith(status: MenuStatus.success, menu: updatedMenuList, date: event.date));
          } else {
            throw Exception("Product not found");
          }
        } else {
          throw Exception("Product not found");
        }
      }
    } catch (e) {
      print('Error: $e');
      emit(state.copyWith(status: MenuStatus.error));
    }
  }

}
