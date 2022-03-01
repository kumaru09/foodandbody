import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/repositories/menu_card_repository.dart';
import 'package:foodandbody/screens/search/search.dart';
import 'package:foodandbody/widget/menu_card/bloc/menu_card_bloc.dart';
import 'package:foodandbody/widget/menu_card/menu_card.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: SearchPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: Text("เมนู",
            key: const Key('searchpage_appbar'),
            style: Theme.of(context)
                .textTheme
                .headline6!
                .merge(TextStyle(color: Colors.white))),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, color: Colors.white)),
        actions: [
          IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => Search()),
                  )),
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 5),
              child: Text(
                "เมนูยอดนิยม",
                style: Theme.of(context).textTheme.bodyText1!.merge(
                      TextStyle(color: Theme.of(context).primaryColor),
                    ),
              ),
            ),
            BlocProvider(
              create: (_) => MenuCardBloc(
                menuCardRepository: context.read<MenuCardRepository>(),
              )..add(FetchedFavMenuCard()),
              child: MenuCard(isMyFav: false),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 5),
              child: Text(
                "เมนูที่กินบ่อย",
                style: Theme.of(context).textTheme.bodyText1!.merge(
                      TextStyle(color: Theme.of(context).primaryColor),
                    ),
              ),
            ),
            BlocProvider(
              create: (_) => MenuCardBloc(
                menuCardRepository: context.read<MenuCardRepository>(),
              )..add(FetchedMyFavMenuCard()),
              child: MenuCard(isMyFav: true),
            ),
          ],
        ),
      ),
    );
  }
}
