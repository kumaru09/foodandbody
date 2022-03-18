import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/screens/body/body_figure_info.dart';
import 'package:foodandbody/screens/body/cubit/body_cubit.dart';
import 'package:foodandbody/screens/body/weight_and_height_info.dart';
import 'package:formz/formz.dart';
import 'package:intl/intl.dart';

class Body extends StatelessWidget {
  Body({Key? key}) : super(key: key);

  late Timer _timer;

  Widget _failureWidget(BuildContext context) {
    return Center(
      child: Column(
        key: Key('body_failure_widget'),
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(image: AssetImage('assets/error.png')),
          SizedBox(height: 10),
          Text('ไม่สามารถโหลดข้อมูลได้ในขณะนี้',
              style: Theme.of(context).textTheme.bodyText2!.merge(
                  TextStyle(color: Theme.of(context).colorScheme.secondary))),
          OutlinedButton(
            child: Text('ลองอีกครั้ง'),
            style: OutlinedButton.styleFrom(
              primary: Theme.of(context).colorScheme.secondary,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50))),
            ),
            onPressed: () => context.read<BodyCubit>().fetchBody(),
          ),
        ],
      ),
    );
  }

  void _failUpdateWeightHeight(BuildContext context) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          _timer = Timer(Duration(seconds: 3), () {
            Navigator.of(context).pop();
          });
          return AlertDialog(
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.report,
                    color: Theme.of(context).colorScheme.secondary, size: 80),
                Text('กรอกข้อมูลไม่สำเร็จ',
                    style: Theme.of(context).textTheme.subtitle1!.merge(
                        TextStyle(
                            color: Theme.of(context).colorScheme.secondary))),
                Text('กรุณาลองอีกครั้ง',
                    style: Theme.of(context).textTheme.subtitle1!.merge(
                        TextStyle(
                            color: Theme.of(context).colorScheme.secondary))),
              ],
            ),
          );
        }).then((val) {
      if (_timer.isActive) {
        _timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BodyCubit, BodyState>(
        listener: (context, state) {
          if ((state.isWeightUpdate &&
                  state.weightStatus == FormzStatus.submissionFailure) ||
              (!state.isWeightUpdate &&
                  state.heightStatus == FormzStatus.submissionFailure)) {
            _failUpdateWeightHeight(context);
          }
        },
        child: Scaffold(
            extendBody: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Text("ร่างกาย",
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .merge(TextStyle(color: Theme.of(context).primaryColor))),
            ),
            body: BlocBuilder<BodyCubit, BodyState>(
                builder: (context, bodyState) {
              switch (bodyState.status) {
                case BodyStatus.success:
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                            padding:
                                EdgeInsets.only(left: 16, top: 16, right: 15),
                            constraints: BoxConstraints(minHeight: 100),
                            width: MediaQuery.of(context).size.width,
                            child: WeightAndHeightInfo(
                                int.parse(bodyState.height.value),
                                bodyState.weightList)),
                        Container(
                          padding: EdgeInsets.only(left: 16, top: 16),
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "สัดส่วน",
                            style: Theme.of(context).textTheme.bodyText1!.merge(
                                TextStyle(
                                    color: Theme.of(context).primaryColor)),
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.only(
                                left: 16, top: 8, right: 15, bottom: 100),
                            width: MediaQuery.of(context).size.width,
                            child: BodyFigureInfo(
                              shoulder: int.parse(bodyState.shoulder.value),
                              chest: int.parse(bodyState.chest.value),
                              waist: int.parse(bodyState.waist.value),
                              hip: int.parse(bodyState.hip.value),
                              date: bodyState.bodyDate == null
                                  ? "-"
                                  : DateFormat("dd/MM/yyyy HH:mm")
                                      .format(bodyState.bodyDate!.toDate()),
                            ))
                      ],
                    ),
                  );
                case BodyStatus.failure:
                  return _failureWidget(context);
                default:
                  return Center(child: CircularProgressIndicator());
              }
            })));
  }
}
