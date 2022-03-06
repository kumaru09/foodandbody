import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/app/bloc/app_bloc.dart';
import 'package:foodandbody/models/history.dart';
import 'package:foodandbody/repositories/plan_repository.dart';
import 'package:foodandbody/screens/home/add_exercise.dart';
import 'package:foodandbody/screens/home/bloc/home_bloc.dart';
import 'package:foodandbody/screens/home/circular_cal_indicator.dart';
import 'package:foodandbody/screens/home/exercise_list.dart';
import 'package:foodandbody/screens/search/search_page.dart';
import 'package:foodandbody/screens/plan/bloc/plan_bloc.dart';
import 'package:foodandbody/screens/setting/bloc/info_bloc.dart';
import 'package:foodandbody/screens/setting/setting.dart';
import 'package:foodandbody/widget/menu_card/bloc/menu_card_bloc.dart';
import 'package:foodandbody/widget/menu_card/menu_card.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<void> _onReFrech() async {
    await Future.delayed(Duration(seconds: 2));
    context.read<HomeBloc>().add(LoadWater(isRefresh: true));
    context.read<PlanBloc>().add(LoadPlan(isRefresh: true));
    context.read<MenuCardBloc>().add(ReFetchedFavMenuCard(isRefresh: true));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
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
      body: RefreshIndicator(
        onRefresh: _onReFrech,
        child: SingleChildScrollView(
          child: BlocBuilder<PlanBloc, PlanState>(builder: (context, state) {
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 16, top: 16),
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "แคลอรีวันนี้",
                    style: Theme.of(context).textTheme.bodyText1!.merge(
                        TextStyle(color: Theme.of(context).primaryColor)),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 16, top: 8, right: 15),
                  width: MediaQuery.of(context).size.width,
                  constraints: BoxConstraints(minHeight: 100),
                  child: Card(
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 2,
                    child: BlocBuilder<PlanBloc, PlanState>(
                      builder: (context, state) {
                        switch (state.status) {
                          case PlanStatus.success:
                            return _buildCard(context, state.plan);
                          case PlanStatus.failure:
                            return Container(
                              height: 200,
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 10),
                                    Text('ไม่สามารถโหลดข้อมูลได้ในขณะนี้',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2!
                                            .merge(TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary))),
                                    OutlinedButton(
                                      child: Text('ลองอีกครั้ง'),
                                      key: const Key('home_tryAgain_button_circle'),
                                      style: OutlinedButton.styleFrom(
                                        primary: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50))),
                                      ),
                                      onPressed: () => context
                                          .read<PlanBloc>()
                                          .add(LoadPlan()),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          default:
                            return Container(
                                height: 200,
                                child:
                                    Center(child: CircularProgressIndicator()));
                        }
                      },
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 16, top: 16, right: 8),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "เมนูยอดนิยม",
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
                        icon: Icon(Icons.add,
                            color: Theme.of(context).primaryColor),
                        label: Text("ดูทั้งหมด",
                            style: Theme.of(context).textTheme.button!.merge(
                                TextStyle(
                                    color: Theme.of(context).primaryColor))),
                      )
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  constraints: BoxConstraints(minHeight: 100),
                  child: MenuCard(isMyFav: false),
                ),
                Container(
                  padding: EdgeInsets.only(left: 16, top: 16),
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "น้ำวันนี้",
                    style: Theme.of(context).textTheme.bodyText1!.merge(
                        TextStyle(color: Theme.of(context).primaryColor)),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  width: MediaQuery.of(context).size.width,
                  constraints: BoxConstraints(minHeight: 80),
                  child: _DailyWater(),
                ),
                Container(
                  padding: EdgeInsets.only(left: 16, top: 16),
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "ออกกำลังกาย",
                    style: Theme.of(context).textTheme.bodyText1!.merge(
                          TextStyle(color: Theme.of(context).primaryColor),
                        ),
                  ),
                ),
                BlocBuilder<PlanBloc, PlanState>(
                  builder: (context, state) {
                    switch (state.status) {
                      case PlanStatus.success:
                        return Column(
                          children: [
                            Container(
                              padding:
                                  EdgeInsets.only(left: 16, top: 8, right: 15),
                              child: ExerciseList(state.plan.exerciseList),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.only(bottom: 100),
                              alignment: Alignment.center,
                              child: AddExerciseButton(),
                            )
                          ],
                        );
                      case PlanStatus.failure:
                        return Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 10),
                              Text('ไม่สามารถโหลดข้อมูลได้ในขณะนี้',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .merge(TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary))),
                              OutlinedButton(
                                child: Text('ลองอีกครั้ง'),
                                key: const Key('home_tryAgain_button_exercise'),
                                style: OutlinedButton.styleFrom(
                                  primary:
                                      Theme.of(context).colorScheme.secondary,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50))),
                                ),
                                onPressed: () =>
                                    context.read<PlanBloc>().add(LoadPlan()),
                              ),
                              SizedBox(height: 100),
                            ],
                          ),
                        );
                      default:
                        return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, History plan) {
    return BlocBuilder<InfoBloc, InfoState>(builder: (context, state) {
      switch (state.status) {
        case InfoStatus.success:
          return CircularCalIndicator(plan, state.info!);
        case InfoStatus.failure:
          return Container(
            height: 200,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                    onPressed: () => context.read<InfoBloc>().add(LoadInfo()),
                  ),
                ],
              ),
            ),
          );
        default:
          return Container(
              height: 200, child: Center(child: CircularProgressIndicator()));
      }
    });
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
                          context.read<HomeBloc>().add(DecreaseWaterEvent());
                          context.read<HomeBloc>().add(WaterChanged(
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
                          context.read<HomeBloc>().add(IncreaseWaterEvent());
                          context
                              .read<HomeBloc>()
                              .add(WaterChanged(water: state.water + 1));
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
