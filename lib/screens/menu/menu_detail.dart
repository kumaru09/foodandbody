import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:foodandbody/models/menu.dart';
import 'package:foodandbody/models/near_restaurant.dart';
import 'package:foodandbody/screens/camera/camera.dart';
import 'package:foodandbody/screens/main_screen/main_screen.dart';
import 'package:foodandbody/screens/menu/menu_dialog.dart';
import 'package:foodandbody/screens/menu/bloc/menu_bloc.dart';
import 'package:foodandbody/widget/nutrient_detail.dart';

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

  @override
  void initState() {
    super.initState();
    _menuBloc = context.read<MenuBloc>();
    _menuBloc.add(MenuFetched());
  }

  Future _onRefresh() async {
    await Future.delayed(Duration(seconds: 2));
    _menuBloc.add(MenuReFetched());
    setState(() {});
  }

  String toRound(double value) {
    if (value - value.toInt() == 0.0)
      return value.toInt().toString();
    else
      return value.toString();
  }

  Widget displayButton(String name, double serve, String unit) {
    if (widget.isPlanMenu) {
      return Row(
        children: [
          _EatNowButton(
              name: name,
              volumn: widget.menu.volumn,
              unit: unit,
              isPlanMenu: widget.isPlanMenu),
          SizedBox(width: 16.0),
          _TakePhotoButton(),
        ],
      );
    } else {
      return Row(
        children: [
          _AddToPlanButton(name: name, serve: serve, unit: unit),
          SizedBox(width: 16.0),
          _EatNowButton(
              name: name,
              volumn: serve,
              unit: unit,
              isPlanMenu: widget.isPlanMenu),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuBloc, MenuState>(
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
                              color: Theme.of(context).colorScheme.secondary))),
                  OutlinedButton(
                    child: Text('ลองอีกครั้ง'),
                    style: OutlinedButton.styleFrom(
                      primary: Theme.of(context).colorScheme.secondary,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50))),
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
                                    '${widget.isPlanMenu ? toRound(widget.menu.volumn) : toRound(state.menu.serve)} ${state.menu.unit}',
                              ),
                              SizedBox(height: 7.0),
                              NutrientDetail(
                                label: 'โปรตีน',
                                value:
                                    '${widget.isPlanMenu ? toRound(widget.menu.protein) : toRound(state.menu.protein)} กรัม',
                              ),
                              SizedBox(height: 7.0),
                              NutrientDetail(
                                label: 'คาร์โบไฮเดรต',
                                value:
                                    '${widget.isPlanMenu ? toRound(widget.menu.carb) : toRound(state.menu.carb)} กรัม',
                              ),
                              SizedBox(height: 7.0),
                              NutrientDetail(
                                label: 'ไขมัน',
                                value:
                                    '${widget.isPlanMenu ? toRound(widget.menu.fat) : toRound(state.menu.fat)} กรัม',
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
                    child: displayButton(
                        state.menu.name, state.menu.serve, state.menu.unit),
                  ),
                ],
              ),
            );
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
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

  String showTime(TimeOfDay time) {
    return '${time.hour}:${time.minute == 0 ? '00' : time.minute}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 7),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            child: Image.network(
              item.imageUrl == null ? defaultUrl : item.imageUrl!,
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
                    style: Theme.of(context).textTheme.bodyText2!.merge(
                        TextStyle(
                            color: Theme.of(context).colorScheme.secondary))),
                Text('${item.distance} กิโลเมตร',
                    style: Theme.of(context).textTheme.caption!.merge(TextStyle(
                        color: Theme.of(context).colorScheme.secondary))),
                RatingBarIndicator(
                  rating: item.rating!,
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
                    item.open != null && item.close != null
                        ? Text(
                            ' ${item.open!.substring(0, 2)}.${item.open!.substring(2, 4)} - ${item.close!.substring(0, 2)}.${item.close!.substring(2, 4)}',
                            style: Theme.of(context).textTheme.caption!.merge(
                                TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary)))
                        : Text(" 00.00 - 00.00",
                            style: Theme.of(context).textTheme.caption!.merge(
                                TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary))),
                  ],
                ),
              ],
            ),
          ),
        ],
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
            await context.read<MenuBloc>().addMenu(
                name: name,
                isEatNow: false,
                volumn: double.parse(value.toString()));

            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => MainScreen(index: 1)),
                (Route<dynamic> route) => route.isFirst);
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

  _eatNowOnPressed(BuildContext context) async {
    final value = await showDialog<String>(
      context: context,
      builder: (BuildContext context) =>
          MenuDialog(serve: volumn, unit: unit, isEatNow: true),
    );
    if (value != 'cancel' && value != null) {
      await context.read<MenuBloc>().addMenu(
          name: name, isEatNow: true, volumn: double.parse(value.toString()));

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MainScreen(index: 1)),
        (Route<dynamic> route) => route.isFirst,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: isPlanMenu
          ? OutlinedButton(
              key: const Key('menu_eatNow_outlinedButton'),
              child: Text('กินเลย'),
              style: OutlinedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50))),
              ),
              onPressed: () => _eatNowOnPressed(context),
            )
          : ElevatedButton(
              key: const Key('menu_eatNow_elevatedButton'),
              child: Text('กินเลย'),
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50))),
              ),
              onPressed: () => _eatNowOnPressed(context),
            ),
    );
  }
}

class _TakePhotoButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        key: const Key('menu_takePhoto_button'),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => Camera())),
        child: Text('ถ่ายรูป'),
        style: ElevatedButton.styleFrom(
          primary: Theme.of(context).primaryColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50))),
        ),
      ),
    );
  }
}
