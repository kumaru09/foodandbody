import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/repositories/body_repository.dart';
import 'package:foodandbody/repositories/camera_repository.dart';
import 'package:foodandbody/repositories/history_repository.dart';
import 'package:foodandbody/repositories/menu_card_repository.dart';
import 'package:foodandbody/repositories/plan_repository.dart';
import 'package:foodandbody/repositories/user_repository.dart';
import 'package:foodandbody/screens/body/body.dart';
import 'package:foodandbody/screens/body/cubit/body_cubit.dart';
import 'package:foodandbody/screens/camera/bloc/camera_bloc.dart';
import 'package:foodandbody/screens/camera/camera.dart';
import 'package:foodandbody/screens/history/bloc/history_bloc.dart';
import 'package:foodandbody/screens/history/history.dart';
import 'package:foodandbody/screens/home/bloc/home_bloc.dart';
import 'package:foodandbody/screens/home/home.dart';
import 'package:foodandbody/screens/initial_info/initial_info.dart';
import 'package:foodandbody/screens/main_screen/bottom_appbar.dart';
import 'package:foodandbody/screens/plan/bloc/plan_bloc.dart';
import 'package:foodandbody/screens/plan/plan.dart';
import 'package:foodandbody/screens/main_screen/bloc/info_bloc.dart';
import 'package:foodandbody/widget/menu_card/bloc/menu_card_bloc.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key, required this.index}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: MainScreen(index: 0));

  final int index;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => InfoBloc(userRepository: context.read<UserRepository>())
        ..add(LoadInfo()),
      child: MainScreenPage(index: index),
    );
  }
}

class MainScreenPage extends StatefulWidget {
  const MainScreenPage({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  _MainScreenPageState createState() => _MainScreenPageState();
}

class _MainScreenPageState extends State<MainScreenPage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index;
  }

  _getPage(int index) {
    switch (index) {
      case 0:
        return Home();
      case 1:
        return Plan();
      case 2:
        return Body();
      case 3:
        return History();
      default:
        return Text("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom == 0.0;
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocBuilder<InfoBloc, InfoState>(
        builder: (context, state) {
          switch (state.status) {
            case InfoStatus.failure:
              return Scaffold(
                  extendBody: true,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  body: _failureWidget(context));
            case InfoStatus.success:
              return state.info != null
                  ? Scaffold(
                      extendBody: true,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      body: MultiBlocProvider(
                        providers: [
                          BlocProvider(
                              create: (_) => PlanBloc(
                                  planRepository:
                                      context.read<PlanRepository>(),
                                  userRepository:
                                      context.read<UserRepository>())
                                ..add(LoadPlan())),
                          BlocProvider(
                              create: (_) => HistoryBloc(
                                  historyRepository:
                                      context.read<HistoryRepository>(),
                                  bodyRepository:
                                      context.read<BodyRepository>())
                                ..add(LoadHistory())
                                ..add(LoadMenuList(dateTime: DateTime.now()))),
                          BlocProvider(
                              create: (_) => BodyCubit(
                                  bodyRepository:
                                      context.read<BodyRepository>(),
                                  userRepository:
                                      context.read<UserRepository>())
                                ..fetchBody()),
                          BlocProvider(
                              create: (_) => HomeBloc(
                                  planRepository:
                                      context.read<PlanRepository>())
                                ..add(LoadWater())),
                          BlocProvider(
                              create: (_) => MenuCardBloc(
                                  menuCardRepository:
                                      context.read<MenuCardRepository>())
                                ..add(FetchedFavMenuCard())),
                        ],
                        child: _getPage(_currentIndex),
                      ),
                      floatingActionButtonLocation:
                          FloatingActionButtonLocation.centerDocked,
                      floatingActionButton: Visibility(
                          visible: isKeyboardOpen,
                          child: FloatingActionButton(
                            key: const Key('camera_floating_button'),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Camera()));
                            },
                            elevation: 0.4,
                            child: Icon(Icons.photo_camera),
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                          )),
                      bottomNavigationBar: BottomNavigation(
                          index: _currentIndex, onChangedTab: _onChangedTab),
                    )
                  : Scaffold(
                      extendBody: true,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      body: InitialInfo());
            default:
              return Scaffold(
                  extendBody: true,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  body: Center(child: CircularProgressIndicator()));
          }
        },
      ),
    );
  }

  void _onChangedTab(int index) {
    setState(() {
      this._currentIndex = index;
    });
  }

  Widget _failureWidget(BuildContext context) {
    return Center(
      child: Column(
        key: Key('mainScreen_failure_widget'),
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
            onPressed: () => context.read<InfoBloc>().add(LoadInfo()),
          ),
        ],
      ),
    );
  }
}
