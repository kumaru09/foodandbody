import 'package:flutter/material.dart';
import 'package:foodandbody/screens/body/body.dart';
import 'package:foodandbody/screens/camera/camera.dart';
import 'package:foodandbody/screens/history/history.dart';
import 'package:foodandbody/screens/home/home.dart';
import 'package:foodandbody/screens/main_screen/bottom_appbar.dart';
import 'package:foodandbody/screens/plan/plan.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: MainScreen());

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

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
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _getPage(_currentIndex),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Visibility(
        visible: isKeyboardOpen,
        child: FloatingActionButton(
        key: const Key('camera_floating_button'),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Camera()));
        },
        elevation: 0.4,
        child: Icon(Icons.photo_camera),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      )),
      bottomNavigationBar: BottomNavigation(
          index: _currentIndex, onChangedTab: _onChangedTab)
    );
  }

  void _onChangedTab(int index) {
    setState(() {
      this._currentIndex = index;
    });
  }
}
