import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:foodandbody/models/menu_list.dart';
import 'package:foodandbody/repositories/menu_card_repository.dart';
import 'package:http/http.dart' as http;
import 'package:stream_transform/stream_transform.dart';

part 'menu_card_event.dart';
part 'menu_card_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class MenuCardBloc extends Bloc<MenuCardEvent, MenuCardState> {
  MenuCardBloc({required this.isMyFav, required this.menuCardRepository})
      : super(const MenuCardState()) {
    on<MenuCardFetched>(
      _onMenuCardFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final bool isMyFav;
  final MenuCardRepository menuCardRepository;

  Future<void> _onMenuCardFetched(
    MenuCardFetched event,
    Emitter<MenuCardState> emit,
  ) async {
    try {
      List<MenuList> menu = [];
      List<String> menuList = isMyFav
          ? await menuCardRepository.getNameMenuListById()
          : await menuCardRepository.getNameMenuListAll();
      for (var item in menuList) {
        MenuList temp = await _fetchMenuCards(item);
        menu.add(temp);
      }
      if (state.status == MenuCardStatus.initial) {
        return emit(state.copyWith(
          status: MenuCardStatus.success,
          menu: menu,
        ));
      }
    } catch (e) {
      print('e: $e');
      emit(state.copyWith(status: MenuCardStatus.failure));
    }
  }

  Future<MenuList> _fetchMenuCards(String path) async {
    final response = await http.get(
        Uri.parse("https://foodandbody-api.azurewebsites.net/api/Menu/$path"));
    if (response.statusCode == 200)
      return MenuList.fromJson(json.decode(response.body));
    throw Exception('error fetching menu');
  }
}
