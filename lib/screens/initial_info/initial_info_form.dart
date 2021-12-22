import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/app/bloc/app_bloc.dart';
import 'package:foodandbody/screens/initial_info/cubit/initial_info_cubit.dart';
import 'package:formz/formz.dart';
import 'package:intl/intl.dart';

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
                const SnackBar(
                    content: Text('กรอกข้อมูลไม่สำเร็จ กรุณาลองอีกครั้ง')),
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
                          _BDateInput(),
                          SizedBox(height: 16.0),
                          _GenderInput(),
                          SizedBox(height: 16.0),
                          _ExerciseInput(),
                          SizedBox(height: 16.0),
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

const ColorScheme _calendarColorScheme = ColorScheme(
  primary: Color(0xFFFF8E6E),
  primaryVariant: Color(0xFFc85f42),
  secondary: Color(0xFF515070),
  secondaryVariant: Color(0xFF272845),
  surface: Colors.white,
  background: Color(0xFFF6F6F6),
  error: Color(0xFFFF0000),
  onPrimary: Colors.white,
  onSecondary: Colors.white,
  onSurface: Color(0xFF515070),
  onBackground: Color(0xFF515070),
  onError: Colors.white,
  brightness: Brightness.light,
);

class _BDateInput extends StatefulWidget {
  const _BDateInput({Key? key}) : super(key: key);

  @override
  __BDateInputState createState() => __BDateInputState();
}

class __BDateInputState extends State<_BDateInput> {
  TextEditingController dateinput = TextEditingController();

  @override
  void initState() {
    dateinput.text = "";
    super.initState();
  }

  _selectDate(BuildContext context) async {
    FocusScope.of(context).requestFocus(new FocusNode());
    DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'เลือกวัน',
      cancelText: 'ยกเลิก',
      confirmText: 'ตกลง',
      errorFormatText: 'กรุณาระบุรูปแบบวันที่ที่ถูกต้อง',
      errorInvalidText: 'กรุณาเลือกวันที่อยู่ในช่วงที่กำหนด',
      fieldHintText: 'วัน/เดือน/ปี',
      fieldLabelText: 'วันที่',
      locale: const Locale("th", "TH"),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            colorScheme: _calendarColorScheme,
            textTheme: Theme.of(context).textTheme,
          ),
          child: child as Widget,
        );
      },
    );
    if (selected != null) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(selected);
      dateinput.text = formattedDate;
      context.read<InitialInfoCubit>().bDateChanged(selected.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InitialInfoCubit, InitialInfoState>(
        buildWhen: (previous, current) => previous.bDate != current.bDate,
        builder: (context, state) {
          return TextFormField(
            key: const Key('initialInfoForm_bDateInput_textField'),
            controller: dateinput,
            onTap: () => _selectDate(context),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'วันเกิด',
              hintText: 'วัน/เดือน/ปี',
              suffixIcon: Icon(Icons.calendar_today),
              border: OutlineInputBorder(borderSide: BorderSide()),
              errorText: state.bDate.invalid ? 'กรุณาระบุวันเกิดของคุณ' : null,
            ),
          );
        });
  }
}

class _GenderInput extends StatefulWidget {
  const _GenderInput({Key? key}) : super(key: key);

  @override
  __GenderInputState createState() => __GenderInputState();
}

class __GenderInputState extends State<_GenderInput> {
  String? _gender;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InitialInfoCubit, InitialInfoState>(
        buildWhen: (previous, current) => previous.gender != current.gender,
        builder: (context, state) {
      return DropdownButtonFormField<String>(
        key: const Key('initialInfoForm_genderInput_textField'),
        value: _gender,
        decoration: InputDecoration(
          labelText: 'เพศ',
          border: OutlineInputBorder(borderSide: BorderSide()),
          errorText: state.gender.invalid ? 'กรุณาระบุเพศของคุณ' : null,
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

class _ExerciseInput extends StatefulWidget {
  const _ExerciseInput({Key? key}) : super(key: key);

  @override
  __ExerciseInputState createState() => __ExerciseInputState();
}

class __ExerciseInputState extends State<_ExerciseInput> {
  String? _exercise;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InitialInfoCubit, InitialInfoState>(
        buildWhen: (previous, current) => previous.exercise != current.exercise,
        builder: (context, state) {
      return DropdownButtonFormField<String>(
        key: const Key('initialInfoForm_exerciseInput_textField'),
        value: _exercise,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: 'การออกกำลังกาย',
          border: OutlineInputBorder(borderSide: BorderSide()),
          errorText:
              state.exercise.invalid ? 'กรุณาระบุการออกกำลังกายของคุณ' : null,
        ),
        items: [
          DropdownMenuItem<String>(
            child: Text('ไม่ได้ออกกำลังกาย'),
            value: '1.2',
          ),
          DropdownMenuItem<String>(
            child: Text('ออกกำลังกายเบา 1-3 วันต่อสัปดาห์'),
            value: '1.375',
          ),
          DropdownMenuItem<String>(
            child: Text('ออกกำลังกายกลาง 3-5 วันต่อสัปดาห์'),
            value: '1.55',
          ),
          DropdownMenuItem<String>(
            child: Text('ออกกำลังกายหนัก 6-7 วันต่อสัปดาห์'),
            value: '1.725',
          ),
          DropdownMenuItem<String>(
            child: Text('ออกกำลังกายหนักวันละ 2 ครั้ง'),
            value: '1.9',
          ),
        ],
        onChanged: (String? exercise) {
          setState(() {
            _exercise = exercise;
          });
          context.read<InitialInfoCubit>().exerciseChanged(exercise!);
        },
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
                        ? () async {
                            await context
                                .read<InitialInfoCubit>()
                                .initialInfoFormSubmitted();
                            context.read<AppBloc>().add(AppUserChanged(
                                context.read<AppBloc>().state.user));
                          }
                        : null,
                    child: Text('บันทึก'),
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).colorScheme.secondary,
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
