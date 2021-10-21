part of 'menu_card_bloc.dart';

abstract class MenuCardEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class MenuCardFetched extends MenuCardEvent {}