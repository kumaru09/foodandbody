import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/screens/edit_profile/cubit/edit_profile_cubit.dart';
import 'package:formz/formz.dart';

class EditPassword extends StatelessWidget {
  const EditPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditProfileCubit, EditProfileState>(
      listener: (context, state) {
        if (state.statusPassword.isSubmissionSuccess) {
          FocusManager.instance.primaryFocus?.unfocus();
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text('เปลี่ยนรหัสผ่านเรียบร้อยแล้ว')),
            );
          Navigator.of(context).pop();
        } else if (state.statusPassword.isSubmissionFailure) {
          FocusManager.instance.primaryFocus?.unfocus();
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text('${state.errorMessage}')),
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
            key: const Key('editPassword_backButton'),
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          actions: [
            BlocBuilder<EditProfileCubit, EditProfileState>(
              buildWhen: (previous, current) =>
                  previous.statusPassword != current.statusPassword,
              builder: (context, state) {
                return TextButton(
                  key: const Key('editPassword_saveButton'),
                  onPressed: state.statusPassword.isValidated
                      ? () => context
                          .read<EditProfileCubit>()
                          .editPasswordSubmitted()
                      : null,
                  child: Text("บันทึก"),
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    onSurface: Theme.of(context).primaryColor, // Disable color
                  ),
                );
              },
            ),
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
                  key: const Key('editPassword_oldPassword_textFormField'),
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            labelText: "รหัสผ่านเดิม",
                            errorText: state.oldPassword.invalid
                                ? 'รหัสผ่านอย่างน้อย 8 ตัว มีตัวอักษรตัวเล็ก ตัวใหญ๋ และตัวเลข'
                                : null,
                            errorMaxLines: 2,
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
                        previous.password != current.password ||
                        previous.oldPassword != current.oldPassword,
                    builder: (context, state) {
                      return TextFormField(
                  key: const Key('editPassword_password_textFormField'),
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            labelText: "รหัสผ่านใหม่",
                            errorText: state.password.invalid
                                ? 'รหัสผ่านอย่างน้อย 8 ตัว มีตัวอักษรตัวเล็ก ตัวใหญ๋ และตัวเลข'
                                : state.password.valid &&
                                        state.password.value ==
                                            state.oldPassword.value
                                    ? 'รหัสผ่านใหม่ซ้ำกับรหัสผ่านเดิม'
                                    : null,
                            errorMaxLines: 2,
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
                        previous.password != current.password ||
                        previous.confirmedPassword != current.confirmedPassword,
                    builder: (context, state) {
                      return TextFormField(
                  key: const Key('editPassword_confirmedPassword_textFormField'),
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            labelText: "ยืนยันรหัสผ่านใหม่",
                            errorText: state.confirmedPassword.invalid &&
                                    state.confirmedPassword.value != ''
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
      ),
    );
  }
}
