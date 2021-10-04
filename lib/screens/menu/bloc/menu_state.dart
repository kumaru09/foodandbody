part of 'menu_bloc.dart';

enum MenuStatus { initial, success, failure }

class MenuState extends Equatable {
  const MenuState({
    this.status = MenuStatus.initial,
    this.menu = const MenuDetail(),
  });

  final MenuStatus status;
  final MenuDetail menu;

  MenuState copyWith({
    MenuStatus? status,
    MenuDetail? menu,
  }) {
    return MenuState(
      status: status ?? this.status,
      menu: menu ?? this.menu,
    );
  }

  @override
  String toString() {
    return '''MenuState { status: $status,  menu: ${menu.name} }''';
  }

  @override
  List<Object> get props => [status, menu];
}