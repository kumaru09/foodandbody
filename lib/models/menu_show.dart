class MenuShow {
  const MenuShow(
      {this.name = '',
      this.calory = 0,
      this.protein = 0,
      this.carb = 0,
      this.fat = 0,
      this.serve = 0,
      this.unit = '',
      this.imageUrl = ''});

  final String name;
  final int calory;
  final double protein;
  final double carb;
  final double fat;
  final double serve;
  final String unit;
  final String imageUrl;

  factory MenuShow.fromJson(Map<String, dynamic> json) {
    return MenuShow(
      name: json['name'],
      calory: json['calories'],
      protein: json['protein'].toDouble(),
      carb: json['carb'].toDouble(),
      fat: json['fat'].toDouble(),
      serve: json['serve'].toDouble(),
      unit: json['unit'],
      imageUrl: json['imageUrl'],
    );
  }

  @override
   String toString() {
    return 'MenuShow { name: $name,\n calory: $calory,\n protein: $protein,\n carb: $carb,\n fat: $fat,\n serve: $serve,\n unit: $unit,\n imageUrl: $imageUrl}';
  }
}