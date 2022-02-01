part of 'menu_card_bloc.dart';

abstract class MenuCardEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchedFavMenuCard extends MenuCardEvent {}
class FetchedMyFavMenuCard extends MenuCardEvent {}
class ReFetchedFavMenuCard extends MenuCardEvent {}
class ReFetchedMyFavMenuCard extends MenuCardEvent {}