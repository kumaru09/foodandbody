import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/models/menu.dart';
import 'package:foodandbody/repositories/plan_repository.dart';
import 'package:foodandbody/screens/menu/bloc/menu_bloc.dart';
import 'package:foodandbody/screens/menu/menu_detail.dart';
import 'package:http/http.dart' as http;

class MenuPage extends StatelessWidget {
  late String menuName;
  late bool isPlanMenu;
  late Menu menu;

  MenuPage.menu({required String menuName}) {
    this.menuName = menuName;
    this.isPlanMenu = false;
  }

  MenuPage.plan({required Menu menu}) {
    this.menu = menu;
    this.menuName = menu.name;
    this.isPlanMenu = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: Text("$menuName",
            style: Theme.of(context)
                .textTheme
                .headline6!
                .merge(TextStyle(color: Colors.white))),
        leading: IconButton(
            onPressed: () {
              // change page to setting page
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, color: Colors.white)),
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (_) =>
              MenuBloc(httpClient: http.Client(), path: this.menuName, planRepository: context.read<PlanRepository>())
                ..add(MenuFetched()),
          child: this.isPlanMenu? MenuDetail(isPlanMenu: this.isPlanMenu, item: this.menu) : MenuDetail(isPlanMenu: this.isPlanMenu),
        ),
      ),
    );
  }
}
