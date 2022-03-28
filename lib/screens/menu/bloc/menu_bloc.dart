import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

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
      required this.favoriteRepository})
      : super(MenuState()) {
    on<MenuFetched>(
      _onMenuFetched,
      transformer: throttleDroppable(throttleDuration),
    );
    on<MenuReFetched>(
      _onMenuReFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final http.Client httpClient;
  final String path;
  final PlanRepository planRepository;
  final FavoriteRepository favoriteRepository;
  final googlePlace =
      google_place.GooglePlace("AIzaSyAAw4dLXy4iLB73faed51VGnNumwkU7mFY");
  final Dio dio = Dio();
  // Location location = new Location();


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
          nearRestaurant: nearRestaurant));
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
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    print('--------------------------- start ---------------------------');


    _serviceEnabled = await location.serviceEnabled();
    print('1 location.serviceEnabled(): $_serviceEnabled');
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
    print('2 location.requestService(): $_serviceEnabled');
      if (!_serviceEnabled) {
        return List.empty();
      }
    }

    _permissionGranted = await location.hasPermission();
    print('3 location.hasPermission(): $_permissionGranted');
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
    print('4 location.requestPermission(): $_permissionGranted');
      if (_permissionGranted != PermissionStatus.granted) {
        return List.empty();
      }
    }

    final _locationData = await _getLoaction(location);
    final result = await googlePlace.search.getNearBySearch(
        google_place.Location(
            lat: _locationData.latitude, lng: _locationData.longitude),
        2000,
        type: "restaurant",
        keyword: name);
    // print("${_locationData.latitude}, ${_locationData.longitude}");
    print('6 _getLoaction(location): $_locationData');
    print('7 googlePlace.search.getNearBySearch: $result');
    // print('  googlePlace.search.getNearBySearch: ${result!.results}');


    if (result!.results!.isEmpty) return List.empty();

    final restaurantList = result.results!.map((e) async {
      final detail = await googlePlace.details
          .get("${e.placeId}", fields: "photos,opening_hours/periods");
    print('10 restaurantList: $detail');

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
          close: detail.result?.openingHours?.periods?.first.close?.time);
    }).toList();

    print('11 restaurantList: $restaurantList');


    return Future.wait(restaurantList);
  }

  Future<LocationData> _getLoaction(Location location) async {
    try {
      final _locationData = await location.getLocation();
    print('5 location.getLocation(): $_locationData');
      return _locationData;
    } catch (e) {
      print('$e');
      throw Exception('error getting location');
    }
  }

  Future<String?> _getDistance(
      double desLat, double desLng, double oriLat, double oriLng) async {
    try {
      final res = await dio.get(
          "https://maps.googleapis.com/maps/api/distancematrix/json?destinations=$desLat,$desLng&origins=$oriLat,$oriLng&key=AIzaSyAAw4dLXy4iLB73faed51VGnNumwkU7mFY");
      // print(res.data);
      final distance = DistanceMatrix.fromJson(res.data);
    print('8 dio.get(): $res');
    print('9 DistanceMatrix.fromJson(res.data): $distance');

      return distance.elements.first.distance.text;
    } catch (e) {
      print('$e');
      throw Exception('error getting distance');
    }
  }

  Future<void> addMenu(
      {required String name,
      required bool isEatNow,
      required double volumn}) async {
    try {
      await planRepository.addPlanMenu(name, volumn, isEatNow);
      if (isEatNow) {
        await favoriteRepository.addFavMenuById(name);
        await favoriteRepository.addFavMenuAll(name);
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
