import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/models/menu_card.dart';
import 'package:foodandbody/widget/menu_card/bloc/menu_card_bloc.dart';
import 'package:foodandbody/widget/menu_card/menu_card_item.dart';

class MenuCardList extends StatefulWidget {
  @override
  _MenuCardListState createState() => _MenuCardListState();
}

class _MenuCardListState extends State<MenuCardList> {
  final _scrollController = ScrollController();
  late Future<MenuCard> futureMenuCard;

  @override
  void initState() {
    super.initState();
    // _scrollController.addListener(_onScroll);
    // futureMenuCard = fetchMenuCard();
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
              return const Center(child: Text('no menu'));
            }
            return Container(
              height: 200,
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return index >= state.menu.length
                      ? const Center(child: CircularProgressIndicator())
                      : MenuCardItem(menu: state.menu[index]);
                },
                itemCount: 5,
                // itemCount: state.menu.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 8),
                // itemCount: state.hasReachedMax
                //     ? state.menu.length
                //     : state.menu.length + 1,
                // controller: _scrollController,
              ),
            );
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  // @override
  // void dispose() {
  //   _scrollController
  //     ..removeListener(_onScroll)
  //     ..dispose();
  //   super.dispose();
  // }

  // void _onScroll() {
  //   if (_isBottom) context.read<MenuCardBloc>().add(MenuCardFetched());
  // }

  // bool get _isBottom {
  //   if (!_scrollController.hasClients) return false;
  //   final maxScroll = _scrollController.position.maxScrollExtent;
  //   final currentScroll = _scrollController.offset;
  //   return currentScroll >= (maxScroll * 0.9);
  // }
}
