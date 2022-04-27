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
            'กล้องจะทำการถ่ายรูป 2 ครั้ง เมื่อกดถ่ายรูปจะทำการนับเวลาถอยหลัง 5 วิ ในการถ่ายแต่ละรูป',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            'ผู้ใช้จะต้องยืนหันหน้าเข้าหากล้องในรูปที่หนึ่ง และยืนหันข้างในที่รูปสอง',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            'ในการถ่ายรูปโดยควรวางกล้องให้สามารถถ่ายเห็นทั้งตัว และยืนให้พอดีกับกรอบสีชมพูที่แสดงบนหน้าจอ',
            style: TextStyle(fontSize: 16),
          ),
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
            'ผู้ใช้จะต้องขยับกล้องขึ้นด้านบนของอาหาร และขยับลง 45 องศา ถ่ายด้านข้างของอาหาร ตามรูปที่แสดงด้านล่าง',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            height: 8,
          ),
          Row(children: [
            Expanded(
                child: Image(
              image: AssetImage('assets/food_help1.jpg'),
              fit: BoxFit.contain,
            )),
            SizedBox(
              width: 8,
            ),
            Expanded(
                child: Image(
              image: AssetImage('assets/food_help2.jpg'),
              fit: BoxFit.contain,
            ))
          ]),
          SizedBox(
            height: 8,
          ),
          Text(
            'จนกว่าจะปรากฏจุดสีเขียวขึ้นบนหน้าจอเพียงพอ กล้องจะแนะนำผู้ใช้ขยับกล้องให้ขนานกับอาหาร โดยขยับให้ตัวเลขเข้าใกล้ 0 หรือ 180 จนกว่ากล้องจะขึ้นพร้อมสำหรับถ่ายรูปตามรูปที่แสดงด้านล่าง',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            height: 8,
          ),
          Row(children: [
            Expanded(
                child: Image(
              image: AssetImage('assets/food_help3.jpg'),
              fit: BoxFit.contain,
            )),
            SizedBox(
              width: 8,
            ),
            Expanded(
                child: Image(
              image: AssetImage('assets/food_help4.jpg'),
              fit: BoxFit.contain,
            ))
          ]),
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
