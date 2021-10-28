import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/repositories/menu_card_repository.dart';
import 'package:foodandbody/widget/menu_card/bloc/menu_card_bloc.dart';
import 'package:foodandbody/widget/menu_card/menu_card_list.dart';

class MenuCard extends StatelessWidget {
  const MenuCard({Key? key, required this.isMyFav}) : super(key: key);
  final bool isMyFav;
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
              minHeight: 100, minWidth: double.infinity),
      child: BlocProvider(
        create: (_) => MenuCardBloc(
          isMyFav: this.isMyFav,
          menuCardRepository: context.read<MenuCardRepository>(),
        )..add(MenuCardFetched()),
        child: MenuCardList(isMyFav: this.isMyFav),
      ),
    );
  }
}
