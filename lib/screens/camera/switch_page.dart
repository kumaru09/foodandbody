import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/screens/camera/ar_camera.dart';
import 'package:foodandbody/screens/camera/camera_dialog.dart';
import 'package:foodandbody/services/arcore_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SwitchPage extends StatefulWidget {
  const SwitchPage({Key? key}) : super(key: key);

  @override
  State<SwitchPage> createState() => _SwitchPageState();
}

class _SwitchPageState extends State<SwitchPage> {
  bool _init = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      _showDialog();
    });
  }

  void _showDialog() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      bool? isFoodDialogChecked = prefs.getBool('isFoodDialogChecked');
      if (isFoodDialogChecked == null) {
        final value = await showDialog<bool>(
            context: context, builder: (BuildContext context) => FoodDialog());
        if (value!) prefs.setBool('isFoodDialogChecked', true);
      }
      setState(() {
        _init = true;
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return _init
        ? ARCamera(arCoreService: context.read<ARCoreService>())
        : Container();
  }
}
