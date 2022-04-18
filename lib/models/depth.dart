import 'package:equatable/equatable.dart';

class Depth extends Equatable {
  final String depth;
  final String fovW;
  final String fovH;

  Depth({required this.depth, required this.fovW, required this.fovH});

  static Depth fromJson(Map<String, dynamic> json) {
    return Depth(
        depth: json['depth'] as String,
        fovW: json['fovW'] as String,
        fovH: json['fovH'] as String);
  }

  @override
  List<Object?> get props => [depth, fovW, fovH];
}
