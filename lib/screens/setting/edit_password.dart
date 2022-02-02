import 'package:flutter/material.dart';

class EditPassword extends StatefulWidget {
  const EditPassword({Key? key}) : super(key: key);

  @override
  _EditPasswordState createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {}, icon: Icon(Icons.done, color: Colors.white))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 4),
              TextFormField(
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    labelText: "รหัสผ่านเดิม",
                    border: OutlineInputBorder(borderSide: BorderSide())),
                // onChanged: () {},
              ),
              SizedBox(height: 20),
              TextFormField(
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    labelText: "รหัสผ่านใหม่",
                    border: OutlineInputBorder(borderSide: BorderSide())),
                // onChanged: () {},
              ),
              SizedBox(height: 20),
              TextFormField(
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    labelText: "ยืนยันรหัสผ่านใหม่",
                    border: OutlineInputBorder(borderSide: BorderSide())),
                // onChanged: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
