import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:foodandbody/models/menu_show.dart';
import 'package:http/http.dart' as http;
import 'package:stream_transform/stream_transform.dart';

part 'menu_event.dart';
part 'menu_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc({required this.httpClient, required this.path})
      : super(const MenuState()) {
    on<MenuFetched>(
      _onMenuFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final http.Client httpClient;
  final String path;

  Future<void> _onMenuFetched(
    MenuFetched event,
    Emitter<MenuState> emit,
  ) async {
    try {
      if (state.status == MenuStatus.initial) {
        final menu = await _fetchMenus(path);
        return emit(state.copyWith(
          status: MenuStatus.success,
          menu: menu,
        ));
      }
    } catch (_) {
      emit(state.copyWith(status: MenuStatus.failure));
    }
  }

  Future<MenuShow> _fetchMenus(String path) async {
    final response = await httpClient.get(
      Uri.https('foodandbody-api.azurewebsites.net', '/api/menu/$path'),
    );
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final menu = MenuShow.fromJson(body);
      return menu;
    }
    throw Exception('error fetching menu');
  }
}
