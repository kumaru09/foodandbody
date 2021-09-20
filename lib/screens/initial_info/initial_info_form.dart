import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/screens/initial_info/cubit/initial_info_cubit.dart';
import 'package:formz/formz.dart';

class InitialInfoForm extends StatelessWidget {
  const InitialInfoForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<InitialInfoCubit, InitialInfoState>(
        listener: (context, state) {
          if (state.status.isSubmissionSuccess) {
            Navigator.of(context).pop();
          } else if (state.status.isSubmissionFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(content: Text('กรอกข้อมูลไม่สำเร็จ กรุณาลองอีกครั้ง')),
              );
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Image(image: AssetImage('assets/logo.png')),
                  Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('ข้อมูลส่วนตัว',
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .merge(TextStyle(color: Colors.white)))),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          _UsernameInput(),
                          SizedBox(height: 16.0),
                          _WeightInput(),
                          SizedBox(height: 16.0),
                          _HeightInput(),
                          SizedBox(height: 16.0),
                          GenderInput(),
                          SizedBox(height: 16.0),
                          _GoalInput(),
                          SizedBox(height: 24.0),
                          _InitialInfoButton(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InitialInfoCubit, InitialInfoState>(
        buildWhen: (previous, current) => previous.weight != current.weight,
        builder: (context, state) {
          return TextFormField(
            key: const Key('initialInfoForm_usernameInput_textField'),
            onChanged: (username) =>
                context.read<InitialInfoCubit>().usernameChanged(username),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'ชื่อผู้ใช้งาน',
              border: OutlineInputBorder(borderSide: BorderSide()),
              errorText:
                  state.username.invalid ? 'กรุณาระบุชื่อผู้ใช้งาน' : null,
            ),
          );
        });
  }
}

class _WeightInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InitialInfoCubit, InitialInfoState>(
        buildWhen: (previous, current) => previous.weight != current.weight,
        builder: (context, state) {
          return TextFormField(
            key: const Key('initialInfoForm_weightInput_textField'),
            onChanged: (weight) =>
                context.read<InitialInfoCubit>().weightChanged(weight),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'น้ำหนัก (กก.)',
              hintText: 'ตัวอย่าง 48,79,103',
              border: OutlineInputBorder(borderSide: BorderSide()),
              errorText:
                  state.weight.invalid ? 'กรุณาระบุน้ำหนักให้ถูกต้อง' : null,
            ),
          );
        });
  }
}

class _HeightInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InitialInfoCubit, InitialInfoState>(
        buildWhen: (previous, current) => previous.height != current.height,
        builder: (context, state) {
          return TextFormField(
            key: const Key('initialInfoForm_heightInput_textField'),
            onChanged: (height) =>
                context.read<InitialInfoCubit>().heightChanged(height),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'ส่วนสูง (ซม.)',
              hintText: 'ตัวอย่าง 90, 156, 198',
              border: OutlineInputBorder(borderSide: BorderSide()),
              errorText:
                  state.height.invalid ? 'กรุณาระบุส่วนสูงให้ถูกต้อง' : null,
            ),
          );
        });
  }
}

class GenderInput extends StatefulWidget {
  const GenderInput({Key? key}) : super(key: key);

  @override
  _GenderInputState createState() => _GenderInputState();
}

class _GenderInputState extends State<GenderInput> {
  String? _gender;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InitialInfoCubit, InitialInfoState>(
        buildWhen: (previous, current) => previous.height != current.height,
        builder: (context, state) {
          return DropdownButtonFormField<String>(
            key: const Key('initialInfoForm_genderInput_textField'),
            value: _gender,
            decoration: InputDecoration(
              labelText: 'เพศ',
              border: OutlineInputBorder(borderSide: BorderSide()),
              errorText: state.gender.invalid ? 'กรุณาระบุเพศ' : null,
            ),
            items: [
              DropdownMenuItem<String>(
                child: Text('ชาย'),
                value: 'M',
              ),
              DropdownMenuItem<String>(
                child: Text('หญิง'),
                value: 'F',
              )
            ],
            onChanged: (String? gender) {
              setState(() {
                _gender = gender;
              });
              context.read<InitialInfoCubit>().genderChanged(gender!);
            },
          );
        });
  }
}

class _GoalInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InitialInfoCubit, InitialInfoState>(
        buildWhen: (previous, current) => previous.calory != current.calory,
        builder: (context, state) {
          return TextFormField(
            key: const Key('initialInfoForm_caloryInput_textField'),
            onChanged: (calory) =>
                context.read<InitialInfoCubit>().caloryChanged(calory),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'เป้าหมายแคลอรี',
              hintText: 'ตัวอย่าง 1600',
              border: OutlineInputBorder(borderSide: BorderSide()),
              errorText: state.calory.invalid
                  ? 'กรุณาระบุเป้าหมายแคลอรีให้ถูกต้อง'
                  : null,
            ),
          );
        });
  }
}

class _InitialInfoButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InitialInfoCubit, InitialInfoState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return state.status.isSubmissionInProgress
              ? const CircularProgressIndicator()
              : SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    key: const Key('initialInfoForm_continue_raisedButton'),
                    onPressed: state.status.isValidated
                        ? () => context
                            .read<InitialInfoCubit>()
                            .initialInfoFormSubmitted()
                        : null,
                    child: Text('บันทึก'),
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).accentColor,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 50.0),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                    ),
                  ),
                );
        });
  }
}
