import 'package:equatable/equatable.dart';

class MenuCard extends Equatable {
  const MenuCard({required this.name, required this.calory, required this.imageUrl});

  final String name;
  final int calory;
  final String imageUrl;

  @override
  List<Object> get props => [name, calory, imageUrl];
}