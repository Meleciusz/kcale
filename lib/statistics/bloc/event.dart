part of 'bloc.dart';

/*
 * Main description:
This file contains every event that bloc can have
 */

class StatsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}


class GetMenuWithTime extends StatsEvent {
  GetMenuWithTime({
    required this.userId,
    required this.time,
    required this.actualIndex,
  });
  final String userId;
  final int time;
  final int actualIndex;

  @override
  List<Object?> get props => [];
}


