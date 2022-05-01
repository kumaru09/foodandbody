import 'package:equatable/equatable.dart';

class NearRestaurant extends Equatable {
  const NearRestaurant(
      {this.name,
      this.imageUrl,
      this.distance,
      this.rating,
      this.open,
      this.close,
      this.lat,
      this.lng,
      this.id});

  final String? name;
  final String? imageUrl;
  final String? distance;
  final double? rating;
  final String? open;
  final String? close;
  final double? lat;
  final double? lng;
  final String? id;

  @override
  List<Object?> get props =>
      [name, distance, imageUrl, rating, open, close, lat, lng, id];
}
