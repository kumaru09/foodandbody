import 'package:flutter/material.dart';
import 'package:foodandbody/screens/home/bloc/home_bloc.dart';
import 'package:foodandbody/screens/plan/bloc/plan_bloc.dart';
import 'package:foodandbody/screens/main_screen/bloc/info_bloc.dart';
import 'package:provider/src/provider.dart';

class AddExerciseButton extends StatelessWidget {
  const AddExerciseButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      key: const Key('home_add_exercise_button'),
      onPressed: () async {
        final value = await showDialog(
            context: context,
            builder: (BuildContext context) => _AddExerciseDialog());
        if (value != null) {
          context.read<PlanBloc>().add(AddExercise(
              id: value['activity'],
              min: value['time'],
              weight: context.read<InfoBloc>().state.info!.weight!));
        }
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
  String? _time;
  final _formKey = GlobalKey<FormState>();

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
      key: const Key("home_add_exercise_dialog"),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 16,
      backgroundColor: Colors.white,
      title: Text(
        "ออกกำลังกาย",
        style: Theme.of(context).textTheme.subtitle1!.merge(
              TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              key: const Key("activity_select_dropdown"),
              items: _dropdownItem,
              value: _activity,
              validator: (value) => value == null ? "กรุณาเลือกกิจกกรม" : null,
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
              key: const Key("time_text_field"),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              validator: (value) =>
                  (value == null || value.isEmpty) ? "กรุณากรอกเวลา" : null,
              decoration: InputDecoration(
                labelText: "เวลา (นาที)",
                hintText: "ตัวอย่าง 30, 45, 60",
                border: OutlineInputBorder(borderSide: BorderSide()),
              ),
              onChanged: (time) => setState(() {
                _time = time;
              }),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          key: const Key("add_exercise_dialog_ok_button"),
          onPressed: () => Navigator.pop(
              context, {'activity': _activity, 'time': int.parse(_time!)}),
          child: Text(
            "ตกลง",
            style: Theme.of(context).textTheme.button!.merge(
                  TextStyle(color: Theme.of(context).primaryColor),
                ),
          ),
        ),
        TextButton(
          key: const Key("add_exercise_dialog_cancel_button"),
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
