import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/models/body_predict.dart';
import 'package:foodandbody/repositories/body_repository.dart';
import 'package:foodandbody/repositories/user_repository.dart';
import 'package:foodandbody/screens/body/cubit/body_cubit.dart';
import 'package:foodandbody/screens/body/edit_body_figure.dart';
import 'package:foodandbody/screens/camera/bloc/camera_bloc.dart';
import 'package:foodandbody/screens/main_screen/main_screen.dart';
import 'package:loader_overlay/loader_overlay.dart';

class ShowBodyResult extends StatelessWidget {
  ShowBodyResult({required this.results});

  final BodyPredict results;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CameraBloc, CameraState>(
        listener: (context, state) {
          if (state.status == CameraStatus.success) {
            context.loaderOverlay.hide();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => MainScreen(index: 2)),
                (Route<dynamic> route) => route.isFirst);
          } else if (state.status == CameraStatus.failure) {
            context.loaderOverlay.hide();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                    content:
                        Text('บันทึกข้อมูลไม่สำเร็จ กรุณาลองใหม่อีกครั้ง')),
              );
          }
        },
        child: LoaderOverlay(
            child: Wrap(
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
                        TextStyle(
                            color: Theme.of(context).colorScheme.secondary))),
              ),
              Container(
                padding: EdgeInsets.only(top: 10, right: 16),
                alignment: Alignment.topLeft,
                child: Text("${results.shoulder} เซนติเมตร",
                    style: Theme.of(context).textTheme.bodyText2!.merge(
                        TextStyle(
                            color: Theme.of(context).colorScheme.secondary))),
              )
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(
                padding: EdgeInsets.only(left: 16, top: 10),
                alignment: Alignment.topLeft,
                child: Text("รอบอก",
                    style: Theme.of(context).textTheme.bodyText2!.merge(
                        TextStyle(
                            color: Theme.of(context).colorScheme.secondary))),
              ),
              Container(
                padding: EdgeInsets.only(top: 10, right: 16),
                alignment: Alignment.topLeft,
                child: Text("${results.chest} เซนติเมตร",
                    style: Theme.of(context).textTheme.bodyText2!.merge(
                        TextStyle(
                            color: Theme.of(context).colorScheme.secondary))),
              )
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(
                padding: EdgeInsets.only(left: 16, top: 10),
                alignment: Alignment.topLeft,
                child: Text("รอบเอว",
                    style: Theme.of(context).textTheme.bodyText2!.merge(
                        TextStyle(
                            color: Theme.of(context).colorScheme.secondary))),
              ),
              Container(
                padding: EdgeInsets.only(top: 10, right: 16),
                alignment: Alignment.topLeft,
                child: Text("${results.waist} เซนติเมตร",
                    style: Theme.of(context).textTheme.bodyText2!.merge(
                        TextStyle(
                            color: Theme.of(context).colorScheme.secondary))),
              )
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(
                padding: EdgeInsets.only(left: 16, top: 10),
                alignment: Alignment.topLeft,
                child: Text("รอบสะโพก",
                    style: Theme.of(context).textTheme.bodyText2!.merge(
                        TextStyle(
                            color: Theme.of(context).colorScheme.secondary))),
              ),
              Container(
                padding: EdgeInsets.only(top: 10, right: 16),
                alignment: Alignment.topLeft,
                child: Text("${results.hip} เซนติเมตร",
                    style: Theme.of(context).textTheme.bodyText2!.merge(
                        TextStyle(
                            color: Theme.of(context).colorScheme.secondary))),
              ),
            ]),
            Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        key: const Key('body_camera_edit_button'),
                        child: Text('แก้ไข'),
                        style: OutlinedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                        ),
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider<BodyCubit>(
                                create: (_) => BodyCubit(
                                    bodyRepository:
                                        context.read<BodyRepository>(),
                                    userRepository:
                                        context.read<UserRepository>())
                                  ..initBodyFigure(
                                      shoulder: results.shoulder.toString(),
                                      chest: results.chest.toString(),
                                      waist: results.waist.toString(),
                                      hip: results.hip.toString()),
                                child: EditBodyFigure(
                                  shoulder: results.shoulder,
                                  chest: results.chest,
                                  waist: results.waist,
                                  hip: results.hip,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: ElevatedButton(
                        key: const Key('body_camera_save_elevatedButton'),
                        child: Text('บันทึก'),
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                        ),
                        onPressed: () {
                          context.loaderOverlay.show();
                          context
                              .read<CameraBloc>()
                              .add(AddBodyCamera(bodyPredict: results));
                        },
                      ),
                    )
                  ],
                ))
          ],
        )));
  }
}
