import 'package:flutter/material.dart';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';

class VerifyEmail extends StatelessWidget {
  const VerifyEmail({Key? key}) : super(key: key);

  // static Page page() => const MaterialPage<void>(child: VerifyEmail());

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
                    child: Text('ลงทะเบียน',
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.email,
                              color: Theme.of(context).colorScheme.secondary,
                              size: 120),
                          SizedBox(height: 16.0),
                          Text(
                            '''ระบบได้ส่งข้อความไปที่อีเมลของคุณแล้ว\nกรุณายืนยันตัวตนเพื่อลงทะเบียน''',
                            maxLines: 3,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyText1!.merge(
                                TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary)),
                          ),
                          SizedBox(height: 16.0),
                          Center(
                            child: ArgonTimerButton(
                              height: 40,
                              width: MediaQuery.of(context).size.width,
                              minWidth: 183,
                              highlightColor: Colors.transparent,
                              highlightElevation: 0,
                              roundLoadingShape: false,
                              onTap: (startTimer, btnState) {
                                if (btnState == ButtonState.Idle) {
                                  print('do something');
                                  startTimer(10);
                                }
                                
                              },
                              child: Text("ส่งอีกครั้ง",
                                  style: Theme.of(context)
                                      .textTheme
                                      .button!
                                      .merge(TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary))),
                              loader: (timeLeft) {
                                return Text(
                                  "รอสักครู่ | $timeLeft",
                                  style: Theme.of(context)
                                      .textTheme
                                      .button!
                                      .merge(TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary)),
                                );
                              },
                              borderRadius: 50.0,
                              color: Colors.transparent,
                              elevation: 0,
                              borderSide:
                                  BorderSide(color: Colors.black26, width: 1.5),
                            ),
                          ),
                          SizedBox(height: 16.0),
                        ],
                      ),
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
