import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:foodandbody/models/menu_card.dart';
import 'package:http/http.dart' as http;
import 'package:stream_transform/stream_transform.dart';

part 'menu_card_event.dart';
part 'menu_card_state.dart';

const _postLimit = 20;
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class MenuCardBloc extends Bloc<MenuCardEvent, MenuCardState> {
  MenuCardBloc({required this.httpClient}) : super(const MenuCardState()) {
    on<MenuCardFetched>(
      _onMenuCardFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final http.Client httpClient;

  Future<void> _onMenuCardFetched(
    MenuCardFetched event,
    Emitter<MenuCardState> emit,
  ) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == MenuCardStatus.initial) {
        final menu = await _fetchMenuCards();
        return emit(state.copyWith(
          status: MenuCardStatus.success,
          menu: menu,
          hasReachedMax: false,
        ));
      }
      final menu = await _fetchMenuCards(5);
      // final menu = await _fetchMenuCards(state.menu.length);
      menu.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(
              state.copyWith(
                status: MenuCardStatus.success,
                menu: List.of(state.menu)..addAll(menu),
                hasReachedMax: false,
              ),
            );
    } catch (_) {
      emit(state.copyWith(status: MenuCardStatus.failure));
    }
  }

  Future<List<MenuCard>> _fetchMenuCards([int startIndex = 0]) async {
    final response = await httpClient.get(
      Uri.https(
        'foodandbody-api.azurewebsites.net',
        '/api/menu',
        <String, String>{'_start': '$startIndex', '_limit': '$_postLimit'},
      ),
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as List;
      print('ResponseBody: ' + response.body); // Read Data in Array
      return body.map((dynamic json) {
        return MenuCard(
          name: json['name'] as String,
          calory: json['calories'] as int,
          imageUrl: json['imageUrl'] as String,
        );
      }).toList();
    }
    throw Exception('error fetching menu');
  }
}