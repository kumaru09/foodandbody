import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/widget/menu_card/bloc/menu_card_bloc.dart';
import 'package:foodandbody/widget/menu_card/menu_card_item.dart';

class MenuCardList extends StatefulWidget {
  const MenuCardList({Key? key, required this.isMyFav}) : super(key: key);
  final bool isMyFav;
  @override
  _MenuCardListState createState() => _MenuCardListState();
}

class _MenuCardListState extends State<MenuCardList> {
  @override
  void initState() {
    super.initState();
    context.read<MenuCardBloc>().add(MenuCardFetched());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuCardBloc, MenuCardState>(
      builder: (context, state) {
        switch (state.status) {
          case MenuCardStatus.failure:
            return const Center(child: Text('failed to fetch menu'));
          case MenuCardStatus.success:
            if (state.menu.isEmpty) {
              return Center(child: Text('${widget.isMyFav ? "ไม่มีเมนูที่กินบ่อยในขณะนี้" : "ไม่มีเมนูยอดนิยมในขณะนี้"}'),);
            }
            return Container(
              height: 200,
              child: ListView.builder(
                key: const Key('menu_card_listview'),
                itemBuilder: (BuildContext context, int index) {
                  return MenuCardItem(menu: state.menu[index]);
                },
                itemCount: state.menu.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              ),
            );
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
