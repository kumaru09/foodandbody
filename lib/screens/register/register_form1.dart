import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodandbody/screens/register/register_form2.dart';

class RegisterForm1 extends StatelessWidget {
  const RegisterForm1({Key? key}) : super(key: key);

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
                  child: Text('ลงทะเบียน',
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
                      _EmailInput(),
                      SizedBox(height: 16.0),
                      PasswordInput(),
                      SizedBox(height: 16.0),
                      ConfirmPasswordInput(),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 16, 16, 10),
                        child: _RegisterButton(),
                      ),
                      Text('หรือ',
                          style: Theme.of(context).textTheme.bodyText2!.merge(
                              TextStyle(color: Theme.of(context).accentColor))),
                      Padding(
                          padding: EdgeInsets.fromLTRB(16, 6, 16, 16),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _FacebookRegisterButton(),
                                _GoogleRegisterButton(),
                              ])),
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

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return BlocBuilder<RegisterCubit, RegisterState>(
    //     buildWhen: (previous, current) => previous.email != current.email,
    //     builder: (context, state) {
    return TextFormField(
      key: const Key('registerForm_emailInput_textField'),
      // onChanged: (email) => context.read<RegisterCubit>().emailChanged(email),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'อีเมล',
        border: OutlineInputBorder(borderSide: BorderSide()),
        // errorText: state.email.invalid ? 'invalid email' : null,
      ),
    );
    // });
  }
}

class PasswordInput extends StatefulWidget {
  @override
  _PasswordInputState createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool _isHidden = true;

  @override
  Widget build(BuildContext context) {
    // return BlocBuilder<RegisterCubit, RegisterState>(
    //     buildWhen: (previous, current) => previous.password != current.password,
    //     builder: (context, state) {
    return TextField(
      key: const Key('registerForm_passwordInput_textField'),
      // onChanged: (password) =>
      //     context.read<RegisterCubit>().passwordChanged(password),
      decoration: InputDecoration(
          labelText: 'รหัสผ่าน',
          border: OutlineInputBorder(),
          // errorText: state.password.invalid ? 'invalid password' : null,
          suffixIcon: InkWell(
            key: const Key('registerForm_password_visibilityIcon'),
            onTap: () {
              setState(() {
                _isHidden = !_isHidden;
              });
            },
            child: Icon(_isHidden ? Icons.visibility : Icons.visibility_off),
          )),
      obscureText: _isHidden,
    );
    // });
  }
}

class ConfirmPasswordInput extends StatefulWidget {
  @override
  _ConfirmPasswordInputState createState() => _ConfirmPasswordInputState();
}

class _ConfirmPasswordInputState extends State<ConfirmPasswordInput> {
  bool _isHidden = true;

  @override
  Widget build(BuildContext context) {
    // return BlocBuilder<RegisterCubit, RegisterState>(
    //     buildWhen: (previous, current) => previous.password != current.password,
    //     builder: (context, state) {
    return TextField(
      key: const Key('registerForm_confirmpasswordInput_textField'),
      // onChanged: (password) =>
      //     context.read<RegisterCubit>().passwordChanged(password),
      decoration: InputDecoration(
          labelText: 'ยืนยันรหัสผ่าน',
          border: OutlineInputBorder(),
          // errorText: state.password.invalid ? 'invalid password' : null,
          suffixIcon: InkWell(
            key: const Key('registerForm_confirmpassword_visibilityIcon'),
            onTap: () {
              setState(() {
                _isHidden = !_isHidden;
              });
            },
            child: Icon(_isHidden ? Icons.visibility : Icons.visibility_off),
          )),
      obscureText: _isHidden,
    );
    // });
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
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Scaffold(
                  backgroundColor: Theme.of(context).primaryColor,
                  body: SafeArea(
                    child: const RegisterForm2(),
                  ))),
        );
      },
      // onPressed: state.status.isValidated
      //     ? () => context.read<RegisterCubit>()
      //     .registerWithCredentials() : null,
      child: Text('ลงทะเบียน'),
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

class _GoogleRegisterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      key: const Key('registerForm_googlerRegister'),
      label: Text(''),
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        primary: Color(0xFFEA4335),
        padding: EdgeInsets.fromLTRB(13, 13, 6, 13),
      ),
      icon: const Icon(FontAwesomeIcons.google, color: Colors.white),
      onPressed: () {},
      // onPressed: () => context.read<LoginCubit>().logInWithGoogle(),
    );
  }
}

class _FacebookRegisterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      key: const Key('registerForm_facebookRegister'),
      label: Text(''),
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        primary: Color(0xFF3B5998),
        padding: EdgeInsets.fromLTRB(13, 13, 6, 13),
      ),
      icon: const Icon(FontAwesomeIcons.facebookF, color: Colors.white),
      onPressed: () {},
    );
  }
}
