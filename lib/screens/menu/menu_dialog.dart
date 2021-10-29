import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/screens/main_screen/main_screen.dart';
import 'package:foodandbody/screens/menu/bloc/menu_bloc.dart';

class MenuDialog extends StatefulWidget {
  const MenuDialog(
      {Key? key,
      required this.name,
      required this.serve,
      required this.unit,
      required this.isEatNow,
      double? volumn})
      : this.volumn = volumn ?? 0.0,
      super(key: key);

  final String name;
  final double serve;
  final String unit;
  final bool isEatNow;
  final double volumn;

  @override
  _MenuDialogState createState() => _MenuDialogState();
}

class _MenuDialogState extends State<MenuDialog> {
  double _currentSliderValue = 0;

  @override
  void initState() {
    super.initState();
    _currentSliderValue = widget.isEatNow? widget.volumn : widget.serve;
  }

  String toRound(double value) {
    if (value - value.toInt() == 0.0 ||
        value - value.toInt() < 0.01 ||
        value - value.toInt() >= 0.99)
      return value.toInt().toString();
    else
      return value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: <Widget>[
          Expanded(
            child: Text(widget.isEatNow ? 'ปริมาณที่กิน' : 'ปริมาณที่จะกิน',
                style: Theme.of(context).textTheme.subtitle1!.merge(
                    TextStyle(color: Theme.of(context).colorScheme.secondary))),
          ),
          Text('${toRound(_currentSliderValue)} ${widget.unit}',
              style: Theme.of(context).textTheme.subtitle1!.merge(
                  TextStyle(color: Theme.of(context).colorScheme.secondary))),
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      content: SingleChildScrollView(
        child: Slider(
          key: const Key('menu_dialog_slider'),
          value: _currentSliderValue,
          min: 0,
          max: widget.serve.toInt() * 5,
          activeColor: Theme.of(context).primaryColor,
          inactiveColor: Color(0xFFE0E0E0),
          divisions: widget.unit == 'กรัม' ? widget.serve.toInt() * 5 : 20,
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
          key: const Key('menu_dialog_ok_button'),
          onPressed: _currentSliderValue == 0.0
              ? null
              : () => context
                  .read<MenuBloc>()
                  .addMenu(
                      name: widget.name,
                      isEatNow: widget.isEatNow,
                      volumn: double.parse(toRound(_currentSliderValue)))
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
  }
}
