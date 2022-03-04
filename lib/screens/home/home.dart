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

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlanBloc, PlanState>(builder: (context, planState) {
      return BlocBuilder<HomeBloc, HomeState>(builder: (context, homeState) {
        return BlocBuilder<InfoBloc, InfoState>(builder: (context, infoState) {
          switch (planState.status) {
            case PlanStatus.success:
              switch (homeState.status) {
                case HomeStatus.success:
                  switch (infoState.status) {
                    case InfoStatus.success:
                      return _SuccessWidget(
                          planState: planState, infoState: infoState);
                    case InfoStatus.failure:
                      return _FailureWidget(failure: 'info');
                    default:
                      return Center(child: CircularProgressIndicator());
                  }
                case HomeStatus.failure:
                  return _FailureWidget(failure: 'home');
                default:
                  return Center(child: CircularProgressIndicator());
              }
            case PlanStatus.failure:
              return _FailureWidget(failure: 'plan');
            default:
              return Center(child: CircularProgressIndicator());
          }
        });
      });
    });
  }
}

class _SuccessWidget extends StatefulWidget {
  const _SuccessWidget(
      {Key? key, required this.planState, required this.infoState})
      : super(key: key);

  final PlanState planState;
  final InfoState infoState;

  @override
  State<_SuccessWidget> createState() => __SuccessWidgetState();
}

class __SuccessWidgetState extends State<_SuccessWidget> {
  Future<void> _onReFrech() async {
    await Future.delayed(Duration(seconds: 2));
    context.read<HomeBloc>().add(LoadWater(isRefresh: true));
    context.read<PlanBloc>().add(LoadPlan(isRefresh: true));
    context.read<InfoBloc>().add(LoadInfo());
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
                  child:
                      // BlocBuilder<PlanBloc, PlanState>(
                      //   builder: (context, state) {
                      //     return
                      Card(
                          color: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          elevation: 2,
                          child: CircularCalIndicator(
                              widget.planState.plan, widget.infoState.info!)
                          // _buildCard(context, planState.plan)
                          )),
              //   },
              // )),
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
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .merge(TextStyle(color: Theme.of(context).primaryColor)),
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
              Container(
                  padding: EdgeInsets.only(left: 16, top: 8, right: 15),
                  child: ExerciseList(widget.planState.plan.exerciseList)),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(bottom: 100),
                alignment: Alignment.center,
                child: AddExerciseButton(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _FailureWidget extends StatelessWidget {
  const _FailureWidget({Key? key, required this.failure}) : super(key: key);

  final String failure;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(image: AssetImage('assets/error.png')),
          SizedBox(height: 10),
          Text('ไม่สามารถโหลดข้อมูลได้ในขณะนี้',
              style: Theme.of(context).textTheme.bodyText2!.merge(
                  TextStyle(color: Theme.of(context).colorScheme.secondary))),
          OutlinedButton(
            child: Text('ลองอีกครั้ง'),
            style: OutlinedButton.styleFrom(
              primary: Theme.of(context).colorScheme.secondary,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50))),
            ),
            onPressed: () {
              switch (failure) {
                case "plan":
                  context.read<PlanBloc>().add(LoadPlan());
                  break;
                case "home":
                  context.read<HomeBloc>().add(LoadWater());
                  break;
                case "info":
                  context.read<InfoBloc>().add(LoadInfo());
                  break;
                default:
              }
            },
          ),
        ],
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
