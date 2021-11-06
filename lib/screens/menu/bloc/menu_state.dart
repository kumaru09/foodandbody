part of 'menu_bloc.dart';

enum MenuStatus { initial, success, failure }

class MenuState extends Equatable {
  MenuState(
      {this.status = MenuStatus.initial,
      this.menu = const MenuShow(),
      List<NearRestaurant>? nearRestaurant})
      : this.nearRestaurant = nearRestaurant ?? [];

  final MenuStatus status;
  final MenuShow menu;
  final List<NearRestaurant> nearRestaurant;

  MenuState copyWith(
      {MenuStatus? status,
      MenuShow? menu,
      List<NearRestaurant>? nearRestaurant}) {
    return MenuState(
        status: status ?? this.status,
        menu: menu ?? this.menu,
        nearRestaurant: nearRestaurant ?? this.nearRestaurant);
  }

  @override
  String toString() {
    return '''MenuState { status: $status,  menu: $menu, nearRestaurant: $nearRestaurant }''';
  }

  @override
  List<Object> get props => [status, menu, nearRestaurant];
}
