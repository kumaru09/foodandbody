import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:foodandbody/models/distance_matrix.dart';
import 'package:foodandbody/models/menu_show.dart';
import 'package:foodandbody/models/near_restaurant.dart';
import 'package:foodandbody/repositories/favor_repository.dart';
import 'package:foodandbody/repositories/plan_repository.dart';
import 'package:google_place/google_place.dart' as google_place;
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
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
  MenuBloc(
      {required this.httpClient,
      required this.path,
      required this.planRepository,
      required this.favoriteRepository,
      Dio? dio,
      Location? location,
      GooglePlaceManager? googlePlaceManager})
      : _dio = dio ?? Dio(),
        _location = location ?? new Location(),
        _googlePlaceManager = googlePlaceManager ?? GooglePlaceManager(),
        super(MenuState()) {
    on<MenuFetched>(
      _onMenuFetched,
      transformer: throttleDroppable(throttleDuration),
    );
    on<MenuReFetched>(
      _onMenuReFetched,
      transformer: throttleDroppable(throttleDuration),
    );
    on<AddMenu>(_onAddMenu);
  }

  final http.Client httpClient;
  final String path;
  final PlanRepository planRepository;
  final FavoriteRepository favoriteRepository;
  final Dio _dio;
  final Location _location;
  final GooglePlaceManager _googlePlaceManager;

  Future<void> _onMenuFetched(
    MenuFetched event,
    Emitter<MenuState> emit,
  ) async {
    try {
      if (state.status != MenuStatus.initial)
        emit(state.copyWith(status: MenuStatus.initial));
      final menu = await _fetchMenus(path);
      final List<NearRestaurant> nearRestaurant = await _fetchRestaurant(path);
      return emit(state.copyWith(
        status: MenuStatus.success,
        menu: menu,
        nearRestaurant: nearRestaurant,
      ));
    } catch (e) {
      print(e);
      emit(state.copyWith(status: MenuStatus.failure));
    }
  }

  Future<void> _onMenuReFetched(
    MenuReFetched event,
    Emitter<MenuState> emit,
  ) async {
    try {
      if (state.status != MenuStatus.success) return;
      final menu = await _fetchMenus(path);
      final List<NearRestaurant> nearRestaurant = await _fetchRestaurant(path);
      print(nearRestaurant);
      return emit(state.copyWith(
          status: MenuStatus.success,
          menu: menu,
          nearRestaurant: nearRestaurant));
    } catch (e) {
      print(e);
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

  Future<List<NearRestaurant>> _fetchRestaurant(String name) async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return List.empty();
      }
    }

    _permissionGranted = await _location.hasPermission();

    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();

      if (_permissionGranted != PermissionStatus.granted) {
        return List.empty();
      }
    }

    final _locationData = await _getLoaction(_location);

    final result =
        await _googlePlaceManager.getNearBySearch(_locationData, name);

    if (result!.results!.isEmpty) return List.empty();

    final restaurantList = result.results!.map((e) async {
      final detail = await _googlePlaceManager.get(e.placeId!);

      return NearRestaurant(
          name: e.name,
          imageUrl: detail!.result!.photos != null
              ? "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=${detail.result?.photos?.first.photoReference}&key=AIzaSyAAw4dLXy4iLB73faed51VGnNumwkU7mFY"
              : null,
          distance: await _getDistance(
              e.geometry!.location!.lat!,
              e.geometry!.location!.lng!,
              _locationData.latitude!,
              _locationData.longitude!),
          rating: e.rating,
          open: detail.result?.openingHours?.periods?.first.open?.time,
          close: detail.result?.openingHours?.periods?.first.close?.time,
          id: e.placeId,
          lat: e.geometry!.location!.lat!,
          lng: e.geometry!.location!.lng!);
    }).toList();

    return Future.wait(restaurantList);
  }

  Future<LocationData> _getLoaction(Location location) async {
    try {
      final _locationData = await location.getLocation();
      return _locationData;
    } catch (e) {
      print('$e');
      throw Exception('error getting location');
    }
  }

  Future<String?> _getDistance(
      double desLat, double desLng, double oriLat, double oriLng) async {
    try {
      final res = await _dio.get(
          "https://maps.googleapis.com/maps/api/distancematrix/json?destinations=$desLat,$desLng&origins=$oriLat,$oriLng&key=AIzaSyAAw4dLXy4iLB73faed51VGnNumwkU7mFY");
      final distance = DistanceMatrix.fromJson(res.data);

      return distance.elements.first.distance.text;
    } catch (e) {
      print('$e');
      throw Exception('error getting distance');
    }
  }

  Future<void> _onAddMenu(
    AddMenu event,
    Emitter<MenuState> emit,
  ) async {
    try {
      emit(state.copyWith(addMenuStatus: AddMenuStatus.initial));
      await planRepository.addPlanMenu(
          event.name, event.oldVolume, event.volumn, event.isEatNow);
      if (event.isEatNow) {
        await favoriteRepository.addFavMenuById(event.name);
        await favoriteRepository.addFavMenuAll(event.name);
      }
      emit(state.copyWith(addMenuStatus: AddMenuStatus.success));
    } catch (e) {
      print('onAddMenu: $e');
      emit(state.copyWith(addMenuStatus: AddMenuStatus.failure));
    }
  }
}

class GooglePlaceManager {
  GooglePlaceManager();
  final google_place.GooglePlace _googlePlace =
      google_place.GooglePlace("AIzaSyAAw4dLXy4iLB73faed51VGnNumwkU7mFY");

  Future<google_place.NearBySearchResponse?> getNearBySearch(
      LocationData locationData, String name) {
    return _googlePlace.search.getNearBySearch(
        google_place.Location(
            lat: locationData.latitude, lng: locationData.longitude),
        2000,
        type: "restaurant",
        keyword: name);
  }

  Future<google_place.DetailsResponse?> get(String id) {
    return _googlePlace.details.get(id, fields: "photos,opening_hours/periods");
  }
}
