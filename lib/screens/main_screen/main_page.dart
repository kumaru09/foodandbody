import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:foodandbody/screens/main_screen/main_screen.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: MainPage());

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => MainScreen(index: 0)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
