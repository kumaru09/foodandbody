import 'package:flutter/material.dart';

class BodyDialog extends StatefulWidget {
  const BodyDialog({Key? key}) : super(key: key);

  @override
  State<BodyDialog> createState() => _BodyDialogState();
}

class _BodyDialogState extends State<BodyDialog> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('กล้องวัดสัดส่วนร่างกาย'),
      content: SingleChildScrollView(
        child: Column(children: <Widget>[
          Text(
              'กล้องจะทำการถ่ายรูป 2 ครั้ง เมื่อกดถ่ายรูปจะทำการนับเวลาถอยหลัง 5 วิ ในการถ่ายแต่ละรูป'),
          SizedBox(
            height: 16,
          ),
          Text(
              'ผู้ใช้จะต้องยืนหันหน้าเข้าหากล้องในรูปที่หนึ่ง และยืนหันข้างในที่รูปสอง'),
          SizedBox(
            height: 16,
          ),
          Text(
              'ในการถ่ายรูปโดยควรวางกล้องให้สามารถถ่ายเห็นทั้งตัว และยืนให้พอดีกับกรอบสีชมพูที่แสดงบนหน้าจอ'),
        ]),
      ),
      actions: <Widget>[
        CheckboxListTile(
            key: const Key('bodyDialog_checkBoxListTile'),
            contentPadding: EdgeInsets.only(left: 4),
            title: Transform.translate(
              offset: Offset(-16, 0),
              child:
                  const Text('ไม่ต้องแสดงอีก', style: TextStyle(fontSize: 16)),
            ),
            controlAffinity: ListTileControlAffinity.leading,
            value: isChecked,
            checkColor: Colors.white,
            activeColor: Theme.of(context).primaryColor,
            onChanged: (bool? value) {
              setState(() {
                isChecked = value!;
              });
            }),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop(isChecked);
            },
            child: const Text('เข้าใจแล้ว'))
      ],
    );
  }
}

class FoodDialog extends StatefulWidget {
  const FoodDialog({Key? key}) : super(key: key);

  @override
  State<FoodDialog> createState() => _FoodDialogState();
}

class _FoodDialogState extends State<FoodDialog> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('กล้องประมาณแคลอรีอาหาร'),
      content: SingleChildScrollView(
        child: Column(children: <Widget>[
          Text(
              'ผู้ใช้จะต้องเลื่อนกล้องขึ้นถ่ายด้านบนของอาหาร และเลื่อนลง 45 องศา ถ่ายด้านข้างของอาหาร'),
          SizedBox(
            height: 16,
          ),
          Text(
              'จนกว่าจะปรากฏจุดสีเขียวขึ้นบนหน้าจอเพียงพอ กล้องจะแนะนำผู้ใช้ขยับกล้องให้ขนานกับอาหาร'),
          SizedBox(
            height: 16,
          ),
          Text(
              'โดยขยับให้ตัวเลขเข้าใกล้ 0 หรือ 180 จนกว่ากล้องจะขึ้นพร้อมถ่ายรูป'),
        ]),
      ),
      actions: <Widget>[
        CheckboxListTile(
            key: const Key('foodDialog_checkBoxListTile'),
            contentPadding: EdgeInsets.only(left: 4),
            title: Transform.translate(
              offset: Offset(-16, 0),
              child:
                  const Text('ไม่ต้องแสดงอีก', style: TextStyle(fontSize: 16)),
            ),
            controlAffinity: ListTileControlAffinity.leading,
            value: isChecked,
            checkColor: Colors.white,
            activeColor: Theme.of(context).primaryColor,
            onChanged: (bool? value) {
              setState(() {
                isChecked = value!;
              });
            }),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop(isChecked);
            },
            child: const Text('เข้าใจแล้ว'))
      ],
    );
  }
}
