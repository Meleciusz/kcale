import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:menu_repository/service/firestore_service.dart';
import 'package:equatable/equatable.dart';
import 'package:menu_repository/model/model.dart';

part 'event.dart';
part 'state.dart';


/*
 * Main description:
This file describes every event that bloc can have and connects those events with the states and repositories
 */
class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc({
    required this.menuRepository
  }) : super(const MenuState()){
    on<GetMenu>(_mapGetMenuEvent);
  }

  final FirestoreMenuService menuRepository;


  void _mapGetMenuEvent(GetMenu event, Emitter<MenuState> emit) async {
    try {
      emit(state.copyWith(status: MenuStatus.loading));
      final menu = await menuRepository.getMenu();
      emit(state.copyWith(status: MenuStatus.success, menu: menu));
    } catch (e) {
      emit(state.copyWith(status: MenuStatus.error));
    }
  }
}