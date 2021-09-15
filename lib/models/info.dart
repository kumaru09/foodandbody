class Info {
  Info({
    required this.name,
    required this.goal,
    required this.height,
    required this.weight,
    required this.gender
  });

  Info.fromJson(Map<String, Object?> json)
    : this(
      name: json['name']! as String,
      goal: json['goal']! as int,
      height: json['height'] as int,
      weight: json['weight'] as int,
      gender: json['gender'] as String,
    );

  final String name;
  final int goal;
  final int height;
  final int weight;
  final String gender;

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'goal': goal,
      'height': height,
      'weight': weight,
      'gender': gender,
    };
  }
 
}
