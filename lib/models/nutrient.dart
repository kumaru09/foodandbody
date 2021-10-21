class Nutrient {
  final double protein;
  final double fat;
  final double carb;

  const Nutrient({this.protein = 0, this.carb = 0, this.fat = 0});

  static Nutrient fromJson(Map<dynamic, dynamic> json) {
    return Nutrient(
        protein: json['protein'] as double,
        fat: json['fat'] as double,
        carb: json['carb'] as double);
  }

  Nutrient copyWith({double? protein, double? fat, double? carb}) {
    return Nutrient(
        protein: protein ?? this.protein,
        fat: fat ?? this.fat,
        carb: carb ?? this.carb);
  }

  Map<String, Object?> toJson() {
    return {'protein': protein, 'fat': fat, 'carb': carb};
  }
}
