part of 'menu_card_bloc.dart';

enum MenuCardStatus { initial, success, failure }

class MenuCardState extends Equatable {
  const MenuCardState({
    this.status = MenuCardStatus.initial,
    this.fav = const <MenuList>[],
    this.myFav = const <MenuList>[],
  });

  final MenuCardStatus status;
  final List<MenuList> fav;
  final List<MenuList> myFav;

  MenuCardState copyWith({
    MenuCardStatus? status,
    List<MenuList>? fav,
    List<MenuList>? myFav,
  }) {
    return MenuCardState(
      status: status ?? this.status,
      fav: fav ?? this.fav,
      myFav: myFav ?? this.myFav,
    );
  }

  @override
  String toString() {
    return '''MenuCardState { status: $status, fav: ${fav.length}, myFav: ${myFav.length} }''';
  }

  @override
  List<Object> get props => [status, fav, myFav];
}