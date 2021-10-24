part of 'menu_bloc.dart';

enum MenuStatus { initial, success, failure }

class MenuState extends Equatable {
  const MenuState({
    this.status = MenuStatus.initial,
    this.menu = const MenuShow(),
  });

  final MenuStatus status;
  final MenuShow menu;

  MenuState copyWith({
    MenuStatus? status,
    MenuShow? menu,
  }) {
    return MenuState(
      status: status ?? this.status,
      menu: menu ?? this.menu,
    );
  }

  @override
  String toString() {
    return '''MenuState { status: $status,  menu: $menu }''';
  }

  @override
  List<Object> get props => [status, menu];
}