import 'package:flutter/material.dart';
import 'package:foodandbody/models/menu_list.dart';
import 'package:foodandbody/screens/menu/menu.dart';
import 'package:foodandbody/widget/menu_card/menu_card.dart';
import 'package:search_page/search_page.dart';

class Search extends StatelessWidget {
  const Search({Key? key}) : super(key: key);

  static List<MenuList> menu = [
    MenuList(
        name: 'กุ้งเผา',
        calory: 96,
        imageUrl: 'https://bnn.blob.core.windows.net/food/grilled-shrimp.jpg'),
    MenuList(
        name: 'กุ้งอบวุ้นเส้น',
        calory: 96,
        imageUrl: 'https://bnn.blob.core.windows.net/food/grilled-shrimp.jpg'),
    MenuList(
        name: 'กุ้งต้ม',
        calory: 96,
        imageUrl: 'https://bnn.blob.core.windows.net/food/grilled-shrimp.jpg'),
    MenuList(
        name: 'กุ้งทอด',
        calory: 96,
        imageUrl: 'https://bnn.blob.core.windows.net/food/grilled-shrimp.jpg'),
    MenuList(
        name: 'กุ้งสด',
        calory: 96,
        imageUrl: 'https://bnn.blob.core.windows.net/food/grilled-shrimp.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: Text("เมนู",
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
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () => showSearch(
              context: context,
              delegate: SearchPage<MenuList>(
                items: menu,
                searchLabel: 'ค้นหาเมนู',
                barTheme: ThemeData(
                  primaryColor: Theme.of(context).colorScheme.onPrimary,
                  colorScheme: Theme.of(context).colorScheme,
                ),
                searchStyle: Theme.of(context).textTheme.subtitle1,
                suggestion: Center(
                  child: Text('Filter people by name, surname or age',
                      style: Theme.of(context).textTheme.subtitle1!.merge(
                          TextStyle(
                              color: Theme.of(context).colorScheme.secondary))),
                ),
                failure: Center(
                  child: Text('ไม่พบเมนูนี้',
                      style: Theme.of(context).textTheme.subtitle1!.merge(
                          TextStyle(
                              color: Theme.of(context).colorScheme.secondary))),
                ),
                filter: (menu) => [
                  menu.name,
                  menu.calory.toString(),
                ],
                builder: (menu) => Column(
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MenuPage.menu(
                                    menuName: menu.name)));
                      },
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(menu.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .merge(TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary))),
                          ),
                          Text('${menu.calory} ',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .merge(TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary))),
                          Text('แคล',
                              style: Theme.of(context).textTheme.caption!.merge(
                                  TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary))),
                        ],
                      ),
                      // trailing:
                    ),
                    const Divider(
                      height: 2,
                      thickness: 1,
                      // indent: 0,
                      // endIndent: 0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                "เมนูแนะนำ",
                style: Theme.of(context).textTheme.bodyText1!.merge(
                      TextStyle(color: Theme.of(context).primaryColor),
                    ),
              ),
            ),
            MenuCard(path: '/api/menu'),
            Container(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                "เมนูยอดนิยม",
                style: Theme.of(context).textTheme.bodyText1!.merge(
                      TextStyle(color: Theme.of(context).primaryColor),
                    ),
              ),
            ),
            MenuCard(path: '/api/menu'),
            Container(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                "เมนูที่กินบ่อย",
                style: Theme.of(context).textTheme.bodyText1!.merge(
                      TextStyle(color: Theme.of(context).primaryColor),
                    ),
              ),
            ),
            MenuCard(path: '/api/menu'),
          ],
        ),
      ),
    );
  }
}
