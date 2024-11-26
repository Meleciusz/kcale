/*
Menu - class that describes menu items
 */
import 'package:cloud_firestore/cloud_firestore.dart';

class Menu{

  //id of menu - unique identifier
  String id;

  //id of adding User
  String userId;

  //name of products
  List<String> Names;

  //Sum of calories
  num CaloriesSum;

  //Sum of carbohydrates
  num CarbohydrateSum;

  //Sum of fats
  num FatSum;

  //Sum of protein
  num ProteinSum;

  //Sum of sugar
  num SugarSum;

  //date when the menu was created
  num Date;

  Menu({
    required this.id,
    required this.userId,
    required this.Names,
    required this.CaloriesSum,
    required this.CarbohydrateSum,
    required this.FatSum,
    required this.ProteinSum,
    required this.SugarSum,
    required this.Date,
  });

  Menu copyWith({
    String? id,
    String? userId,
    List<String>? Names,
    num? CaloriesSum,
    num? CarbohydrateSum,
    num? FatSum,
    num? ProteinSum,
    num? SugarSum,
    num? Date,
  }){
    return Menu(
        id: id ?? this.id,
        userId: userId?? this.userId,
        Names: Names?? this.Names,
        CaloriesSum: CaloriesSum?? this.CaloriesSum,
        CarbohydrateSum: CarbohydrateSum?? this.CarbohydrateSum,
        FatSum: FatSum?? this.FatSum,
        ProteinSum: ProteinSum ?? this.ProteinSum,
        SugarSum: SugarSum ?? this.SugarSum,
        Date: Date?? this.Date,
    );
  }
}