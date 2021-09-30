part of 'menu_card_bloc.dart';

enum MenuCardStatus { initial, success, failure }

class MenuCardState extends Equatable {
  const MenuCardState({
    this.status = MenuCardStatus.initial,
    this.menu = const <MenuCard>[],
    this.hasReachedMax = false,
  });

  final MenuCardStatus status;
  final List<MenuCard> menu;
  final bool hasReachedMax;

  MenuCardState copyWith({
    MenuCardStatus? status,
    List<MenuCard>? menu,
    bool? hasReachedMax,
  }) {
    return MenuCardState(
      status: status ?? this.status,
      menu: menu ?? this.menu,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''MenuCardState { status: $status, hasReachedMax: $hasReachedMax, menu: ${menu.length} }''';
  }

  @override
  List<Object> get props => [status, menu, hasReachedMax];
}