import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/repositories/plan_repository.dart';
import 'package:foodandbody/screens/camera/camera.dart';
import 'package:foodandbody/screens/menu/menu_dialog.dart';
import 'package:foodandbody/screens/menu/bloc/menu_bloc.dart';
import 'package:foodandbody/widget/nutrient_detail.dart';
import 'package:http/http.dart' as http;

class MenuDetail extends StatefulWidget {
  const MenuDetail({Key? key, required this.isPlanMenu}) : super(key: key);

  final bool isPlanMenu;

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

  Widget displayButton(bool isPlanMenu, String name, double serve, String unit) {
    if (isPlanMenu) {
      return Row(
        children: [
          _EatNowButton(name: name, serve: serve, unit: unit),
          SizedBox(width: 16.0),
          _TakePhotoButton(),
        ],
      );
    } else {
      return _AddToPlanButton(name: name, serve: serve, unit: unit);
    }
  }

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
                                Text('${state.menu.calory} แคล',
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
                                    '${toRound(state.menu.serve)} ${state.menu.unit}'),
                            SizedBox(height: 7.0),
                            NutrientDetail(
                                label: 'โปรตีน',
                                value: '${toRound(state.menu.protein)} กรัม'),
                            SizedBox(height: 7.0),
                            NutrientDetail(
                                label: 'คาร์โบไฮเดรต',
                                value: '${toRound(state.menu.carb)} กรัม'),
                            SizedBox(height: 7.0),
                            NutrientDetail(
                                label: 'ไขมัน',
                                value: '${toRound(state.menu.fat)} กรัม'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: displayButton(widget.isPlanMenu, state.menu.name, state.menu.serve, state.menu.unit),
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

class _AddToPlanButton extends StatelessWidget {
  final String name;
  final double serve;
  final String unit;
  const _AddToPlanButton({Key? key, required this.name, required this.serve, required this.unit}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        key: const Key('menu_addToPlan_button'),
        child: Text('เพิ่มในแผนการกิน'),
        style: OutlinedButton.styleFrom(
          primary: Theme.of(context).primaryColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50))),
        ),
        onPressed: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) {
              return BlocProvider(
                  create: (_) => MenuBloc(
                      httpClient: http.Client(),
                      path: name,
                      planRepository: context.read<PlanRepository>()),
                  child: MenuDialog(name: name, serve: serve, unit: unit, isEatNow: false));
            }),
      ),
    );
  }
}

class _EatNowButton extends StatelessWidget {
  final String name;
  final double serve;
  final String unit;
  const _EatNowButton({Key? key, required this.name, required this.serve, required this.unit}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton(
        key: const Key('menu_eatNow_button'),
        child: Text('กินเลย'),
        style: OutlinedButton.styleFrom(
          primary: Theme.of(context).primaryColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50))),
        ),
        onPressed: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) {
              return BlocProvider(
                  create: (_) => MenuBloc(
                      httpClient: http.Client(),
                      path: name,
                      planRepository: context.read<PlanRepository>()),
                  child: MenuDialog(name: name, serve: serve, unit: unit, isEatNow: true));
            }),
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
        onPressed: () =>
          Navigator.push(context, MaterialPageRoute(builder: (context) => Camera())),
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
