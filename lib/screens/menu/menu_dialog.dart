import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/screens/main_screen/main_screen.dart';
import 'package:foodandbody/screens/menu/bloc/menu_bloc.dart';

class MenuDialog extends StatefulWidget {
  const MenuDialog({Key? key, required this.name, required this.isEatNow}) : super(key: key);

  final String name;
  final bool isEatNow;

  @override
  _MenuDialogState createState() => _MenuDialogState();
}

class _MenuDialogState extends State<MenuDialog> {
  double _currentSliderValue = 1;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuBloc, MenuState>(builder: (context, state) {
      return AlertDialog(
        title: Row(
          children: <Widget>[
            Expanded(
              child: Text(widget.isEatNow? 'ปริมาณที่กิน':'ปริมาณที่จะกิน',
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
            onPressed: _currentSliderValue == 0.0
                ? null
                : () => context
                    .read<MenuBloc>()
                    .addMenu(name: widget.name, isEatNow: widget.isEatNow, volumn: _currentSliderValue)
                    .then((value) => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainScreen(index: 1)),
                          (Route<dynamic> route) => false,
                        )),
            child: Text('ตกลง',
                style: Theme.of(context).textTheme.button!.merge(TextStyle(
                    color: _currentSliderValue == 0.0
                        ? Theme.of(context).colorScheme.secondaryVariant
                        : Theme.of(context).colorScheme.secondary))),
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
