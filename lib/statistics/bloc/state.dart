part of 'bloc.dart';

/*
 * Main description:
This file contains every state that bloc can be in and values that can be used in the bloc
 */


enum StatsStatus { initial, loading, success, error }

extension StatsStatusX on StatsStatus {
  bool get isInitial => this == StatsStatus.initial;
  bool get isLoading => this == StatsStatus.loading;
  bool get isSuccess => this == StatsStatus.success;
  bool get isError => this == StatsStatus.error;
}

class StatsState extends Equatable {
  const StatsState({
    this.status = StatsStatus.initial,
    this.menu,
    this.date,
    this.userId,
  });

  final StatsStatus status;
  final List<Menu>? menu;
  final DateTime? date;
  final String? userId;



  @override
  List<Object?> get props => [status, menu, date];

  StatsState copyWith({
    StatsStatus? status,
    List<Menu>? menu,
    DateTime? date,
    String? userId,
  }){
    return StatsState(
      status: status ?? this.status,
      menu: menu ?? this.menu,
      date: date ?? this.date,
      userId: userId?? this.userId,
    );
  }
}