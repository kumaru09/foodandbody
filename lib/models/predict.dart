import 'package:equatable/equatable.dart';

class Predict extends Equatable {
  final String name;
  final double volume;

  Predict({required this.name, required this.volume});

  static Predict fromJson(Map<String, Object?> json) {
    return Predict(
        name: json['name'] as String,
        volume: double.parse(json['volume'] as String));
  }

  Predict copyWith({String? name, double? volume}) {
    return Predict(name: name ?? this.name, volume: volume ?? this.volume);
  }

  Map<String, Object> toJson() {
    return {"name": name, "volume": volume};
  }

  @override
  List<Object?> get props => [name, volume];
}
