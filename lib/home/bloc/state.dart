part of 'bloc.dart';

/*
 * Main description:
This file contains every state that bloc can be in and values that can be used in the bloc
 */


enum MenuStatus { initial, loading, success, error }

extension MenuStatusX on MenuStatus {
  bool get isInitial => this == MenuStatus.initial;
  bool get isLoading => this == MenuStatus.loading;
  bool get isSuccess => this == MenuStatus.success;
  bool get isError => this == MenuStatus.error;
}

class MenuState extends Equatable {
  const MenuState({
    this.status = MenuStatus.initial,
    this.menu,
    this.date,
  });

  final MenuStatus status;
  final List<Menu>? menu;
  final DateTime? date;



  @override
  List<Object?> get props => [status, menu, date];

  MenuState copyWith({
    MenuStatus? status,
    List<Menu>? menu,
    DateTime? date,
  }){
    return MenuState(
      status: status ?? this.status,
      menu: menu ?? this.menu,
      date: date ?? this.date,
    );
  }
}