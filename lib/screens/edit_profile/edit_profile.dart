import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodandbody/app/bloc/app_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/models/user.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.done,
              color: Colors.white,
            ),
          )
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
              child: _EditEmail(),
            ),
            Container(
              padding: EdgeInsets.only(left: 16, top: 26, right: 15),
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.topLeft,
              child: _EditPassword(),
            ),
            Container(
              padding: EdgeInsets.only(left: 16, top: 26, right: 15),
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.topLeft,
              child: _EditGender(),
            )
          ],
        ),
      ),
    );
  }
}

class _EditProfileImage extends StatefulWidget {
  File? image;

  @override
  __EditProfileImageState createState() => __EditProfileImageState();
}

class __EditProfileImageState extends State<_EditProfileImage> {
  Future _pickImage({required source}) async {
    try {
      final ImagePicker _picker = ImagePicker();
      final _pickedImage = await _picker.pickImage(source: source);

      if (_pickedImage == null) return;
      setState(() {
        widget.image = File(_pickedImage.path);
        print("image: ${widget.image}");
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(
            content: Text("อัพโหลดรูปภาพไม่สำเร็จ กรุณาลองอีกครั้ง")));
    }
  }

  String getInitialImage(BuildContext context) {
    User _user = context.read<AppBloc>().state.user;
    if (_user.info!.photoUrl != "")
      return _user.info!.photoUrl.toString();
    else if (_user.photoUrl != null)
      return _user.photoUrl.toString();
    else
      return "";
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Container(
          child: CircleAvatar(
        radius: 77,
        backgroundColor: Colors.white,
        child: widget.image == null
            ? CircleAvatar(
                foregroundImage: getInitialImage(context) != ""
                    ? NetworkImage(
                        context.read<AppBloc>().state.user.photoUrl.toString())
                    : Image.asset("assets/default_profile_image.png").image,
                backgroundColor: Colors.white,
                radius: 74,
              )
            : CircleAvatar(
                foregroundImage: Image.file(widget.image!).image,
                backgroundColor: Colors.white,
                radius: 74,
              ),
      )),
      Positioned(
          top: MediaQuery.of(context).size.height * 0.01,
          left: MediaQuery.of(context).size.width * 0.255,
          child: ElevatedButton(
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
    return TextFormField(
      initialValue: context.read<AppBloc>().state.user.info!.name,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          labelText: "ชื่อผู้ใช้งาน",
          border: OutlineInputBorder(borderSide: BorderSide())),
    );
  }
}

class _EditEmail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: context.read<AppBloc>().state.user.email,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          labelText: "อีเมล",
          border: OutlineInputBorder(borderSide: BorderSide())),
    );
  }
}

class _EditPassword extends StatefulWidget {
  @override
  __EditPasswordState createState() => __EditPasswordState();
}

class __EditPasswordState extends State<_EditPassword> {
  bool _isHidden = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: "รหัสผ่าน",
        border: OutlineInputBorder(
          borderSide: BorderSide(),
        ),
        suffixIcon: InkWell(
          child: Icon(_isHidden ? Icons.visibility : Icons.visibility_off),
          onTap: () {
            setState(() {
              _isHidden = !_isHidden;
            });
          },
        ),
      ),
      obscureText: _isHidden,
    );
  }
}

class _EditGender extends StatefulWidget {
  @override
  __EditGenderState createState() => __EditGenderState();
}

class __EditGenderState extends State<_EditGender> {
  @override
  Widget build(BuildContext context) {
    String? _gender = context.read<AppBloc>().state.user.info!.gender;

    return DropdownButtonFormField(
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
      },
    );
  }
}
