part of 'menu_card_bloc.dart';

enum MenuCardStatus { initial, success, failure }

class MenuCardState extends Equatable {
  const MenuCardState({
    this.status = MenuCardStatus.initial,
    this.menu = const <MenuList>[],
  });

  final MenuCardStatus status;
  final List<MenuList> menu;

  MenuCardState copyWith({
    MenuCardStatus? status,
    List<MenuList>? menu,
  }) {
    return MenuCardState(
      status: status ?? this.status,
      menu: menu ?? this.menu,
    );
  }

  @override
  String toString() {
    return '''MenuCardState { status: $status, menu: ${menu.length} }''';
  }

  @override
  List<Object> get props => [status, menu];
}