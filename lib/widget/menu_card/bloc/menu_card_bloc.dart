import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:foodandbody/models/menu_list.dart';
import 'package:foodandbody/repositories/menu_card_repository.dart';
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
  MenuCardBloc({required this.menuCardRepository})
      : super(const MenuCardState()) {
    on<FetchedFavMenuCard>(
      _onFetchedFavMenuCard,
      transformer: throttleDroppable(throttleDuration),
    );
    on<FetchedMyFavMenuCard>(
      _onFetchedMyFavMenuCard,
      transformer: throttleDroppable(throttleDuration),
    );
    on<ReFetchedFavMenuCard>(
      _onReFetchedFavMenuCard,
      transformer: throttleDroppable(throttleDuration),
    );
    on<ReFetchedMyFavMenuCard>(
      _onReFetchedMyFavMenuCard,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final MenuCardRepository menuCardRepository;

  Future<void> _onFetchedFavMenuCard(
    FetchedFavMenuCard event,
    Emitter<MenuCardState> emit,
  ) async {
    try {
      if (!event.isRefresh && state.status != MenuCardStatus.initial)
        emit(state.copyWith(status: MenuCardStatus.initial));
      List<MenuList> fav = await menuCardRepository.getMenuList(isMyFav: false, checkCache: true);
      if (state.status == MenuCardStatus.initial) {
        return emit(state.copyWith(
          status: MenuCardStatus.success,
          fav: fav,
        ));
      }
    } catch (e) {
      print('e: $e');
      emit(state.copyWith(status: MenuCardStatus.failure));
    }
  }

  Future<void> _onFetchedMyFavMenuCard(
    FetchedMyFavMenuCard event,
    Emitter<MenuCardState> emit,
  ) async {
    try {
      if (!event.isRefresh && state.status != MenuCardStatus.initial)
        emit(state.copyWith(status: MenuCardStatus.initial));
      List<MenuList> myFav = await menuCardRepository.getMenuList(isMyFav: true, checkCache: true);
      if (state.status == MenuCardStatus.initial) {
        return emit(state.copyWith(
          status: MenuCardStatus.success,
          myFav: myFav,
        ));
      }
    } catch (e) {
      print('e: $e');
      emit(state.copyWith(status: MenuCardStatus.failure));
    }
  }

  Future<void> _onReFetchedFavMenuCard(
    ReFetchedFavMenuCard event,
    Emitter<MenuCardState> emit,
  ) async {
    try {
      if (state.status != MenuCardStatus.initial)
        emit(state.copyWith(status: MenuCardStatus.initial));
      List<MenuList> fav = await menuCardRepository.getMenuList(isMyFav: false, checkCache: false);
      if (state.status == MenuCardStatus.initial) {
        return emit(state.copyWith(
          status: MenuCardStatus.success,
          fav: fav,
        ));
      }
    } catch (e) {
      print('e: $e');
      emit(state.copyWith(status: MenuCardStatus.failure));
    }
  }

  Future<void> _onReFetchedMyFavMenuCard(
    ReFetchedMyFavMenuCard event,
    Emitter<MenuCardState> emit,
  ) async {
    try {
      if (state.status != MenuCardStatus.initial)
        emit(state.copyWith(status: MenuCardStatus.initial));
      List<MenuList> myFav = await menuCardRepository.getMenuList(isMyFav: true, checkCache: false);
      if (state.status == MenuCardStatus.initial) {
        return emit(state.copyWith(
          status: MenuCardStatus.success,
          myFav: myFav,
        ));
      }
    } catch (e) {
      print('e: $e');
      emit(state.copyWith(status: MenuCardStatus.failure));
    }
  }
}
