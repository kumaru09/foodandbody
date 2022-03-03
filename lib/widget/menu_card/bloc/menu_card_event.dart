part of 'menu_card_bloc.dart';

abstract class MenuCardEvent extends Equatable {
  const MenuCardEvent();
  @override
  List<Object> get props => [];
}

class FetchedFavMenuCard extends MenuCardEvent {
  const FetchedFavMenuCard({this.isRefresh = false});
  final bool isRefresh;
}
class FetchedMyFavMenuCard extends MenuCardEvent {
  const FetchedMyFavMenuCard({this.isRefresh = false});
  final bool isRefresh;
}
class ReFetchedFavMenuCard extends MenuCardEvent {}
class ReFetchedMyFavMenuCard extends MenuCardEvent {}