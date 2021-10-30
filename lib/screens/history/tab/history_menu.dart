import 'package:flutter/material.dart';
import 'package:foodandbody/models/history_menu.dart';

const ColorScheme _calendarColorScheme = ColorScheme(
  primary: Color(0xFFFF8E6E),
  primaryVariant: Color(0xFFc85f42),
  secondary: Color(0xFF515070),
  secondaryVariant: Color(0xFF272845),
  surface: Colors.white,
  background: Color(0xFFF6F6F6),
  error: Color(0xFFFF0000),
  onPrimary: Colors.white,
  onSecondary: Colors.white,
  onSurface: Color(0xFF515070),
  onBackground: Color(0xFF515070),
  onError: Colors.white,
  brightness: Brightness.light,
);

class HistoryMenu extends StatelessWidget {
  HistoryMenu({Key? key}) : super(key: key);

  DateTime dateToday =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  List<HistoryMenuItem> getMenuHistory() {
    return [
      HistoryMenuItem(name: 'กุ้งทอด', calory: 156),
      HistoryMenuItem(name: 'ปลาทอด', calory: 107),
      HistoryMenuItem(name: 'ปลาหมึกทอด', calory: 176),
      HistoryMenuItem(name: 'ไก่ทอด', calory: 234),
      HistoryMenuItem(name: 'หอยทอด', calory: 426),
      HistoryMenuItem(name: 'หอยทอด', calory: 426),
      HistoryMenuItem(name: 'หอยทอด', calory: 426),
      HistoryMenuItem(name: 'หอยทอด', calory: 426),
      HistoryMenuItem(name: 'หอยทอด', calory: 426),
      HistoryMenuItem(name: 'หอยทอด', calory: 426),
      HistoryMenuItem(name: 'หอยทอด', calory: 426),
      HistoryMenuItem(name: 'หอยทอดสุดท้าย', calory: 426),
    ];
  }

  _selectDate(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: dateToday,
      firstDate: DateTime(2020),
      lastDate: dateToday,
      helpText: 'เลือกวัน',
      cancelText: 'ยกเลิก',
      confirmText: 'ตกลง',
      errorFormatText: 'กรุณาระบุรูปแบบวันที่ที่ถูกต้อง',
      errorInvalidText: 'กรุณาเลือกวันที่อยู่ในช่วงที่กำหนด',
      fieldHintText: 'เดือน/วัน/ปี',
      fieldLabelText: 'วันที่',
      locale: const Locale("th", "TH"),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            colorScheme: _calendarColorScheme,
            textTheme: Theme.of(context).textTheme,
          ),
          child: child as Widget,
        );
      },
    );
    if (selected != null) print(selected);
  }

  @override
  Widget build(BuildContext context) {
    List<HistoryMenuItem> items = getMenuHistory();
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '22/02/2021',
                      style: Theme.of(context).textTheme.headline5!.merge(
                          TextStyle(
                              color: Theme.of(context).colorScheme.secondary)),
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    icon: Icon(
                      Icons.calendar_today,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    onPressed: () => _selectDate(context),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        'แคลอรีรวม',
                        style: Theme.of(context).textTheme.headline6!.merge(
                            TextStyle(
                                color:
                                    Theme.of(context).colorScheme.secondary)),
                      ),
                    ),
                    Text(
                      '700 ',
                      style: Theme.of(context).textTheme.headline6!.merge(
                          TextStyle(
                              color: Theme.of(context).colorScheme.secondary)),
                    ),
                    Text(
                      'แคล',
                      style: Theme.of(context).textTheme.caption!.merge(
                          TextStyle(
                              color: Theme.of(context).colorScheme.secondary)),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 2,
                thickness: 1,
              ),
              ListView.builder(
                itemCount: items.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return HistoryMenuDaily(item: items[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HistoryMenuDaily extends StatelessWidget {
  const HistoryMenuDaily({Key? key, required this.item}) : super(key: key);

  final HistoryMenuItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${item.name}',
                        style: Theme.of(context).textTheme.subtitle1!.merge(
                            TextStyle(
                                color:
                                    Theme.of(context).colorScheme.secondary))),
                    Text('${item.name}',
                        style: Theme.of(context).textTheme.bodyText2!.merge(
                            TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryVariant))),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${item.calory} ',
                      style: Theme.of(context).textTheme.headline6!.merge(
                          TextStyle(
                              color: Theme.of(context).colorScheme.secondary))),
                  Text('แคล',
                      style: Theme.of(context).textTheme.caption!.merge(
                          TextStyle(
                              color: Theme.of(context).colorScheme.secondary))),
                ],
              ),
            ],
          ),
        ),
        const Divider(
          height: 2,
          thickness: 1,
        ),
      ],
    );
  }
}
