import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/app/bloc/app_bloc.dart';
import 'package:foodandbody/repositories/authen_repository.dart';
import 'package:foodandbody/repositories/user_repository.dart';
import 'package:foodandbody/screens/setting/cubit/delete_user_cubit.dart';
import 'package:formz/formz.dart';

class DeleteUser extends StatelessWidget {
  const DeleteUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => DeleteUserCubit(context.read<AuthenRepository>()),
        child: BlocListener<DeleteUserCubit, DeleteUserState>(
          listener: ((context, state) {
            if (state.status.isSubmissionFailure) {
              FocusManager.instance.primaryFocus?.unfocus();
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(content: Text('${state.errorMessage}')),
                );
            } else if (state.status.isSubmissionSuccess) {
              Navigator.popUntil(context, (Route<dynamic> route) => false);
              context.read<AuthenRepository>().logOut();
            }
          }),
          child: Scaffold(
            extendBody: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              elevation: 0,
              title: Text(
                "ลบบัญชีผู้ใช้",
                style: Theme.of(context).textTheme.headline6!.merge(
                      TextStyle(color: Colors.white),
                    ),
              ),
              leading: IconButton(
                key: const Key('deleteUser_backButton'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
              actions: [
                BlocBuilder<DeleteUserCubit, DeleteUserState>(
                  buildWhen: (previous, current) =>
                      previous.status != current.status,
                  builder: (context, state) {
                    return TextButton(
                      key: const Key('deleteUser_sumbitButton'),
                      onPressed: state.status.isValidated
                          ? () => context.read<DeleteUserCubit>().deleteUser()
                          : null,
                      child: Text("ตกลง"),
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                        onSurface:
                            Theme.of(context).primaryColor, // Disable color
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
                    BlocBuilder<DeleteUserCubit, DeleteUserState>(
                        buildWhen: (previous, current) =>
                            previous.password != current.password,
                        builder: (context, state) {
                          return TextFormField(
                            key: const Key('deleteUser_password_textFormField'),
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                labelText: "รหัสผ่าน",
                                errorText: state.password.invalid
                                    ? 'รหัสผ่านอย่างน้อย 8 ตัว มีตัวอักษรตัวเล็ก ตัวใหญ๋ และตัวเลข'
                                    : null,
                                errorMaxLines: 2,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide())),
                            onChanged: (password) => context
                                .read<DeleteUserCubit>()
                                .passwordChanged(password),
                          );
                        }),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
