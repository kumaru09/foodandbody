import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/screens/edit_profile/cubit/edit_profile_cubit.dart';
import 'package:formz/formz.dart';

class EditPassword extends StatefulWidget {
  const EditPassword({Key? key}) : super(key: key);

  @override
  _EditPasswordState createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<EditProfileCubit, EditProfileState>(
        listener: (context, state) {
          if (state.statusPassword.isSubmissionSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text('เปลี่ยนรหัสผ่านเรียบร้อยแล้ว')),
              );
            Navigator.of(context).pop();
          } else if (state.statusPassword.isSubmissionFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                    content: Text(
                        '${state.errorMessage ?? 'เกิดข้อผิดพลาดบางอย่าง'}')),
              );
          }
        },
        child: Scaffold(
          extendBody: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 0,
            title: Text(
              "แก้ไขรหัสผ่าน",
              style: Theme.of(context).textTheme.headline6!.merge(
                    TextStyle(color: Colors.white),
                  ),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            actions: [
              IconButton(
                  onPressed: () =>
                      context.read<EditProfileCubit>().editPasswordSubmitted(),
                  icon: Icon(Icons.done, color: Colors.white))
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 4),
                  BlocBuilder<EditProfileCubit, EditProfileState>(
                      buildWhen: (previous, current) =>
                          previous.oldPassword != current.oldPassword,
                      builder: (context, state) {
                        return TextFormField(
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              labelText: "รหัสผ่านเดิม",
                              errorText: state.password.invalid
                                  ? 'รหัสผ่านอย่างน้อย 8 ตัว มีตัวอักษรตัวเล็ก ตัวใหญ๋ และตัวเลข'
                                  : null,
                              border:
                                  OutlineInputBorder(borderSide: BorderSide())),
                          onChanged: (password) => context
                              .read<EditProfileCubit>()
                              .oldPasswordChanged(password),
                        );
                      }),
                  SizedBox(height: 20),
                  BlocBuilder<EditProfileCubit, EditProfileState>(
                      buildWhen: (previous, current) =>
                          previous.password != current.password,
                      builder: (context, state) {
                        return TextFormField(
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              labelText: "รหัสผ่านใหม่",
                              errorText: state.password.invalid
                                  ? 'รหัสผ่านอย่างน้อย 8 ตัว มีตัวอักษรตัวเล็ก ตัวใหญ๋ และตัวเลข'
                                  : null,
                              border:
                                  OutlineInputBorder(borderSide: BorderSide())),
                          onChanged: (password) => context
                              .read<EditProfileCubit>()
                              .passwordChanged(password),
                        );
                      }),
                  SizedBox(height: 20),
                  BlocBuilder<EditProfileCubit, EditProfileState>(
                      buildWhen: (previous, current) =>
                          previous.confirmedPassword !=
                          current.confirmedPassword,
                      builder: (context, state) {
                        return TextFormField(
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              labelText: "ยืนยันรหัสผ่านใหม่",
                              errorText: state.confirmedPassword.invalid
                                  ? 'รหัสผ่านไม่ตรงกัน'
                                  : null,
                              border:
                                  OutlineInputBorder(borderSide: BorderSide())),
                          onChanged: (password) => context
                              .read<EditProfileCubit>()
                              .confirmedPasswordChanged(password),
                        );
                      })
                ],
              ),
            ),
          ),
        ));
  }
}
