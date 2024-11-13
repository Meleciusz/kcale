part of 'bloc.dart';

/*
 * Main description:
This file contains every event that bloc can have
 */

class MenuEvent extends Equatable {
  @override
  List<Object?> get props => [];
}


class GetMenu extends MenuEvent {
  @override
  List<Object?> get props => [];
}



class GetMenuWithDate extends MenuEvent {
  GetMenuWithDate({
    required this.dateRepository,
    required this.date,
  });
  final DateTime dateRepository;
  final DateTime date;

  @override
  List<Object?> get props => [];
}

