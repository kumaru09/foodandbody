import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/repositories/plan_repository.dart';
import 'package:foodandbody/repositories/user_repository.dart';
import 'package:foodandbody/screens/plan/bloc/plan_bloc.dart';

class AddExerciseButton extends StatelessWidget {
  const AddExerciseButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      key: const Key('home_add_exercise_button'),
      onPressed: () async {
        final value = await showDialog(
            context: context,
            builder: (BuildContext context) => BlocProvider<PlanBloc>(
                create: (_) => PlanBloc(
                    planRepository: context.read<PlanRepository>(),
                    userRepository: context.read<UserRepository>()),
                child: AddExerciseDialog()));
        if (value != null) {
          context.read<PlanBloc>().add(AddExercise(
              id: value['activity'],
              min: int.parse(value['time']),
              weight: context.read<UserRepository>().cache.get()!.weight!));
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

class AddExerciseDialog extends StatelessWidget {
  const AddExerciseDialog({Key? key}) : super(key: key);

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
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _ExerciseTypeInput(),
          SizedBox(height: 20),
          _ExerciseTimeInput(),
        ],
      ),
      actions: <Widget>[
        TextButton(
          key: const Key("add_exercise_dialog_cancel_button"),
          onPressed: () => Navigator.pop(context),
          child: Text(
            "ยกเลิก",
            style: Theme.of(context).textTheme.button!.merge(
                  TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
          ),
        ),
        BlocBuilder<PlanBloc, PlanState>(
          buildWhen: (previous, current) =>
              previous.exerciseStatus != current.exerciseStatus,
          builder: (context, state) {
            return TextButton(
              key: const Key("add_exercise_dialog_ok_button"),
              onPressed: state.exerciseType.valid && state.exerciseTime.valid
                  // state.exerciseStatus.isValidate
                  ? () => Navigator.pop(context, {
                        'activity': state.exerciseType.value,
                        'time': state.exerciseTime.value,
                      })
                  : null,
              child: Text("ตกลง"),
              style: TextButton.styleFrom(
                primary: Theme.of(context).colorScheme.secondary,
                onSurface: Theme.of(context).colorScheme.secondaryVariant, // Disable color
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ExerciseTimeInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlanBloc, PlanState>(
        buildWhen: (previous, current) =>
            previous.exerciseTime != current.exerciseTime,
        builder: (context, state) {
          return TextFormField(
            key: const Key("exercise_time_text_field"),
            onChanged: (time) =>
                context.read<PlanBloc>().add(ExerciseTimeChange(value: time)),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: "เวลา (นาที)",
              hintText: "ตัวอย่าง 30, 45, 60",
              border: OutlineInputBorder(borderSide: BorderSide()),
              errorText:
                  state.exerciseTime.invalid ? 'กรุณากรอกเวลาให้ถูกต้อง' : null,
            ),
          );
        });
  }
}

class _ExerciseTypeInput extends StatefulWidget {
  const _ExerciseTypeInput({Key? key}) : super(key: key);

  @override
  __ExerciseTypeInputState createState() => __ExerciseTypeInputState();
}

class __ExerciseTypeInputState extends State<_ExerciseTypeInput> {
  String? _type;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlanBloc, PlanState>(
        buildWhen: (previous, current) =>
            previous.exerciseType != current.exerciseType,
        builder: (context, state) {
          return DropdownButtonFormField<String>(
            key: const Key("activity_select_dropdown"),
            value: _type,
            // isExpanded: true,
            decoration: InputDecoration(
              labelText: "กิจกรรม",
              border: OutlineInputBorder(borderSide: BorderSide()),
              errorText:
                  state.exerciseType.invalid ? 'กรุณาเลือกกิจกกรม' : null,
            ),
            items: [
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
            ],
            onChanged: (String? type) {
              setState(() {
                _type = type;
              });
              context.read<PlanBloc>().add(ExerciseTypeChange(value: type!));
            },
          );
        });
  }
}
