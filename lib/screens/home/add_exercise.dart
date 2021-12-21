import 'package:flutter/material.dart';

class AddExerciseButton extends StatelessWidget {
  const AddExerciseButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        await showDialog(
            context: context,
            builder: (BuildContext context) => _AddExerciseDialog());
      },
      style: ElevatedButton.styleFrom(
          primary: Theme.of(context).scaffoldBackgroundColor, elevation: 0),
      icon: Icon(
        Icons.add,
        color: Theme.of(context).primaryColor,
      ),
      label: Text(
        "เพิ่มการออกกำลังกาย",
        style: Theme.of(context).textTheme.button!.merge(
              TextStyle(color: Theme.of(context).primaryColor),
            ),
      ),
    );
  }
}

class _AddExerciseDialog extends StatefulWidget {
  const _AddExerciseDialog({Key? key}) : super(key: key);

  @override
  __AddExerciseDialogState createState() => __AddExerciseDialogState();
}

class __AddExerciseDialogState extends State<_AddExerciseDialog> {
  String? _activity;
  String _time = '0';

  List<DropdownMenuItem<String>> _dropdownItem = [
    DropdownMenuItem(
      child: Text("แอโรบิค"),
      value: "0",
    ),
    DropdownMenuItem(
      child: Text("ปั่นจักรยาน"),
      value: "1",
    ),
    DropdownMenuItem(
      child: Text("วิ่ง"),
      value: "2",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 16,
      backgroundColor: Colors.white,
      title: Text(
        "ออกกำลังกาย",
        style: Theme.of(context).textTheme.subtitle1!.merge(
              TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            items: _dropdownItem,
            value: _activity,
            decoration: InputDecoration(
              labelText: "กิจกรรม",
              border: OutlineInputBorder(borderSide: BorderSide()),
            ),
            onChanged: (String? activity) {
              setState(() {
                _activity = activity;
              });
            },
          ),
          SizedBox(height: 20),
          TextFormField(
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: "เวลา (นาที)",
                hintText: "ตัวอย่าง 30, 45, 60",
                border: OutlineInputBorder(borderSide: BorderSide()),
              ),
              onChanged: (time) => setState(() {
                    _time = time;
                  }))
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "ตกลง",
            style: Theme.of(context).textTheme.button!.merge(
                  TextStyle(color: Theme.of(context).primaryColor),
                ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "ยกเลิก",
            style: Theme.of(context).textTheme.button!.merge(
                  TextStyle(color: Theme.of(context).primaryColor),
                ),
          ),
        ),
      ],
    );
  }
}
