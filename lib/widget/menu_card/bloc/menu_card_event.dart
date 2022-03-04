part of 'menu_card_bloc.dart';

abstract class MenuCardEvent extends Equatable {
  const MenuCardEvent();
  @override
  List<Object> get props => [];
}

class FetchedFavMenuCard extends MenuCardEvent {}

class FetchedMyFavMenuCard extends MenuCardEvent {}

class ReFetchedFavMenuCard extends MenuCardEvent {
  const ReFetchedFavMenuCard({this.isRefresh = false});
  final bool isRefresh;
}

class ReFetchedMyFavMenuCard extends MenuCardEvent {
  const ReFetchedMyFavMenuCard({this.isRefresh = false});
  final bool isRefresh;
}
