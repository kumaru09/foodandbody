import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/screens/body/cubit/body_cubit.dart';
import 'package:foodandbody/screens/main_screen/main_screen.dart';
import 'package:formz/formz.dart';

class EditBodyFigure extends StatefulWidget {
  const EditBodyFigure({
    required this.shoulder,
    required this.chest,
    required this.waist,
    required this.hip,
  });

  final int shoulder;
  final int chest;
  final int waist;
  final int hip;

  @override
  State<StatefulWidget> createState() => _EditBodyState();
}

class _EditBodyState extends State<EditBodyFigure> {
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
          BlocBuilder<BodyCubit, BodyState>(
              buildWhen: (previous, current) =>
                  previous.editBodyStatus != current.editBodyStatus,
              builder: (context, state) {
                return TextButton(
                  key: const Key("body_save_button"),
                  onPressed: state.editBodyStatus.isValidated
                      ? () async {
                          context.read<BodyCubit>().updateBody();
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => MainScreen(index: 2)),
                              (Route<dynamic> route) => route.isFirst);
                        }
                      : null,
                  child: Text("บันทึก"),
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    onSurface: Theme.of(context).primaryColor, // Disable color
                  ),
                );
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: 4),
              _ShoulderInput(widget.shoulder.toString()),
              SizedBox(height: 20),
              _ChestInput(widget.chest.toString()),
              SizedBox(height: 20),
              _WaistInput(widget.waist.toString()),
              SizedBox(height: 20),
              _HipInput(widget.hip.toString()),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShoulderInput extends StatelessWidget {
  const _ShoulderInput(this._shoulder);
  final String _shoulder;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BodyCubit, BodyState>(
        buildWhen: (previous, current) => previous.shoulder != current.shoulder,
        builder: (context, state) {
          return TextFormField(
            key: const Key("body_edit_shoulder_text_filed"),
            onChanged: (shoulder) =>
                context.read<BodyCubit>().shoulderChanged(shoulder),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            initialValue: _shoulder,
            decoration: InputDecoration(
              labelText: 'ไหล่',
              border: OutlineInputBorder(borderSide: BorderSide()),
              errorText:
                  state.shoulder.invalid ? 'กรุณาระบุน้ำหนักให้ถูกต้อง' : null,
            ),
          );
        });
  }
}

class _ChestInput extends StatelessWidget {
  const _ChestInput(this._chest);
  final String _chest;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BodyCubit, BodyState>(
        buildWhen: (previous, current) => previous.chest != current.chest,
        builder: (context, state) {
          return TextFormField(
            key: const Key("body_edit_chest_text_filed"),
            onChanged: (chest) => context.read<BodyCubit>().chestChanged(chest),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            initialValue: _chest,
            decoration: InputDecoration(
              labelText: 'รอบอก',
              border: OutlineInputBorder(borderSide: BorderSide()),
              errorText:
                  state.chest.invalid ? 'กรุณาระบุน้ำหนักให้ถูกต้อง' : null,
            ),
          );
        });
  }
}

class _WaistInput extends StatelessWidget {
  const _WaistInput(this._waist);
  final String _waist;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BodyCubit, BodyState>(
        buildWhen: (previous, current) => previous.waist != current.waist,
        builder: (context, state) {
          return TextFormField(
            key: const Key("body_edit_waist_text_filed"),
            onChanged: (waist) => context.read<BodyCubit>().waistChanged(waist),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            initialValue: _waist,
            decoration: InputDecoration(
              labelText: 'รอบเอว',
              border: OutlineInputBorder(borderSide: BorderSide()),
              errorText:
                  state.waist.invalid ? 'กรุณาระบุน้ำหนักให้ถูกต้อง' : null,
            ),
          );
        });
  }
}

class _HipInput extends StatelessWidget {
  const _HipInput(this._hip);
  final String _hip;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BodyCubit, BodyState>(
        buildWhen: (previous, current) => previous.hip != current.hip,
        builder: (context, state) {
          return TextFormField(
            key: const Key("body_edit_hip_text_filed"),
            onChanged: (hip) => context.read<BodyCubit>().hipChanged(hip),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            initialValue: _hip,
            decoration: InputDecoration(
              labelText: 'รอบสะโพก',
              border: OutlineInputBorder(borderSide: BorderSide()),
              errorText:
                  state.hip.invalid ? 'กรุณาระบุน้ำหนักให้ถูกต้อง' : null,
            ),
          );
        });
  }
}