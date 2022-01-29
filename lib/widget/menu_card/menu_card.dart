import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/widget/menu_card/bloc/menu_card_bloc.dart';
import 'package:foodandbody/widget/menu_card/menu_card_item.dart';

class MenuCard extends StatelessWidget {
  const MenuCard({Key? key, required this.isMyFav}) : super(key: key);
  final bool isMyFav;
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 100, minWidth: double.infinity),
      child: BlocBuilder<MenuCardBloc, MenuCardState>(
        builder: (context, state) {
          switch (state.status) {
            case MenuCardStatus.failure:
              return const Center(child: Text('failed to fetch menu'));
            case MenuCardStatus.success:
              if ((!isMyFav && state.fav.isEmpty) ||
                  (isMyFav && state.myFav.isEmpty)) {
                return Center(
                  child: Text(
                      '${isMyFav ? "ไม่มีเมนูที่กินบ่อยในขณะนี้" : "ไม่มีเมนูยอดนิยมในขณะนี้"}',
                      style: Theme.of(context).textTheme.subtitle1!.merge(
                          TextStyle(color: Theme.of(context).primaryColor))),
                );
              } else {
                final menu = isMyFav ? state.myFav: state.fav ;
                return Container(
                  height: 200,
                  child: ListView.builder(
                    key: const Key('menu_card_listview'),
                    itemBuilder: (BuildContext context, int index) {
                      return MenuCardItem(menu: menu[index]);
                    },
                    itemCount: menu.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  ),
                );
              }
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
