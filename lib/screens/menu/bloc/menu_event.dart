part of 'menu_bloc.dart';

abstract class MenuEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class MenuFetched extends MenuEvent {}

class MenuReFetched extends MenuEvent {}

class AddMenu extends MenuEvent {
  AddMenu({
    required this.name,
    required this.isEatNow,
    required this.volumn,
    this.oldVolume,
  });

  final String name;
  final bool isEatNow;
  final double volumn;
  final double? oldVolume;

  @override
  List<Object?> get props => [name, isEatNow, volumn, oldVolume];
}
