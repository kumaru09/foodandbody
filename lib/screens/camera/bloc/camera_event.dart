part of 'camera_bloc.dart';

abstract class CameraEvent extends Equatable {
  const CameraEvent();

  @override
  List<Object> get props => [];
}

class GetPredicton extends CameraEvent {
  const GetPredicton({required this.file});
  final XFile file;
}

class GetPredictonWithDepth extends CameraEvent {
  const GetPredictonWithDepth({required this.file, required this.depth});
  final XFile file;
  final Depth depth;
}

class SetIsFlat extends CameraEvent {
  final int isFlat;
  SetIsFlat({required this.isFlat});
}

class SetHasPlane extends CameraEvent {
  final bool hasPlane;
  SetHasPlane({required this.hasPlane});
}
