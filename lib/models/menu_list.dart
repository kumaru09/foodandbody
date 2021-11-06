import 'package:equatable/equatable.dart';

class MenuList extends Equatable {
  const MenuList({required this.name, required this.calory, required this.imageUrl, required this.category});

  final String name;
  final int calory;
  final String imageUrl;
  final List<String>? category;

   factory MenuList.fromJson(Map<String, dynamic> json) {
    return MenuList(
      name: json['name'] as String,
      calory: json['calories'] as int,
      imageUrl: json['imageUrl'] as String, 
      category: json['category'] == null ? null : json['category'] as List<String>,
    );
  }

  @override
  List<Object> get props => [name, calory, imageUrl];
}