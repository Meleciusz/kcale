import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String id;

  String Name;

  num Weight;

  num Calories;

  num Carbohydrates;

  num Fat;

  num Protein;

  num Sugar;

  Timestamp ModifiedDate;

  Product({
    required this.id,
    required this.Name,
    required this.Weight,
    required this.Calories,
    required this.Carbohydrates,
    required this.Fat,
    required this.Protein,
    required this.Sugar,
    required this.ModifiedDate
});

  Product copyWith({
    String? id,
    String? Name,
    num? Weight,
    num? Calories,
    num? Carbohydrates,
    num? Fat,
    num? Protein,
    num? Sugar,
    Timestamp? ModifiedDate,
}){
    return Product(id: id ?? this.id,
        Name: Name ?? this.Name,
        Weight: Weight ?? this.Weight,
        Calories: Calories ?? this.Calories,
        Carbohydrates: Carbohydrates ?? this.Carbohydrates,
        Fat: Fat ?? this.Fat,
        Protein: Protein ?? this.Protein,
        Sugar: Sugar ?? this.Sugar,
        ModifiedDate: ModifiedDate ?? this.ModifiedDate,
    );
  }
}