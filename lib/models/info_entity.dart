import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class InfoEntity extends Equatable {
  final String? name;
  final int? goal;
  final int? height;
  final int? weight;
  final String? gender;
  final String? photoUrl;

  const InfoEntity(
      {this.name,
      this.goal,
      this.height,
      this.weight,
      this.gender,
      this.photoUrl});

  static InfoEntity fromJson(Map<String, Object?> json) {
    return InfoEntity(
      name: json['name'] as String,
      goal: json['goal'] as int,
      height: json['height'] as int,
      weight: json['weight'] as int,
      gender: json['gender'] as String,
      photoUrl: json['photoUrl'] as String,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'goal': goal,
      'height': height,
      'weight': weight,
      'gender': gender,
      'photoUrl': photoUrl,
    };
  }

  static const empty = InfoEntity(
      name: '',
      goal: null,
      height: null,
      weight: null,
      gender: '',
      photoUrl: '');

  @override
  List<Object?> get props => [name, goal, height, weight, gender, photoUrl];

  @override
  String toString() {
    return 'InfoEntity {name: $name, goal: $goal, height: $height, weight: $weight, gender: $gender, photoUrl: $photoUrl}';
  }

  static InfoEntity fromSnapshot(DocumentSnapshot snap) {
    return InfoEntity(
      name: snap['name'],
      goal: snap['goal'],
      height: snap['height'],
      weight: snap['weight'],
      gender: snap['gender'],
      photoUrl: snap['photoUrl'],
    );
  }

  Map<String, Object?> toDocument() {
    return {
      'name': name,
      'goal': goal,
      'height': height,
      'weight': weight,
      'gender': gender,
      'photoUrl': photoUrl,
    };
  }
}
