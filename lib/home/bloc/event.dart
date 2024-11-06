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

// TODO: zrób tak żeby tylko te z odpowiednią datą zwacało, musisz to zrobić w packages - menu_repository i tam metodę na to a z bloca no to resetowanie stanu jedynie cały czas
class DateChanged extends MenuEvent {
  DateChanged({
    required this.date,
  });
  final Timestamp date;

  @override
  List<Object?> get props => [];
}

