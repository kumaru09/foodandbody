import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:foodandbody/models/menu.dart';
import 'package:foodandbody/models/near_restaurant.dart';
import 'package:foodandbody/screens/main_screen/main_screen.dart';
import 'package:foodandbody/screens/menu/menu_dialog.dart';
import 'package:foodandbody/screens/menu/bloc/menu_bloc.dart';
import 'package:foodandbody/widget/nutrient_detail.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuDetail extends StatefulWidget {
  MenuDetail({Key? key, required this.isPlanMenu, Menu? item})
      : this.menu = item ??
            Menu(
                name: '',
                calories: 0,
                carb: 0,
                fat: 0,
                protein: 0,
                serve: 0,
                volumn: 0),
        super(key: key);

  final bool isPlanMenu;
  final Menu menu;

  @override
  _MenuDetailState createState() => _MenuDetailState();
}

class _MenuDetailState extends State<MenuDetail> {
  late MenuBloc _menuBloc;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _menuBloc = context.read<MenuBloc>();
  }

  Future _onRefresh() async {
    await Future.delayed(Duration(seconds: 2));
    _menuBloc.add(MenuReFetched());
    setState(() {});
  }

  String _toRound(double value) {
    if (value - value.toInt() == 0.0)
      return value.toInt().toString();
    else
      return value.toString();
  }

  Widget _displayButton(String name, double serve, String unit) {
    return Row(
      children: [
        if (!widget.isPlanMenu)
          _AddToPlanButton(name: name, serve: serve, unit: unit),
        if (!widget.isPlanMenu) SizedBox(width: 16.0),
        _EatNowButton(
            name: name,
            volumn: serve,
            unit: unit,
            isPlanMenu: widget.isPlanMenu),
      ],
    );
  }

  void _failAddMenu(BuildContext context) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          _timer = Timer(Duration(seconds: 2), () {
            Navigator.of(context).pop();
          });
          return AlertDialog(
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.report,
                    color: Theme.of(context).colorScheme.secondary, size: 80),
                Text('เพิ่มเมนูไม่สำเร็จ',
                    style: Theme.of(context).textTheme.subtitle1!.merge(
                        TextStyle(
                            color: Theme.of(context).colorScheme.secondary))),
                Text('กรุณาลองอีกครั้ง',
                    style: Theme.of(context).textTheme.subtitle1!.merge(
                        TextStyle(
                            color: Theme.of(context).colorScheme.secondary))),
              ],
            ),
          );
        }).then((val) {
      if (_timer.isActive) {
        _timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MenuBloc, MenuState>(
      listenWhen: (previous, current) =>
          previous.addMenuStatus != current.addMenuStatus,
      listener: (context, state) {
        switch (state.addMenuStatus) {
          case AddMenuStatus.success:
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => MainScreen(index: 1)),
                (Route<dynamic> route) => route.isFirst);
            return;
          case AddMenuStatus.failure:
            return _failAddMenu(context);
          default:
        }
      },
      child: BlocBuilder<MenuBloc, MenuState>(
        builder: (context, state) {
          switch (state.status) {
            case MenuStatus.failure:
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(image: AssetImage('assets/error.png')),
                    SizedBox(height: 10),
                    Text('ไม่สามารถโหลดข้อมูลได้ในขณะนี้',
                        style: Theme.of(context).textTheme.bodyText2!.merge(
                            TextStyle(
                                color:
                                    Theme.of(context).colorScheme.secondary))),
                    OutlinedButton(
                      child: Text('ลองอีกครั้ง'),
                      style: OutlinedButton.styleFrom(
                        primary: Theme.of(context).colorScheme.secondary,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                      ),
                      onPressed: () => _menuBloc.add(MenuFetched()),
                    ),
                  ],
                ),
              );
            case MenuStatus.success:
              return RefreshIndicator(
                onRefresh: _onRefresh,
                child: Column(
                  key: Key('menu_column'),
                  children: <Widget>[
                    Expanded(
                      child: ListView(
                        children: <Widget>[
                          Image.network(
                            state.menu.imageUrl,
                            alignment: Alignment.center,
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text('แคลอรีรวม',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5!
                                              .merge(TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary))),
                                    ),
                                    Text(
                                        widget.isPlanMenu
                                            ? '${widget.menu.calories.round()} แคล'
                                            : '${state.menu.calory.round()} แคล',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5!
                                            .merge(TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary))),
                                  ],
                                ),
                                SizedBox(height: 16.0),
                                NutrientDetail(
                                  label: 'หน่วยบริโภค',
                                  value:
                                      '${widget.isPlanMenu ? _toRound(widget.menu.volumn) : _toRound(state.menu.serve)} ${state.menu.unit}',
                                ),
                                SizedBox(height: 7.0),
                                NutrientDetail(
                                  label: 'โปรตีน',
                                  value:
                                      '${widget.isPlanMenu ? _toRound(widget.menu.protein) : _toRound(state.menu.protein)} กรัม',
                                ),
                                SizedBox(height: 7.0),
                                NutrientDetail(
                                  label: 'คาร์โบไฮเดรต',
                                  value:
                                      '${widget.isPlanMenu ? _toRound(widget.menu.carb) : _toRound(state.menu.carb)} กรัม',
                                ),
                                SizedBox(height: 7.0),
                                NutrientDetail(
                                  label: 'ไขมัน',
                                  value:
                                      '${widget.isPlanMenu ? _toRound(widget.menu.fat) : _toRound(state.menu.fat)} กรัม',
                                ),
                                _NearRestaurant(
                                  items: state.nearRestaurant,
                                  defaultUrl: state.menu.imageUrl,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: _displayButton(
                          state.menu.name, state.menu.serve, state.menu.unit),
                    ),
                  ],
                ),
              );
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class _NearRestaurant extends StatelessWidget {
  final List<NearRestaurant> items;
  final String defaultUrl;
  const _NearRestaurant(
      {Key? key, required this.items, required this.defaultUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text('ร้านใกล้คุณ',
            style: Theme.of(context).textTheme.subtitle1!.merge(
                TextStyle(color: Theme.of(context).colorScheme.secondary))),
        items.isEmpty
            ? Center(
                heightFactor: 2,
                child: Text('ไม่มีร้านใกล้คุณในขณะนี้',
                    style: Theme.of(context).textTheme.bodyText2!.merge(
                        TextStyle(
                            color: Theme.of(context).colorScheme.secondary))),
              )
            : ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return _NearRestaurantItem(
                    item: items[index],
                    defaultUrl: defaultUrl,
                  );
                },
                itemCount: items.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(vertical: 10),
              ),
      ],
    );
  }
}

class _NearRestaurantItem extends StatelessWidget {
  final NearRestaurant item;
  final String defaultUrl;
  const _NearRestaurantItem(
      {Key? key, required this.item, required this.defaultUrl})
      : super(key: key);

  String _showTime(String? time) {
    return time != null
        ? '${time.substring(0, 2)}.${time.substring(2, 4)}'
        : '';
  }

  String _distance(String? value) {
    String distance = value ?? '- km';
    return distance.split(' ')[0];
  }

  void _launchMapsUrl(
      {required double lat, required double lng, required String id}) async {
    final url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$lat,$lng&query_place_id=$id');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 7),
      child: Material(
        child: InkWell(
          onTap: () {
            _launchMapsUrl(lat: item.lat!, lng: item.lng!, id: item.id!);
          },
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                child: Image.network(
                  item.imageUrl == null ? defaultUrl : item.imageUrl!,
                  key: const Key('nearRestaurant_image'),
                  width: 100,
                  height: 100,
                  alignment: Alignment.center,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${item.name}',
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText2!.merge(
                            TextStyle(
                                color:
                                    Theme.of(context).colorScheme.secondary))),
                    Text('${_distance(item.distance)} กิโลเมตร',
                        style: Theme.of(context).textTheme.caption!.merge(
                            TextStyle(
                                color:
                                    Theme.of(context).colorScheme.secondary))),
                    RatingBarIndicator(
                      rating: item.rating ?? 0.0,
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Theme.of(context).primaryColor,
                      ),
                      itemCount: 5,
                      itemSize: 24.0,
                      direction: Axis.horizontal,
                      unratedColor: Theme.of(context)
                          .colorScheme
                          .secondaryVariant
                          .withAlpha(60),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.access_time,
                            color: Theme.of(context).colorScheme.secondary),
                        Text(
                          " ${_showTime(item.open)} - ${_showTime(item.close)}",
                          style: Theme.of(context).textTheme.caption!.merge(
                                TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddToPlanButton extends StatelessWidget {
  final String name;
  final double serve;
  final String unit;
  const _AddToPlanButton(
      {Key? key, required this.name, required this.serve, required this.unit})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton(
        key: const Key('menu_addToPlan_button'),
        child: Text('เพิ่มในแผนการกิน'),
        style: OutlinedButton.styleFrom(
          primary: Theme.of(context).primaryColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50))),
        ),
        onPressed: () async {
          final value = await showDialog<String>(
            context: context,
            builder: (BuildContext context) =>
                MenuDialog(serve: serve, unit: unit, isEatNow: false),
          );
          if (value != 'cancel' && value != null) {
            context.read<MenuBloc>().add(
                  AddMenu(
                    name: name,
                    isEatNow: false,
                    volumn: double.parse(value.toString()),
                  ),
                );
          }
        },
      ),
    );
  }
}

class _EatNowButton extends StatelessWidget {
  final String name;
  final double volumn;
  final String unit;
  final bool isPlanMenu;
  const _EatNowButton(
      {Key? key,
      required this.name,
      required this.volumn,
      required this.unit,
      required this.isPlanMenu})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        key: const Key('menu_eatNow_elevatedButton'),
        child: Text('กินเลย'),
        style: ElevatedButton.styleFrom(
          primary: Theme.of(context).primaryColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50))),
        ),
        onPressed: () async {
          final value = await showDialog<String>(
            context: context,
            builder: (BuildContext context) =>
                MenuDialog(serve: volumn, unit: unit, isEatNow: true),
          );
          if (value != 'cancel' && value != null) {
            if (isPlanMenu) {
              context.read<MenuBloc>().add(AddMenu(
                  name: name,
                  isEatNow: true,
                  oldVolume: volumn,
                  volumn: double.parse(value.toString())));
            } else {
              context.read<MenuBloc>().add(AddMenu(
                  name: name,
                  isEatNow: true,
                  volumn: double.parse(value.toString())));
            }
          }
        },
      ),
    );
  }
}
