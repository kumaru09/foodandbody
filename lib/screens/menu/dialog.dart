import 'package:flutter/material.dart';

class ConfirmCalDialog extends StatefulWidget {
  const ConfirmCalDialog({Key? key}) : super(key: key);

  @override
  _ConfirmCalDialogState createState() => _ConfirmCalDialogState();
}

class _ConfirmCalDialogState extends State<ConfirmCalDialog> {
  double _currentSliderValue = 1;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: <Widget>[
          Expanded(
            child: Text('ปริมาณที่จะกิน',
                style: Theme.of(context).textTheme.subtitle1!.merge(
                    TextStyle(color: Theme.of(context).colorScheme.secondary))),
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
          onPressed: () {},
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
  }
}
