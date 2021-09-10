import 'package:flutter/material.dart';
// import 'package:formz/formz.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:foodandbody/screens/register/cubit/register_cubit.dart';

class InnitialInfo extends StatelessWidget {
  const InnitialInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 16, 16, 10),
                        child: _RegisterButton(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: const Key('registerForm_emailInput_textField'),
      // onChanged: (email) =>
      //     context.read<LoginCubit>().emailChanged(email),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'ชื่อผู้ใช้งาน',
        border: OutlineInputBorder(borderSide: BorderSide()),
        // errorText: state.email.invalid ? 'invalid email' : null,
      ),
    );
  }
}

class _WeightInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: const Key('registerForm_weight_textField'),
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'น้ำหนัก (กก.)',
        border: OutlineInputBorder(borderSide: BorderSide()),
      ),
    );
  }
}

class _HeightInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: const Key('registerForm_height_textField'),
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'ส่วนสูง (ซม.)',
        border: OutlineInputBorder(borderSide: BorderSide()),
      ),
    );
  }
}

class GenderInput extends StatefulWidget {
  const GenderInput({Key? key}) : super(key: key);

  @override
  _GenderInputState createState() => _GenderInputState();
}

class _GenderInputState extends State<GenderInput> {
  String? _value;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: _value,
      decoration: InputDecoration(
        labelText: 'เพศ',
        border: OutlineInputBorder(borderSide: BorderSide()),
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
      onChanged: (String? value) {
        setState(() {
          _value = value;
        });
      },
    );
  }
}

class _GoalInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: const Key('registerForm_goal_textField'),
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'เป้าหมายแคลอรี',
        border: OutlineInputBorder(borderSide: BorderSide()),
      ),
    );
  }
}

class _RegisterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
        // BlocBuilder<RegisterCubit, RegisterState>(
        //     buildWhen: (previous, current) => previous.status != current.status,
        //     builder: (context, state) {
        //       return state.status.isSubmissionInProgress
        //           ? const CircularProgressIndicator()
        //           :
        ElevatedButton(
      key: const Key('registerForm_continue_raisedButton'),
      onPressed: () {},
      // onPressed: state.status.isValidated
      //     ? () => context.read<RegisterCubit>()
      //     .registerWithCredentials() : null,
      child: Text('บันทึก'),
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).accentColor,
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50))),
      ),
    );
    // });
  }
}
