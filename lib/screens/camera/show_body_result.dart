import 'package:flutter/material.dart';

class ShowBodyResult extends StatelessWidget {
  ShowBodyResult();

  int _shoulder = 50;
  int _chest = 80;
  int _waist = 65;
  int _hip = 85;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        ListTile(
          contentPadding: EdgeInsets.only(left: 16, right: 10),
          title: Text(
            "ผลลัพธ์",
            style: Theme.of(context).textTheme.subtitle1!.merge(
                TextStyle(color: Theme.of(context).colorScheme.secondary)),
          ),
          trailing: IconButton(
            icon: Icon(Icons.expand_more,
                color: Theme.of(context).colorScheme.secondary),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          child: Divider(
            color: Color(0x21212114),
            thickness: 1,
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 16, top: 10),
          alignment: Alignment.topLeft,
          child: Text(
            "สัดส่วน",
            style: Theme.of(context).textTheme.subtitle1!.merge(
                TextStyle(color: Theme.of(context).colorScheme.secondary)),
          ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            padding: EdgeInsets.only(left: 16, top: 10),
            alignment: Alignment.topLeft,
            child: Text("ไหล่",
                style: Theme.of(context).textTheme.bodyText2!.merge(
                    TextStyle(color: Theme.of(context).colorScheme.secondary))),
          ),
          Container(
            padding: EdgeInsets.only(top: 10, right: 16),
            alignment: Alignment.topLeft,
            child: Text("$_shoulder เซนติเมตร",
                style: Theme.of(context).textTheme.bodyText2!.merge(
                    TextStyle(color: Theme.of(context).colorScheme.secondary))),
          )
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            padding: EdgeInsets.only(left: 16, top: 10),
            alignment: Alignment.topLeft,
            child: Text("รอบอก",
                style: Theme.of(context).textTheme.bodyText2!.merge(
                    TextStyle(color: Theme.of(context).colorScheme.secondary))),
          ),
          Container(
            padding: EdgeInsets.only(top: 10, right: 16),
            alignment: Alignment.topLeft,
            child: Text("$_chest เซนติเมตร",
                style: Theme.of(context).textTheme.bodyText2!.merge(
                    TextStyle(color: Theme.of(context).colorScheme.secondary))),
          )
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            padding: EdgeInsets.only(left: 16, top: 10),
            alignment: Alignment.topLeft,
            child: Text("รอบเอว",
                style: Theme.of(context).textTheme.bodyText2!.merge(
                    TextStyle(color: Theme.of(context).colorScheme.secondary))),
          ),
          Container(
            padding: EdgeInsets.only(top: 10, right: 16),
            alignment: Alignment.topLeft,
            child: Text("$_waist เซนติเมตร",
                style: Theme.of(context).textTheme.bodyText2!.merge(
                    TextStyle(color: Theme.of(context).colorScheme.secondary))),
          )
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            padding: EdgeInsets.only(left: 16, top: 10),
            alignment: Alignment.topLeft,
            child: Text("รอบสะโพก",
                style: Theme.of(context).textTheme.bodyText2!.merge(
                    TextStyle(color: Theme.of(context).colorScheme.secondary))),
          ),
          Container(
            padding: EdgeInsets.only(top: 10, right: 16),
            alignment: Alignment.topLeft,
            child: Text("$_hip เซนติเมตร",
                style: Theme.of(context).textTheme.bodyText2!.merge(
                    TextStyle(color: Theme.of(context).colorScheme.secondary))),
          ),
        ]),
        _SaveButton()
      ],
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 16, bottom: 14),
      alignment: Alignment.topCenter,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            primary: Theme.of(context).primaryColor,
            fixedSize: Size(182, 39)),
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          "บันทึก",
          style: Theme.of(context).textTheme.button!.merge(
                TextStyle(color: Colors.white),
              ),
        ),
      ),
    );
  }
}
