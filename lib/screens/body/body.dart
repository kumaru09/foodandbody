import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/app/bloc/app_bloc.dart';
import 'package:foodandbody/repositories/body_repository.dart';
import 'package:foodandbody/screens/body/body_figure_info.dart';
import 'package:foodandbody/screens/body/cubit/body_cubit.dart';
import 'package:foodandbody/screens/body/weight_and_height_info.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          title: Text("ร่างกาย",
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .merge(TextStyle(color: Theme.of(context).primaryColor))),
        ),
        body: BlocBuilder<BodyCubit, BodyState>(
            bloc: BodyCubit(context.read<BodyRepository>())..fetchBody(),
            builder: (context, state) {
              switch (state.status) {
                case BodyStatus.initial:
                  return Center(child: CircularProgressIndicator());
                case BodyStatus.loading:
                  return Center(child: CircularProgressIndicator());
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
                                context.read<AppBloc>().state.user,
                                state.body)),
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
                            child: BodyFigureInfo(state.body))
                      ],
                    ),
                  );
                case BodyStatus.failure:
                  return Center(child: CircularProgressIndicator());
              }
            }));
  }
}
