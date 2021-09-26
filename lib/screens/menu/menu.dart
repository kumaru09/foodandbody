import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key, required this.menuName, required this.menuImg})
      : super(key: key);
  final String menuName;
  final String menuImg;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: Text("$menuName",
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
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  Image.network(
                    menuImg,
                    alignment: Alignment.center,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text('แคลอรีรวม',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5!
                                      .merge(TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary))),
                            ),
                            Text('765 แคล',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5!
                                    .merge(TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary))),
                          ],
                        ),
                        SizedBox(height: 16.0),
                        _NutrientDetial(label: 'โปรตีน', value: '27.5'),
                        SizedBox(height: 7.0),
                        _NutrientDetial(label: 'คาร์โบไฮเดรต', value: '89.1'),
                        SizedBox(height: 7.0),
                        _NutrientDetial(label: 'ไขมัน', value: '32.3'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: _AddToPlanButton(),
            ),
          ],
        ),
      ),
    );
  }
}

class _NutrientDetial extends StatelessWidget {
  const _NutrientDetial({Key? key, required this.label, required this.value})
      : super(key: key);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text('$label',
              style: Theme.of(context).textTheme.bodyText2!.merge(
                  TextStyle(color: Theme.of(context).colorScheme.secondary))),
        ),
        Text('$value แคล',
            style: Theme.of(context).textTheme.bodyText2!.merge(
                TextStyle(color: Theme.of(context).colorScheme.secondary))),
      ],
    );
  }
}

class _AddToPlanButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        key: const Key('initialInfoForm_continue_raisedButton'),
        onPressed: () {},
        child: Text('เพิ่มในแผนการกิน'),
        style: OutlinedButton.styleFrom(
          primary: Theme.of(context).primaryColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50))),
        ),
      ),
    );
  }
}
