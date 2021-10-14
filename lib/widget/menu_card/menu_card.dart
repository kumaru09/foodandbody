import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/widget/menu_card/bloc/menu_card_bloc.dart';
import 'package:foodandbody/widget/menu_card/menu_card_list.dart';
import 'package:http/http.dart' as http;

class MenuCard extends StatelessWidget {
  const MenuCard ({ Key? key, required this.path }) : super(key: key);
  final String path;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocProvider(
        create: (_) => MenuCardBloc(httpClient: http.Client(), path: this.path)..add(MenuCardFetched()),
        child: MenuCardList(),
      ),
    );
  }
}