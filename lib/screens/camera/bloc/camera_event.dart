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
