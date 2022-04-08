part of 'menu_bloc.dart';

enum MenuStatus { initial, success, failure }
enum AddMenuStatus { initial, success, failure }

class MenuState extends Equatable {
  MenuState({
    this.status = MenuStatus.initial,
    this.menu = const MenuShow(),
    List<NearRestaurant>? nearRestaurant,
    this.addMenuStatus = AddMenuStatus.initial,
  }) : this.nearRestaurant = nearRestaurant ?? [];

  final MenuStatus status;
  final MenuShow menu;
  final List<NearRestaurant> nearRestaurant;
  final AddMenuStatus addMenuStatus;

  MenuState copyWith({
    MenuStatus? status,
    MenuShow? menu,
    List<NearRestaurant>? nearRestaurant,
    AddMenuStatus? addMenuStatus,
  }) {
    return MenuState(
      status: status ?? this.status,
      menu: menu ?? this.menu,
      nearRestaurant: nearRestaurant ?? this.nearRestaurant,
      addMenuStatus: addMenuStatus ?? this.addMenuStatus,
    );
  }

  @override
  String toString() {
    return '''MenuState { status: $status, menu: $menu, nearRestaurant: $nearRestaurant, addMenuStatus: $addMenuStatus }''';
  }

  @override
  List<Object> get props => [status, menu, nearRestaurant, addMenuStatus];
}
