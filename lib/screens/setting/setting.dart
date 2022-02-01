import 'package:flutter/material.dart';
import 'package:foodandbody/app/bloc/app_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/models/user.dart';
import 'package:foodandbody/repositories/user_repository.dart';
import 'package:foodandbody/screens/edit_profile/cubit/edit_profile_cubit.dart';
import 'package:foodandbody/screens/edit_profile/edit_profile.dart';

class Setting extends StatelessWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User _user = context.read<AppBloc>().state.user;
    final bool hasPhotoUrl;
    final String photoUrl;

    if (_user.info != null) {
      if (_user.info!.photoUrl != "") {
        hasPhotoUrl = true;
        photoUrl = _user.info!.photoUrl.toString();
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

    return Scaffold(
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
        body: SingleChildScrollView(
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
                            image:
                                AssetImage("assets/default_profile_image.png"),
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
                  _user.info != null ? _user.info!.name.toString() : "",
                  style: Theme.of(context).textTheme.headline6!.merge(TextStyle(
                      color: Theme.of(context).colorScheme.secondary)),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 8),
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: Text(
                  _user.info != null ? _user.email.toString() : "",
                  style: Theme.of(context).textTheme.bodyText2!.merge(TextStyle(
                      color: Theme.of(context).colorScheme.secondary)),
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
                          style: Theme.of(context).textTheme.subtitle2!.merge(
                                TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                        ),
                      ),
                      Container(
                        constraints: BoxConstraints.tightFor(height: 45),
                        padding: EdgeInsets.only(left: 17),
                        alignment: Alignment.topLeft,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        BlocProvider<EditProfileCubit>(
                                          create: (context) => EditProfileCubit(
                                              context.read<UserRepository>()),
                                          child: EditProfile(),
                                        )));
                          },
                          style: TextButton.styleFrom(
                              minimumSize: Size.zero,
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.zero),
                          child: Text(
                            "แก้ไขโปรไฟล์",
                            style: Theme.of(context).textTheme.bodyText1!.merge(
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
                            context.read<AppBloc>().add(AppLogoutRequested());
                            Navigator.pop(context);
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
                                .merge(TextStyle(color: Color(0xFFFF0000))),
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
                          style: Theme.of(context).textTheme.subtitle2!.merge(
                              TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary)),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 17, bottom: 14),
                        alignment: Alignment.topLeft,
                        constraints: BoxConstraints.tightFor(height: 45),
                        child: TextButton(
                          onPressed: () {
                            print("delete account");
                          },
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              alignment: Alignment.topLeft,
                              minimumSize: Size.zero),
                          child: Text(
                            "ลบบัญชี",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .merge(TextStyle(color: Color(0xFFFF0000))),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
