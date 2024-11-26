import 'package:bloc/bloc.dart';
import 'package:menu_repository/service/firestore_service.dart';
import 'package:equatable/equatable.dart';
import 'package:menu_repository/model/model.dart';

part 'event.dart';
part 'state.dart';


/*
 * Main description:
This file describes every event that bloc can have and connects those events with the states and repositories
 */
class StatsBloc extends Bloc<StatsEvent, StatsState> {
  StatsBloc({
    required this.menuRepository
  }) : super(const StatsState()){
    on<GetMenuWithTime>(_mapGetMenuWithTime);
  }

  final FirestoreMenuService menuRepository;


  void _mapGetMenuWithTime(GetMenuWithTime event, Emitter<StatsState> emit) async {
    try {
      emit(state.copyWith(status: StatsStatus.loading));
      final menu = await menuRepository.getMenuWithTime(event.userId, event.time);
      emit(state.copyWith(status: StatsStatus.success, menu: menu, actualIndex: event.actualIndex));
    } catch (e) {
      emit(state.copyWith(status: StatsStatus.error));
    }
  }
}