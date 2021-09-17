import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class InfoEntity extends Equatable {
  final String? name;
  final int? goal;
  final int? height;
  final int? weight;
  final String? gender;

  const InfoEntity(
      {this.name, this.goal, this.height, this.weight, this.gender});

  static InfoEntity fromJson(Map<String, Object?> json) {
    return InfoEntity(
      name: json['name'] as String,
      goal: json['goal'] as int,
      height: json['height'] as int,
      weight: json['weight'] as int,
      gender: json['gender'] as String,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'goal': goal,
      'height': height,
      'weight': weight,
      'gender': gender,
    };
  }

  static const empty =
      InfoEntity(name: '', goal: null, height: null, weight: null, gender: '');

  @override
  List<Object?> get props => [name, goal, height, weight, gender];

  @override
  String toString() {
    return 'InfoEntity {name: $name, goal: $goal, height: $height, weight: $weight, gender: $gender}';
  }

  static InfoEntity fromSnapshot(DocumentSnapshot snap) {
    return InfoEntity(
      name: snap['name'],
      goal: snap['goal'],
      height: snap['height'],
      weight: snap['weight'],
      gender: snap['gender'],
    );
  }

  Map<String, Object?> toDocument() {
    return {
      'name': name,
      'goal': goal,
      'height': height,
      'weight': weight,
      'gender': gender,
    };
  }
}
