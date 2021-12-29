import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:foodandbody/models/nutrient.dart';

class InfoEntity extends Equatable {
  final String? name;
  final int? goal;
  final int? height;
  final int? weight;
  final String? gender;
  final String? photoUrl;
  final Nutrient? goalNutrient;
  final Timestamp? birthDate;

  const InfoEntity(
      {this.name,
      this.goal,
      this.height,
      this.weight,
      this.gender,
      this.photoUrl,
      this.goalNutrient,
      this.birthDate});

  static InfoEntity fromJson(Map<dynamic, dynamic> json) {
    return InfoEntity(
        name: json['name'] as String,
        birthDate: json['birthDate'] as Timestamp,
        goal: json['goal'] as int,
        height: json['height'] as int,
        weight: json['weight'] as int,
        gender: json['gender'] as String,
        photoUrl: json['photoUrl'] as String,
        goalNutrient: Nutrient.fromJson(json['goalNutrient']!));
  }

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'birthDate': birthDate,
      'goal': goal,
      'height': height,
      'weight': weight,
      'gender': gender,
      'photoUrl': photoUrl,
      'goalNutrient': goalNutrient!.toJson()
    };
  }

  // static const empty = InfoEntity(
  //     name: '',
  //     goal: null,
  //     height: null,
  //     weight: null,
  //     gender: '',
  //     photoUrl: '');

  @override
  List<Object?> get props =>
      [name, birthDate, goal, height, weight, gender, photoUrl, goalNutrient];

  @override
  String toString() {
    return 'InfoEntity {name: $name, bitrhDate: $birthDate, goal: $goal, height: $height, weight: $weight, gender: $gender, photoUrl: $photoUrl, goalNutrient: $goalNutrient}';
  }

  static InfoEntity fromSnapshot(DocumentSnapshot snap) {
    return InfoEntity(
        name: snap['name'],
        birthDate: snap['birthDate'],
        goal: snap['goal'],
        height: snap['height'],
        weight: snap['weight'],
        gender: snap['gender'],
        photoUrl: snap['photoUrl'],
        goalNutrient: Nutrient.fromJson(snap['goalNutrient']!));
  }

  Map<String, Object?> toDocument() {
    return {
      'name': name,
      'birthDate': birthDate,
      'goal': goal,
      'height': height,
      'weight': weight,
      'gender': gender,
      'photoUrl': photoUrl,
      'goalNutrient': goalNutrient!.toJson()
    };
  }
}
