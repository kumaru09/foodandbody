import 'package:flutter/material.dart';
import 'package:foodandbody/app/bloc/app_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/repositories/authen_repository.dart';
import 'package:foodandbody/repositories/user_repository.dart';
import 'package:foodandbody/screens/edit_profile/cubit/edit_profile_cubit.dart';
import 'package:foodandbody/screens/edit_profile/edit_profile.dart';
import 'package:foodandbody/screens/edit_profile/edit_password.dart';
import 'package:foodandbody/screens/setting/cubit/delete_user_cubit.dart';

class Setting extends StatelessWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          child: BlocProvider(
            create: (context) =>
                DeleteUserCubit(context.read<AuthenRepository>())
                  ..initialSetting(),
            child: SettingPage(),
          ),
        ));
  }
}

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    final _user = context.read<AppBloc>().state.user;
    final _info = context.read<UserRepository>().cache.get();
    final bool hasPhotoUrl;
    final String photoUrl;

    if (_info != null) {
      if (_info.photoUrl != "") {
        hasPhotoUrl = true;
        photoUrl = _info.photoUrl.toString();
      } else if (_user.photoUrl != null) {
        hasPhotoUrl = true;
        photoUrl = _user.photoUrl.toString();
      } else {
        hasPhotoUrl = false;
        photoUrl = "";
      }
    } else {
      hasPhotoUrl = false;
      photoUrl = "";
    }

    return BlocListener<DeleteUserCubit, DeleteUserState>(
      listenWhen: (previous, current) =>
          previous.deleteStatus != current.deleteStatus,
      listener: ((context, state) {
        if (state.deleteStatus == DeleteUserStatus.failure) {
          FocusManager.instance.primaryFocus?.unfocus();
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text('${state.errorMessage}')),
            );
        } else if (state.deleteStatus == DeleteUserStatus.success) {
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
          title: Text("ตั้งค่า",
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .merge(TextStyle(color: Colors.white))),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back, color: Colors.white)),
        ),
        body: BlocBuilder<DeleteUserCubit, DeleteUserState>(
            builder: (context, state) {
          switch (state.status) {
            case SettingStatus.failure:
              return Center(
                child: Column(
                  key: Key('setting_failure_widget'),
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(image: AssetImage('assets/error.png')),
                    SizedBox(height: 10),
                    Text('ไม่สามารถโหลดข้อมูลได้ในขณะนี้',
                        style: Theme.of(context).textTheme.bodyText2!.merge(
                            TextStyle(
                                color:
                                    Theme.of(context).colorScheme.secondary))),
                    OutlinedButton(
                      child: Text('ลองอีกครั้ง'),
                      style: OutlinedButton.styleFrom(
                        primary: Theme.of(context).colorScheme.secondary,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                      ),
                      onPressed: () =>
                          context.read<DeleteUserCubit>().initialSetting(),
                    ),
                  ],
                ),
              );
            case SettingStatus.success:
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 21),
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: ClipOval(
                          child: hasPhotoUrl
                              ? Image.network(
                                  photoUrl,
                                  width: 148,
                                  height: 148,
                                  fit: BoxFit.cover,
                                )
                              : Image(
                                  image: AssetImage(
                                      "assets/default_profile_image.png"),
                                  width: 148,
                                  height: 148,
                                  fit: BoxFit.cover,
                                )),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 17),
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: Text(
                        _info != null ? _info.name.toString() : "",
                        style: Theme.of(context).textTheme.headline6!.merge(
                            TextStyle(
                                color:
                                    Theme.of(context).colorScheme.secondary)),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 8),
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: Text(
                        _info != null ? _user.email.toString() : "",
                        style: Theme.of(context).textTheme.bodyText2!.merge(
                            TextStyle(
                                color:
                                    Theme.of(context).colorScheme.secondary)),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 16, top: 23, right: 15),
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.topCenter,
                      constraints: BoxConstraints(minHeight: 100),
                      child: Card(
                        color: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 17, top: 11),
                              alignment: Alignment.topLeft,
                              child: Text(
                                "โปรไฟล์",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2!
                                    .merge(
                                      TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                              ),
                            ),
                            Container(
                              constraints: BoxConstraints.tightFor(height: 45),
                              padding: EdgeInsets.only(left: 17),
                              alignment: Alignment.topLeft,
                              child: TextButton(
                                onPressed: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              BlocProvider<EditProfileCubit>(
                                                create: (context) =>
                                                    EditProfileCubit(context
                                                        .read<UserRepository>())
                                                      ..initProfile(
                                                        name: _info!.name!,
                                                        gender: _info.gender!,
                                                        photoUrl: photoUrl,
                                                      ),
                                                child: EditProfile(),
                                              ))).then(
                                      (value) => setState(() {}));
                                },
                                style: TextButton.styleFrom(
                                    minimumSize: Size.zero,
                                    alignment: Alignment.topLeft,
                                    padding: EdgeInsets.zero),
                                child: Text(
                                  "แก้ไขโปรไฟล์",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .merge(
                                        TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                      ),
                                ),
                              ),
                            ),
                            if (state.accountType != 'google.com' &&
                                state.accountType != 'facebook.com')
                              Container(
                                constraints:
                                    BoxConstraints.tightFor(height: 45),
                                padding: EdgeInsets.only(left: 17),
                                alignment: Alignment.topLeft,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => BlocProvider<
                                                    EditProfileCubit>(
                                                create: (context) =>
                                                    EditProfileCubit(
                                                        context.read<
                                                            UserRepository>()),
                                                child: EditPassword())));
                                  },
                                  style: TextButton.styleFrom(
                                      minimumSize: Size.zero,
                                      alignment: Alignment.topLeft,
                                      padding: EdgeInsets.zero),
                                  child: Text(
                                    "แก้ไขรหัสผ่าน",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .merge(
                                          TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary),
                                        ),
                                  ),
                                ),
                              ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              constraints: BoxConstraints.tightFor(height: 10),
                              child: Divider(
                                color: Color(0x21212114),
                                thickness: 1,
                                indent: 11,
                                endIndent: 12,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 17, bottom: 14),
                              alignment: Alignment.topLeft,
                              constraints: BoxConstraints.tightFor(height: 40),
                              child: TextButton(
                                onPressed: () {
                                  context
                                      .read<AppBloc>()
                                      .add(AppLogoutRequested());
                                  Navigator.popUntil(
                                      context, (Route<dynamic> route) => false);
                                },
                                style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    alignment: Alignment.topLeft,
                                    minimumSize: Size.zero),
                                child: Text(
                                  "ออกจากระบบ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .merge(
                                          TextStyle(color: Color(0xFFFF0000))),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 16, top: 20, right: 15),
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.topCenter,
                      constraints: BoxConstraints(minHeight: 100),
                      child: Card(
                        elevation: 2,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 17, top: 11),
                              alignment: Alignment.topLeft,
                              child: Text(
                                "บัญชี",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2!
                                    .merge(TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary)),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 17, bottom: 14),
                              alignment: Alignment.topLeft,
                              constraints: BoxConstraints.tightFor(height: 45),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    alignment: Alignment.topLeft,
                                    minimumSize: Size.zero),
                                child: Text(
                                  "ลบบัญชี",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .merge(
                                          TextStyle(color: Color(0xFFFF0000))),
                                ),
                                onPressed: () async {
                                  final value = await showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      content: Text(
                                          'ลบบัญชีและข้อมูลทั้งหมดในบัญชี',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1!
                                              .merge(TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary))),
                                      actions: <Widget>[
                                        TextButton(
                                            key: const Key(
                                                "setting_deleteAccount_dialog_cancel_button"),
                                            onPressed: () => Navigator.pop(
                                                context, 'cancel'),
                                            child: Text("ยกเลิก",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .button!
                                                    .merge(TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .secondary)))),
                                        TextButton(
                                            key: const Key(
                                                "setting_deleteAccount_dialog_ok_button"),
                                            onPressed: () =>
                                                Navigator.pop(context, 'ok'),
                                            child: Text("ตกลง",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .button!
                                                    .merge(TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .secondary)))),
                                      ],
                                    ),
                                  );
                                  if (value == 'ok')
                                    context
                                        .read<DeleteUserCubit>()
                                        .deleteUser();
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            default:
              return Center(child: CircularProgressIndicator());
          }
        }),
      ),
    );
  }
}
