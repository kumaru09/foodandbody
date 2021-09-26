import 'package:flutter/material.dart';
import 'package:foodandbody/screens/menu/menu.dart';

// ignore: must_be_immutable
class MenuCardWidget extends StatelessWidget {
  MenuCardWidget({Key? key}) : super(key: key);
  late List<MenuCardInfo> menu = getMenuInfo();

  List<MenuCardInfo> getMenuInfo() {
    //query menu image, menu name, calories
    return [
      MenuCardInfo(
          "https://www.haveazeed.com/wp-content/uploads/2019/08/3.%E0%B8%AA%E0%B9%89%E0%B8%A1%E0%B8%95%E0%B8%B3%E0%B9%84%E0%B8%97%E0%B8%A2%E0%B9%84%E0%B8%82%E0%B9%88%E0%B9%80%E0%B8%84%E0%B9%87%E0%B8%A1-1.png",
          "ตำไทยไข่เค็ม",
          172),
      MenuCardInfo("https://dilafashionshop.files.wordpress.com/2019/03/71.jpg",
          "ข้าวกะเพราไก่ไข่ดาว", 480),
      MenuCardInfo(
          "https://img.kapook.com/u/pirawan/Cooking1/thai%20spicy%20mushrooms%20salad.jpg",
          "ยำเห็ดรวมมิตร",
          104),
      MenuCardInfo(
          "https://snpfood.com/wp-content/uploads/2020/01/Breakfast-00002-scaled-1-1536x1536.jpg",
          "ข้าวต้มปลา",
          220),
      MenuCardInfo(
          "https://snpfood.com/wp-content/uploads/2020/01/Highlight-Menu-0059-scaled-1-1536x1536.jpg",
          "ข้าวผัดปู",
          551),
    ]; //dummy data
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
          key: const Key('menu_card_listview'),
          itemCount: menu.length,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 8),
          itemBuilder: (BuildContext context, int index) {
            return buildMenuCard(context, menu[index]);
          }),
    );
  }

  Widget buildMenuCard(BuildContext context, MenuCardInfo menu) {
    final item = menu;
    return Container(
      height: 200,
      padding: EdgeInsets.only(left: 8),
      child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 2,
          semanticContainer: true,
          child: InkWell(
            onTap: () {
              //change page
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Menu(menuName: menu.name, menuImg: item.image)));
            },
            // child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    child: Image.network(
                      item.image,
                      height: 150,
                      width: 200,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 150,
                      padding: EdgeInsets.only(left: 8, top: 8, bottom: 8),
                      child: Text(
                        item.name,
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.bodyText2!.merge(
                            TextStyle(color: Theme.of(context).colorScheme.secondary)),
                      ),
                    ),
                    Container(
                      width: 50,
                      padding: EdgeInsets.only(top: 3, right: 8, bottom: 8),
                      child: Text(
                        "${item.calories}",
                        textAlign: TextAlign.right,
                        style: Theme.of(context).textTheme.headline6!.merge(
                            TextStyle(color: Theme.of(context).colorScheme.secondary)),
                      ),
                    )
                  ],
                ),
              ],
            ),
            // ),
          )),
    );
  }
}

class MenuCardInfo {
  String image; //URL
  String name;
  int calories;

  MenuCardInfo(this.image, this.name, this.calories);
}
