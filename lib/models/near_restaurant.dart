import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class NearRestaurant extends Equatable {
  const NearRestaurant(
      {required this.name,
      required this.imageUrl,
      required this.distance,
      required this.rating,
      required this.open,
      required this.close});

  final String name;
  final String imageUrl;
  final double distance;
  final double rating;
  final TimeOfDay open;
  final TimeOfDay close;

  @override
  List<Object> get props => [name, distance, rating, open, close];
}
