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

class CalChanged extends CameraEvent {
  const CalChanged({required this.value});
  final String value;
}

class AddPlanCamera extends CameraEvent {
  const AddPlanCamera({required this.predicts});
  final List<Predict> predicts;
}

class AddBodyCamera extends CameraEvent {
  const AddBodyCamera({required this.bodyPredict});
  final BodyPredict bodyPredict;
}

class GetBodyPredict extends CameraEvent {
  const GetBodyPredict({required this.image, required this.height});
  final List<XFile> image;
  final int height;
}
