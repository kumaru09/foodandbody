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
  @override
  void initState() {
    super.initState();
    context.read<MenuBloc>().add(MenuFetched());
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

  List<NearRestaurant> items = [
    NearRestaurant(
      name: 'ร้านกุ้งยุดยา',
      imageUrl: 'https://bnn.blob.core.windows.net/food/shrimp-fried-rice.jpg',
      distance: 2.0,
      rating: 3.2,
      open: TimeOfDay(hour: 8, minute: 0),
      close: TimeOfDay(hour: 20, minute: 0),
    ),
    NearRestaurant(
      name: 'สมปองการกุ้ง',
      imageUrl: 'https://bnn.blob.core.windows.net/food/shrimp-fried-rice.jpg',
      distance: 4.5,
      rating: 4.5,
      open: TimeOfDay(hour: 12, minute: 0),
      close: TimeOfDay(hour: 22, minute: 0),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuBloc, MenuState>(
      builder: (context, state) {
        switch (state.status) {
          case MenuStatus.failure:
            return const Center(child: Text('failed to fetch menu'));
          case MenuStatus.success:
            return Column(
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
                            if(items.isNotEmpty) _NearRestaurant(items: items),
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
  const _NearRestaurant({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('สถานที่ใกล้คุณ',
            style: Theme.of(context).textTheme.subtitle1!.merge(
                TextStyle(color: Theme.of(context).colorScheme.secondary))),
        ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return _NearRestaurantItem(item: items[index]);
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
  const _NearRestaurantItem({Key? key, required this.item}) : super(key: key);

  String showTime(TimeOfDay time) {
    return '${time.hour}:${time.minute==0?'00':time.minute}';
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
              item.imageUrl,
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
                  rating: item.rating,
                  itemBuilder: (context, index) => Icon(
                    Icons.star,
                    color: Theme.of(context).primaryColor,
                  ),
                  itemCount: 5,
                  itemSize: 24.0,
                  direction: Axis.horizontal,
                  unratedColor: Theme.of(context).colorScheme.secondaryVariant.withAlpha(60),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.access_time, color: Theme.of(context).colorScheme.secondary),
                    Text(' ${showTime(item.open)} - ${showTime(item.close)}',
                    style: Theme.of(context).textTheme.caption!.merge(TextStyle(
                        color: Theme.of(context).colorScheme.secondary))),],
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
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => MainScreen(index: 1),
            ));
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
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => MainScreen(index: 1),
      ));
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
