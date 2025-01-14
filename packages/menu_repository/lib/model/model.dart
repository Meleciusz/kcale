class ProductWeight {
  String id;
  String name;
  num weight;

  ProductWeight({
    required this.id,
    required this.name,
    required this.weight,
  });

  factory ProductWeight.fromMap(Map<String, dynamic> map) {
    return ProductWeight(
      id: map['id'],
      name: map['name'],
      weight: map['weight']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'weight': weight,
    };
  }
}

class Menu {
  String id;
  String userId;
  List<ProductWeight> products;
  num CaloriesSum;
  num CarbohydrateSum;
  num FatSum;
  num ProteinSum;
  num SugarSum;
  num Date;

  Menu({
    required this.id,
    required this.userId,
    required this.products,
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
    List<ProductWeight>? products,
    num? CaloriesSum,
    num? CarbohydrateSum,
    num? FatSum,
    num? ProteinSum,
    num? SugarSum,
    num? Date,
  }) {
    return Menu(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      products: products ?? this.products,
      CaloriesSum: CaloriesSum ?? this.CaloriesSum,
      CarbohydrateSum: CarbohydrateSum ?? this.CarbohydrateSum,
      FatSum: FatSum ?? this.FatSum,
      ProteinSum: ProteinSum ?? this.ProteinSum,
      SugarSum: SugarSum ?? this.SugarSum,
      Date: Date ?? this.Date,
    );
  }
}
