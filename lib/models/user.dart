import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.uid,
    this.email,
    this.name,
    this.photo
  });

  final String? email;
  final String? uid;
  final String? name;
  final String? photo;

  static const empty = User(uid: '');

  bool get isEmpty => this == User.empty;
  bool get isNotEmpty => this != User.empty;

  @override
  List<Object?> get props => [email, uid, name, photo];
}