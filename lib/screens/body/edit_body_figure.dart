import 'package:flutter/material.dart';
import 'package:foodandbody/models/body.dart';
// import 'package:foodandbody/screens/body/cubit/body_cubit.dart';
// import 'package:provider/src/provider.dart';

class EditBodyFigure extends StatefulWidget {
  const EditBodyFigure({required this.body});

  final Body body;

  @override
  State<StatefulWidget> createState() => _EditBodyState();
}

class _EditBodyState extends State<EditBodyFigure> {
  late String _currentShoulder = widget.body.shoulder.toString();
  late String _currentChest = widget.body.chest.toString();
  late String _currentWaist = widget.body.waist.toString();
  late String _currentHip = widget.body.hip.toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        leading: IconButton(
          key: const Key("body_close_button"),
          onPressed: () {
            Navigator.pop(context, 'cancel');
          },
          icon: Icon(Icons.close, color: Colors.white),
        ),
        title: Text(
          "แก้ไขสัดส่วน",
          style: Theme.of(context).textTheme.headline6!.merge(
                TextStyle(color: Colors.white),
              ),
        ),
        actions: [
          TextButton(
            key: const Key("body_save_button"),
            onPressed: () async {
              Navigator.pop(context, {
                'shoulder': '${_currentShoulder=="" ? "0": _currentShoulder}',
                'chest': '${_currentChest=="" ? "0": _currentChest}',
                'waist': '${_currentWaist=="" ? "0": _currentWaist}',
                'hip': '${_currentHip=="" ? "0": _currentHip}'
              });
            },
            child: Text(
              "บันทึก",
              style: Theme.of(context).textTheme.button!.merge(
                    TextStyle(
                      color: Colors.white,
                    ),
                  ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: 4),
              TextFormField(
                key: const Key("body_edit_shoulder_text_filed"),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                initialValue: _currentShoulder,
                decoration: InputDecoration(
                    labelText: "ไหล่",
                    border: OutlineInputBorder(borderSide: BorderSide())),
                onChanged: (shoulder) => setState(() {
                  _currentShoulder = shoulder;
                }),
              ),
              SizedBox(height: 20),
              TextFormField(
                key: const Key("body_edit_chest_text_filed"),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                initialValue: _currentChest,
                decoration: InputDecoration(
                    labelText: "รอบอก",
                    border: OutlineInputBorder(borderSide: BorderSide())),
                onChanged: (chest) => setState(() {
                  _currentChest = chest;
                }),
              ),
              SizedBox(height: 20),
              TextFormField(
                key: const Key("body_edit_waist_text_filed"),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                initialValue: _currentWaist,
                decoration: InputDecoration(
                    labelText: "รอบเอว",
                    border: OutlineInputBorder(borderSide: BorderSide())),
                onChanged: (waist) => setState(() {
                  _currentWaist = waist;
                }),
              ),
              SizedBox(height: 20),
              TextFormField(
                key: const Key("body_edit_hip_text_filed"),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                initialValue: _currentHip,
                decoration: InputDecoration(
                    labelText: "รอบสะโพก",
                    border: OutlineInputBorder(borderSide: BorderSide())),
                onChanged: (hip) => setState(() {
                  _currentHip = hip;
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// class _EditShoulder extends StatefulWidget {
//   final int shoulder;
//   const _EditShoulder({required this.shoulder});

//   @override
//   __EditShoulderState createState() => __EditShoulderState();
// }

// class __EditShoulderState extends State<_EditShoulder> {
//   late String _currentShoulder = widget.shoulder.toString();

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       keyboardType: TextInputType.number,
//       textInputAction: TextInputAction.next,
//       initialValue: _currentShoulder,
//       decoration: InputDecoration(
//           labelText: "ไหล่",
//           border: OutlineInputBorder(borderSide: BorderSide())),
//       onChanged: (shoulder) => setState(() {
//         _currentShoulder = shoulder;
//       }),
//     );
//   }
// }

// class _EditChest extends StatefulWidget {
//   final int chest;
//   const _EditChest({required this.chest});

//   @override
//   __EditChestState createState() => __EditChestState();
// }

// class __EditChestState extends State<_EditChest> {
//   late String _currentChest = widget.chest.toString();

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       keyboardType: TextInputType.number,
//       textInputAction: TextInputAction.next,
//       initialValue: _currentChest,
//       decoration: InputDecoration(
//           labelText: "รอบอก",
//           border: OutlineInputBorder(borderSide: BorderSide())),
//       onChanged: (chest) => setState(() {
//         _currentChest = chest;
//       }),
//     );
//   }
// }

// class _EditWaist extends StatefulWidget {
//   final int waist;
//   const _EditWaist({required this.waist});

//   @override
//   __EditWaistState createState() => __EditWaistState();
// }

// class __EditWaistState extends State<_EditWaist> {
//   late String _currentWaist = widget.waist.toString();

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       keyboardType: TextInputType.number,
//       textInputAction: TextInputAction.next,
//       initialValue: _currentWaist,
//       decoration: InputDecoration(
//           labelText: "รอบเอว",
//           border: OutlineInputBorder(borderSide: BorderSide())),
//       onChanged: (waist) => setState(() {
//         _currentWaist = waist;
//       }),
//     );
//   }
// }

// class _EditHip extends StatefulWidget {
//   final int hip;
//   const _EditHip({required this.hip});

//   @override
//   __EditHipState createState() => __EditHipState();
// }

// class __EditHipState extends State<_EditHip> {
//   late String _currentHip = widget.hip.toString();

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       keyboardType: TextInputType.number,
//       textInputAction: TextInputAction.next,
//       initialValue: _currentHip,
//       decoration: InputDecoration(
//           labelText: "รอบสะโพก",
//           border: OutlineInputBorder(borderSide: BorderSide())),
//       onChanged: (hip) => setState(() {
//         _currentHip = hip;
//       }),
//     );
//   }
// }
