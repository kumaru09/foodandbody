import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class NearRestaurant extends Equatable {
  const NearRestaurant(
      {this.name,
      this.imageUrl,
      this.distance,
      this.rating,
      this.open,
      this.close});

  final String? name;
  final String? imageUrl;
  final String? distance;
  final double? rating;
  final String? open;
  final String? close;

  @override
  List<Object?> get props => [name, distance, imageUrl, rating, open, close];
}
