import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/app/bloc/app_bloc.dart';
import 'package:foodandbody/repositories/plan_repository.dart';
import 'package:foodandbody/screens/home/bloc/home_bloc.dart';
import 'package:foodandbody/screens/home/circular_cal_indicator.dart';
import 'package:foodandbody/screens/search/search_page.dart';
import 'package:foodandbody/screens/plan/bloc/plan_bloc.dart';
import 'package:foodandbody/screens/setting/setting.dart';
import 'package:foodandbody/screens/home/linear_nutrient_indicator.dart';
import 'package:foodandbody/widget/menu_card/menu_card.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text("หน้าหลัก",
            style: Theme.of(context)
                .textTheme
                .headline5!
                .merge(TextStyle(color: Theme.of(context).primaryColor))),
        actions: [
          IconButton(
              key: const Key('setting_button'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Setting()));
              },
              icon: Icon(Icons.settings, color: Theme.of(context).primaryColor))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 16, top: 16),
              width: MediaQuery.of(context).size.width,
              child: Text(
                "แคลอรีวันนี้",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .merge(TextStyle(color: Theme.of(context).primaryColor)),
              ),
            ),
            Container(
                padding: EdgeInsets.only(left: 16, top: 8, right: 15),
                width: MediaQuery.of(context).size.width,
                constraints: BoxConstraints(minHeight: 100),
                child: BlocBuilder<PlanBloc, PlanState>(
                  builder: (context, state) {
                    return Card(
                        color: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        elevation: 2,
                        child: state is PlanLoaded &&
                                context.read<AppBloc>().state.user.info != null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(top: 18),
                                    child: CircularCalIndicator(state.plan,
                                        context.read<AppBloc>().state.user),
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.only(top: 18, bottom: 18),
                                    child: LinearNutrientIndicator(state.plan,
                                        context.read<AppBloc>().state.user),
                                  )
                                ],
                              )
                            : Center(child: CircularProgressIndicator()));
                  },
                )),
            Container(
              padding: EdgeInsets.only(left: 16, top: 16, right: 8),
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "เมนูแนะนำ",
                    style: Theme.of(context).textTheme.bodyText1!.merge(
                        TextStyle(color: Theme.of(context).primaryColor)),
                  ),
                  ElevatedButton.icon(
                    key: const Key('menu_all_button'),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchPage()));
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: Theme.of(context).scaffoldBackgroundColor),
                    icon:
                        Icon(Icons.add, color: Theme.of(context).primaryColor),
                    label: Text("ดูทั้งหมด",
                        style: Theme.of(context).textTheme.button!.merge(
                            TextStyle(color: Theme.of(context).primaryColor))),
                  )
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              constraints: BoxConstraints(minHeight: 100),
              child: MenuCard(path: '/api/menu'),
            ),
            Container(
              padding: EdgeInsets.only(left: 16, top: 16),
              width: MediaQuery.of(context).size.width,
              child: Text(
                "น้ำวันนี้",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .merge(TextStyle(color: Theme.of(context).primaryColor)),
              ),
            ),
            Container(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 100),
                width: MediaQuery.of(context).size.width,
                constraints: BoxConstraints(minHeight: 100),
                child: BlocProvider<HomeBloc>(
                    create: (context) => HomeBloc(
                        planRepository: context.read<PlanRepository>()),
                    child: _DailyWater()))
          ],
        ),
      ),
    );
  }
}

class _DailyWater extends StatefulWidget {
  const _DailyWater({Key? key}) : super(key: key);

  @override
  __DailyWaterState createState() => __DailyWaterState();
}

class __DailyWaterState extends State<_DailyWater> {
  @override
  Widget build(BuildContext context) {
    final HomeBloc homeBloc = BlocProvider.of<HomeBloc>(context)
      ..add(LoadWater());
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      return Card(
        key: const Key('daily_water_card'),
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("วันนี้คุณดื่มน้ำไปแล้ว",
                style: Theme.of(context).textTheme.bodyText2!.merge(
                    TextStyle(color: Theme.of(context).colorScheme.secondary))),
            Container(
              padding: EdgeInsets.only(top: 18, bottom: 18),
              child: Row(
                children: [
                  Container(
                      width: 35,
                      height: 40,
                      child: ElevatedButton(
                        key: const Key('remove_water_button'),
                        onPressed: () {
                          homeBloc.add(DecreaseWaterEvent());
                          homeBloc.add(WaterChanged(
                              water: state.water == 0 ? 0 : state.water - 1));
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).cardColor,
                          elevation: 0,
                          padding: EdgeInsets.all(0),
                          side: BorderSide(width: 1, color: Color(0xFFC4C4C4)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10))),
                        ),
                        child: Icon(Icons.remove,
                            color: Theme.of(context).colorScheme.secondary),
                      )),
                  Container(
                    constraints: BoxConstraints(minWidth: 50),
                    height: 40,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Color(0xFFC4C4C4))),
                    child: Text(
                      "${state.water}",
                      key: const Key('daily_water_display'),
                      style: Theme.of(context).textTheme.headline5!.merge(
                          TextStyle(
                              color: Theme.of(context).colorScheme.secondary)),
                    ),
                  ),
                  Container(
                      width: 35,
                      height: 40,
                      child: ElevatedButton(
                        key: const Key('add_water_button'),
                        onPressed: () {
                          homeBloc.add(IncreaseWaterEvent());
                          homeBloc.add(WaterChanged(water: state.water + 1));
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).cardColor,
                          elevation: 0,
                          padding: EdgeInsets.all(0),
                          side: BorderSide(width: 1, color: Color(0xFFC4C4C4)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10))),
                        ),
                        child: Icon(Icons.add,
                            color: Theme.of(context).colorScheme.secondary),
                      )),
                ],
              ),
            ),
            Text(
              "แก้ว",
              style: Theme.of(context).textTheme.bodyText2!.merge(
                  TextStyle(color: Theme.of(context).colorScheme.secondary)),
            )
          ],
        ),
      );
    });
  }
}
