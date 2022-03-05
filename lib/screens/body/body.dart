import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/screens/body/body_figure_info.dart';
import 'package:foodandbody/screens/body/cubit/body_cubit.dart';
import 'package:foodandbody/screens/body/weight_and_height_info.dart';
import 'package:foodandbody/screens/setting/bloc/info_bloc.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  Widget _failureWidget(BuildContext context, String state) {
    return Center(
      child: Column(
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
            onPressed: () => state == 'body'
                ? context.read<BodyCubit>().fetchBody()
                : context.read<InfoBloc>().add(LoadInfo()),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        body: BlocBuilder<BodyCubit, BodyState>(builder: (context, bodyState) {
          switch (bodyState.status) {
            case BodyStatus.success:
              return BlocBuilder<InfoBloc, InfoState>(
                  builder: (context, infoState) {
                switch (infoState.status) {
                  case InfoStatus.success:
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 15),
                              constraints: BoxConstraints(minHeight: 100),
                              width: MediaQuery.of(context).size.width,
                              child: WeightAndHeightInfo(
                                  infoState.info!, bodyState.weightList)),
                          Container(
                            padding: EdgeInsets.only(left: 16, top: 16),
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              "สัดส่วน",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .merge(TextStyle(
                                      color: Theme.of(context).primaryColor)),
                            ),
                          ),
                          Container(
                              padding: EdgeInsets.only(
                                  left: 16, top: 8, right: 15, bottom: 100),
                              width: MediaQuery.of(context).size.width,
                              child: BodyFigureInfo(bodyState.body))
                        ],
                      ),
                    );
                  case InfoStatus.failure:
                    return _failureWidget(context, 'info');
                  default:
                    return Center(child: CircularProgressIndicator());
                }
              });
            case BodyStatus.failure:
              return _failureWidget(context, 'body');
            default:
              return Center(child: CircularProgressIndicator());
          }
        }));
  }
}
