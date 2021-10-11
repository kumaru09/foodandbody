import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/repositories/plan_repository.dart';
import 'package:foodandbody/screens/menu/bloc/menu_bloc.dart';
import 'package:foodandbody/widget/nutrient_detail.dart';
import 'package:http/http.dart' as http;

part 'menu_dialog.dart';

class MenuDetail extends StatefulWidget {
  const MenuDetail({Key? key}) : super(key: key);

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
    if (value - value.round() == 0.0)
      return value.round().toString();
    else
      return value.toString();
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
                  child: _AddToPlanButton(name: state.menu.name),
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
  const _AddToPlanButton({Key? key, required this.name}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        key: const Key('initialInfoForm_continue_raisedButton'),
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
                  child: ConfirmCalDialog());
            }),
      ),
    );
  }
}

class ConfirmCalDialog extends StatefulWidget {
  const ConfirmCalDialog({Key? key}) : super(key: key);

  @override
  _ConfirmCalDialogState createState() => _ConfirmCalDialogState();
}

class _ConfirmCalDialogState extends State<ConfirmCalDialog> {
  double _currentSliderValue = 1;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuBloc, MenuState>(builder: (context, state) {
      return AlertDialog(
        title: Row(
          children: <Widget>[
            Expanded(
              child: Text('ปริมาณที่จะกิน',
                  style: Theme.of(context).textTheme.subtitle1!.merge(TextStyle(
                      color: Theme.of(context).colorScheme.secondary))),
            ),
            Text('$_currentSliderValue จาน',
                style: Theme.of(context).textTheme.subtitle1!.merge(
                    TextStyle(color: Theme.of(context).colorScheme.secondary))),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        content: SingleChildScrollView(
          child: Slider(
            value: _currentSliderValue,
            min: 0,
            max: 1,
            activeColor: Theme.of(context).primaryColor,
            inactiveColor: Color(0xFFE0E0E0),
            divisions: 10,
            onChanged: (double value) {
              setState(() {
                _currentSliderValue = value;
              });
            },
          ),
        ),
        contentPadding: EdgeInsets.all(0),
        actionsPadding: EdgeInsets.only(top: 0),
        actionsOverflowButtonSpacing: 0,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              context
                  .read<MenuBloc>()
                  .addMenuToPlan(volumn: _currentSliderValue);
            },
            child: Text('ตกลง',
                style: Theme.of(context).textTheme.button!.merge(
                    TextStyle(color: Theme.of(context).colorScheme.secondary))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'cancle'),
            child: Text('ยกเลิก',
                style: Theme.of(context).textTheme.button!.merge(
                    TextStyle(color: Theme.of(context).colorScheme.secondary))),
          ),
        ],
      );
    });
  }
}
