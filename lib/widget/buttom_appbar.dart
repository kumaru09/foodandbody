import 'package:flutter/material.dart';

class BottomAppBarWidget extends StatefulWidget {
  final int index;
  final ValueChanged<int> onChangedTab;

  const BottomAppBarWidget({
    required this.index,
    required this.onChangedTab,
  });

  @override
  _BottomAppBarWidgetState createState() => _BottomAppBarWidgetState();
}

class _BottomAppBarWidgetState extends State<BottomAppBarWidget> {
  @override
  Widget build(BuildContext context) {
    final placeholder = Opacity(
        opacity: 0,
        child: const IconButton(onPressed: null, icon: Icon(Icons.no_cell)));

    return BottomAppBar(
      key: const Key('bottom_app_bar'),
      color: Theme.of(context).primaryColor,
      shape: CircularNotchedRectangle(),
      notchMargin: 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildTabItem(
              index: 0,
              icon: Icons.home,
              label: "หน้าหลัก",
              key: const Key('home_button')),
          buildTabItem(
              index: 1,
              icon: Icons.book,
              label: "แผน",
              key: const Key('plan_button')),
          placeholder,
          buildTabItem(
              index: 2,
              icon: Icons.accessibility,
              label: "ร่างกาย",
              key: const Key('body_button')),
          buildTabItem(
              index: 3,
              icon: Icons.calendar_today,
              label: "ประวัติ",
              key: const Key('history_button'))
        ],
      ),
    );
  }

  Widget buildTabItem(
      {required int index,
      required IconData icon,
      required String label,
      required Key key}) {
    final isSelected = index == widget.index;
    Color color = isSelected ? Colors.white : Colors.white.withOpacity(0.5);
    return Expanded(
        child: SizedBox(
      height: 56,
      child: InkWell(
        onTap: () => widget.onChangedTab(index),
        child: Column(
          key: key,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              color: color,
            ),
            Text(label,
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .merge(TextStyle(color: color)))
          ],
        ),
      ),
    ));
  }
}
