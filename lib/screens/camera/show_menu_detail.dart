import 'package:flutter/material.dart';
import 'package:foodandbody/models/menu_show.dart';

class ShowMenuDetail extends StatelessWidget {
  const ShowMenuDetail({required this.menu});
  final MenuShow menu;
  // final MenuDetail munu;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          menu.name,
          style: Theme.of(context).textTheme.headline6!.merge(
                TextStyle(color: Colors.white),
              ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(menu.imageUrl,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.4,
                fit: BoxFit.cover),
            Container(
              padding: EdgeInsets.only(left: 16, top: 20, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "แคลอรีรวม",
                    style: Theme.of(context).textTheme.headline5!.merge(
                          TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                  ),
                  Text(
                    "${menu.calory.round()} แคล",
                    style: Theme.of(context).textTheme.headline5!.merge(
                          TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 16, top: 5, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "ปริมาณ",
                    style: Theme.of(context).textTheme.bodyText2!.merge(
                          TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                  ),
                  Text(
                    "${menu.serve.round()} กรัม",
                    style: Theme.of(context).textTheme.bodyText2!.merge(
                          TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 16, top: 5, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "โปรตีน",
                    style: Theme.of(context).textTheme.bodyText2!.merge(
                          TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                  ),
                  Text(
                    "${menu.protein} กรัม",
                    style: Theme.of(context).textTheme.bodyText2!.merge(
                          TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 16, top: 5, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "คาร์โบไฮเดรต",
                    style: Theme.of(context).textTheme.bodyText2!.merge(
                          TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                  ),
                  Text(
                    "${menu.carb} กรัม",
                    style: Theme.of(context).textTheme.bodyText2!.merge(
                          TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 16, top: 5, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "ไขมัน",
                    style: Theme.of(context).textTheme.bodyText2!.merge(
                          TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                  ),
                  Text(
                    "${menu.fat} กรัม",
                    style: Theme.of(context).textTheme.bodyText2!.merge(
                          TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
