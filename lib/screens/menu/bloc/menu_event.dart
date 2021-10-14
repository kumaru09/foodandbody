part of 'menu_bloc.dart';

abstract class MenuEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class MenuFetched extends MenuEvent {}