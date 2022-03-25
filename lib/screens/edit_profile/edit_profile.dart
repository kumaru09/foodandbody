import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodandbody/app/bloc/app_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/models/user.dart';
import 'package:foodandbody/repositories/user_repository.dart';
import 'package:foodandbody/screens/edit_profile/cubit/edit_profile_cubit.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<EditProfileCubit, EditProfileState>(
        listener: (context, state) {
          if (state.statusProfile.isSubmissionSuccess) {
            FocusManager.instance.primaryFocus?.unfocus();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text('แก้ไขข้อมูลเรียบร้อยแล้ว')),
              );
            final info = context.read<AppBloc>().state.user.info!.copyWith(
                name: state.name.value,
                photoUrl: state.photoUrl,
                gender: state.gender.value);
            context.read<AppBloc>().add(EditInfoRequested(
                context.read<AppBloc>().state.user.copyWith(info: info)));
            Navigator.of(context).pop();
          } else if (state.statusProfile.isSubmissionFailure) {
            FocusManager.instance.primaryFocus?.unfocus();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                  content: Text('${state.errorMessage}')));
          }
        },
        child: Scaffold(
          extendBody: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Theme.of(context).primaryColor,
            title: Text(
              "แก้ไขโปรไฟล์",
              style: Theme.of(context).textTheme.headline6!.merge(
                    TextStyle(color: Colors.white),
                  ),
            ),
            leading: IconButton(
              key: Key('editProfile_backButton'),
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              BlocBuilder<EditProfileCubit, EditProfileState>(
                  buildWhen: (previous, current) =>
                      previous.statusProfile != current.statusProfile,
                  builder: (context, state) {
                    return TextButton(
                      key: const Key('editProfile_saveButton'),
                      onPressed: state.statusProfile.isValidated
                          ? () => context
                              .read<EditProfileCubit>()
                              .editProfileSubmitted()
                          : null,
                      child: Text("บันทึก"),
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                        onSurface:
                            Theme.of(context).primaryColor, // Disable color
                      ),
                    );
                  }),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 21, bottom: 44),
                  width: MediaQuery.of(context).size.width,
                  constraints: BoxConstraints(minHeight: 50),
                  color: Theme.of(context).primaryColor,
                  alignment: Alignment.topCenter,
                  child: _EditProfileImage(),
                ),
                Container(
                  padding: EdgeInsets.only(left: 16, top: 26, right: 15),
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.topLeft,
                  child: _EditUsername(),
                ),
                Container(
                  padding: EdgeInsets.only(left: 16, top: 26, right: 15),
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.topLeft,
                  child: _EditGender(
                      context.read<EditProfileCubit>().state.gender.value),
                )
              ],
            ),
          ),
        ));
  }
}

class _EditProfileImage extends StatefulWidget {
  @override
  __EditProfileImageState createState() => __EditProfileImageState();
}

class __EditProfileImageState extends State<_EditProfileImage> {
  File? image;

  Future _pickImage({required source}) async {
    try {
      final ImagePicker _picker = ImagePicker();
      final _pickedImage = await _picker.pickImage(source: source);

      if (_pickedImage == null)
        return;
      else {
        final uri = await context
            .read<UserRepository>()
            .uploadProfilePic(File(_pickedImage.path));
        print(uri);
        context.read<EditProfileCubit>().photoUrlChanged(uri.toString());
      }
      setState(() {
        image = File(_pickedImage.path);
      });
    } catch (e) {
      print('pickImage: $e');
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(
            content: Text("อัพโหลดรูปภาพไม่สำเร็จ กรุณาลองอีกครั้ง")));
    }
  }

  String _getInitialImage(BuildContext context, User user) {
    if (user.info!.photoUrl != "") {
      final uri = user.info!.photoUrl.toString();
      context.read<EditProfileCubit>().photoUrlChanged(uri);
      return uri;
    } else if (user.photoUrl != null)
      return user.photoUrl.toString();
    else
      return "";
  }

  @override
  Widget build(BuildContext context) {
    User _user = context.read<AppBloc>().state.user;
    bool _hasProfileImage =
        (_user.photoUrl != null) || (_user.info!.photoUrl != "");
    return Stack(children: <Widget>[
      Container(
          child: CircleAvatar(
              radius: 77,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                key: Key('editProfile_image'),
                foregroundImage: image != null
                    ? Image.file(image!).image
                    : _hasProfileImage
                        ? NetworkImage(_getInitialImage(context, _user))
                        : Image.asset("assets/default_profile_image.png").image,
                backgroundColor: Colors.white,
                radius: 74,
              ))),
      Positioned(
          top: MediaQuery.of(context).size.height * 0.01,
          left: MediaQuery.of(context).size.width * 0.255,
          child: ElevatedButton(
            key: Key('editProfile_editImageButton'),
            style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                primary: Theme.of(context).colorScheme.secondary),
            child: Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: () => _showSelectSheet(context),
          ))
    ]);
  }

  _showSelectSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_camera,
                    color: Theme.of(context).colorScheme.secondary),
                title: Text("กล้องถ่ายรูป",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary)),
                onTap: () {
                  _pickImage(source: ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.collections,
                    color: Theme.of(context).colorScheme.secondary),
                title: Text("แกลลอรี",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary)),
                onTap: () {
                  _pickImage(source: ImageSource.gallery);
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }
}

class _EditUsername extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileCubit, EditProfileState>(
        buildWhen: (previous, current) => previous.name != current.name,
        builder: (context, state) {
          return TextFormField(
            key: Key('editProfile_username'),
            initialValue: context.read<EditProfileCubit>().state.name.value,
            onChanged: (name) =>
                context.read<EditProfileCubit>().usernameChanged(name),
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
                labelText: "ชื่อผู้ใช้งาน",
                errorText: state.name.invalid ? 'กรุณาระบุชื่อผู้ใช้งาน' : null,
                border: OutlineInputBorder(borderSide: BorderSide())),
          );
        });
  }
}

class _EditGender extends StatefulWidget {
  const _EditGender(this.gender);
  final String gender;
  @override
  __EditGenderState createState() => __EditGenderState();
}

class __EditGenderState extends State<_EditGender> {
  @override
  Widget build(BuildContext context) {
    String? _gender = widget.gender;

    return BlocBuilder<EditProfileCubit, EditProfileState>(
        buildWhen: (previous, current) => previous.gender != current.gender,
        builder: (context, state) {
          return DropdownButtonFormField(
            key: Key('editProfile_gender'),
            value: _gender,
            decoration: InputDecoration(
              labelText: "เพศ",
              border: OutlineInputBorder(borderSide: BorderSide()),
            ),
            items: [
              DropdownMenuItem<String>(
                child: Text("ชาย"),
                value: "M",
              ),
              DropdownMenuItem<String>(
                child: Text("หญิง"),
                value: "F",
              )
            ],
            onChanged: (String? gender) {
              setState(() {
                _gender = gender;
              });
              context.read<EditProfileCubit>().genderChanged(gender!);
            },
          );
        });
  }
}
