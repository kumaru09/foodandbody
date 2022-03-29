import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/repositories/menu_card_repository.dart';
import 'package:foodandbody/screens/search/search.dart';
import 'package:foodandbody/widget/menu_card/bloc/menu_card_bloc.dart';
import 'package:foodandbody/widget/menu_card/menu_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: SearchPage());

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late MenuCardBloc _menuCardFavBloc;
  late MenuCardBloc _menuCardMyFavBloc;
  late MenuCardRepository _menuCardRepo;

  @override
  void initState() {
    super.initState();
    _menuCardRepo = context.read<MenuCardRepository>();
    _menuCardFavBloc = MenuCardBloc(menuCardRepository: _menuCardRepo);
    _menuCardMyFavBloc = MenuCardBloc(menuCardRepository: _menuCardRepo);
  }

  Future<void> _onRefresh() async {
    await Future.delayed(Duration(seconds: 2));
    _menuCardFavBloc.add(ReFetchedFavMenuCard(isRefresh: true));
    _menuCardMyFavBloc.add(ReFetchedMyFavMenuCard(isRefresh: true));
    setState(() {});
  }

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
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SafeArea(
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
                create: (_) => _menuCardFavBloc..add(FetchedFavMenuCard()),
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
                create: (_) => _menuCardMyFavBloc..add(FetchedMyFavMenuCard()),
                child: MenuCard(isMyFav: true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
