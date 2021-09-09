import 'package:flutter/material.dart';
import 'package:foodandbody/screens/register/register_form1.dart'; 

class Register extends StatelessWidget {
  const Register({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: const RegisterForm1(),
      )
    );
  }
}