part of 'bloc.dart';

/*
 * Main description:
This file contains every event that bloc can have
 */

class MenuEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddProductToMenu extends MenuEvent {
  final Product product;
  final DateTime date;
  final String userId;

  AddProductToMenu({
    required this.product,
    required this.date,
    required this.userId,
  });

  @override
  List<Object?> get props => [product, date, userId];
}

class GetMenuWithUserID extends MenuEvent {
  GetMenuWithUserID({
    required this.userId,
  });
  final String userId;

  @override
  List<Object?> get props => [];
}


class GetMenuWithDate extends MenuEvent {
  GetMenuWithDate({
    required this.dateRepository,
    required this.date,
    required this.userId,
  });
  final DateTime dateRepository;
  final DateTime date;
  final String userId;


  @override
  List<Object?> get props => [];
}

class RemoveProductFromMenu extends MenuEvent {
  final String productId;
  final String productName;
  final DateTime date;
  final String userId;

  RemoveProductFromMenu({
    required this.productId,
    required this.productName,
    required this.date,
    required this.userId,
  });

  @override
  List<Object?> get props => [productId, productName, date, userId];
}


