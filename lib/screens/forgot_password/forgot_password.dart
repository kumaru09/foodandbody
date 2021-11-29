import 'package:flutter/material.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
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
                    child: Text('ตั้งค่ารหัสผ่านใหม่',
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .merge(TextStyle(color: Colors.white))),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: //if bloc state to render _GetEmail(), _SendMessageToEmail() or  _SetNewPassword(), 
                      _GetEmail(),
                      //  _SendMessageToEmail(),
                      // _SetNewPassword(), 
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GetEmail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          '''กรุณากรอกอีเมลที่ใช้ลงทะเบียน\nเพื่อเริ่มการตั้งค่ารหัสผ่านใหม่''',
          maxLines: 2,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .merge(TextStyle(color: Theme.of(context).colorScheme.secondary)),
        ),
        SizedBox(height: 16.0),
        _EmailInput(),
        SizedBox(height: 16.0),
        _GetEmailButton(),
      ],
    );
  }
}

class _SendMessageToEmail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.check_circle,
            color: Theme.of(context).colorScheme.secondary, size: 120),
        SizedBox(height: 16.0),
        Text(
          '''ระบบได้ส่งข้อความไปที่อีเมลของคุณแล้ว\nกรุณายืนยันตัวตนเพื่อตั้งค่ารหัสผ่านใหม่''',
          maxLines: 3,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .merge(TextStyle(color: Theme.of(context).colorScheme.secondary)),
        ),
        SizedBox(height: 16.0),
      ],
    );
  }
}

class _SetNewPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        PasswordInput(),
        SizedBox(height: 16.0),
        ConfirmPasswordInput(),
        SizedBox(height: 16.0),
        _SetNewPasswordButton()
      ],
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: const Key('forgot_password_emailInput_textField'),
      onChanged: (text) {},
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'อีเมล',
        border: OutlineInputBorder(borderSide: BorderSide()),
        // errorText: state.email.invalid ? 'invalid email' : null,
      ),
    );
  }
}

class _GetEmailButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        key: const Key('forgot_password_continue_raisedButton'),
        onPressed: () {},
        child: Text('ยืนยัน'),
        style: ElevatedButton.styleFrom(
          primary: Theme.of(context).colorScheme.secondary,
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50))),
        ),
      ),
    );
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
    return TextField(
            onChanged: (password) {},
            decoration: InputDecoration(
                labelText: 'รหัสผ่าน',
                border: OutlineInputBorder(),
                // errorText: state.password.invalid ? 'invalid password' : null,
                suffixIcon: InkWell(
                  onTap: () {
                    setState(() {
                      _isHidden = !_isHidden;
                    });
                  },
                  child:
                      Icon(_isHidden ? Icons.visibility : Icons.visibility_off),
                )),
            obscureText: _isHidden,
          );
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
    return TextField(
            onChanged: (confirmPassword) {},
            decoration: InputDecoration(
                labelText: 'ยืนยันรหัสผ่าน',
                border: OutlineInputBorder(),
                // errorText: state.confirmedPassword.invalid
                //     ? 'passwords do not match'
                //     : null,
                suffixIcon: InkWell(
                  onTap: () {
                    setState(() {
                      _isHidden = !_isHidden;
                    });
                  },
                  child:
                      Icon(_isHidden ? Icons.visibility : Icons.visibility_off),
                )),
            obscureText: _isHidden,
          );
  }
}

class _SetNewPasswordButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        child: Text('ยืนยัน'),
        style: ElevatedButton.styleFrom(
          primary: Theme.of(context).colorScheme.secondary,
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50))),
        ),
      ),
    );
  }
}
