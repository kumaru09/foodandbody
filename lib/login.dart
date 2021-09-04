import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  // Login({Key? key, required this.title}) : super(key: key);
  // final String title;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
                  //เข้าสู่ระบบ
                  Text('เข้าสู่ระบบ', style: Theme.of(context).textTheme.headline5!.merge(TextStyle(color: Colors.white))),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            autofocus: true,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              // hintText: 'ชื่อผู้ใช้งาน',
                              labelText: 'ชื่อผู้ใช้งาน',
                              border:
                                  OutlineInputBorder(borderSide: BorderSide()),
                            ),
                            // onChanged: (value) {
                            //   formData.email = value;
                            // },
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'รหัสผ่าน',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(
                                Icons.remove_red_eye,
                              ),
                            ),
                            obscureText: true,
                            // onChanged: (value) {
                            //   formData.password = value;
                            // },
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  child: Text('ลืมรหัสผ่าน?',
                                      style: Theme.of(context)
                                          .textTheme
                                          .button!
                                          .merge(TextStyle(
                                              color: Theme.of(context)
                                                  .accentColor))),
                                  onPressed: () {/*validation*/},
                                ),
                              ]),
                          ElevatedButton(
                            onPressed: () {
                              // Respond to button press
                            },
                            child: Text('เข้าสู่ระบบ'),
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).accentColor,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 50.0),
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50))),
                            ),
                          ),
                          Text('หรือ'),
                          //Facebook+Google
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image(image: AssetImage('assets/facebook.png')),
                                Image(image: AssetImage('assets/google.png')),
                              ]),
                          Text('ลงทะเบียน',
                              style: Theme.of(context).textTheme.button!.merge(
                                  TextStyle(
                                      color: Theme.of(context).accentColor))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
