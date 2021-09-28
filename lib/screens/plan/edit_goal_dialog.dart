import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EditGoalDialog extends StatelessWidget {
  TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 24,
      onPressed: () => showDialog(
          context: context,
          builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 0,
                backgroundColor: Colors.white,
                title: Text(
                  "แก้ไขเป้าหมายแคลอรี่",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                content: TextField(
                  controller: _textFieldController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: "ตัวอย่าง 1600"),
                ),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("ยกเลิก")),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("ตกลง"))
                ],
              )),
      icon: Icon(
        Icons.edit,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
