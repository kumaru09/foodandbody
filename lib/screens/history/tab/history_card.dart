import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HistoryCard extends StatelessWidget {
  HistoryCard(
      {Key? key,
      required this.name,
      required this.dataList,
      required this.startDate,
      required this.stopDate,
      required this.isBody})
      : super(key: key);

  final String name;
  final List<int> dataList;
  final DateTime startDate;
  final DateTime stopDate;
  final bool isBody;

  String _dateToString(DateTime date) {
    return date.day == DateTime.now().day &&
            date.month == DateTime.now().month &&
            date.year == DateTime.now().year
        ? 'วันนี้'
        : '${date.day}/${date.month}/${date.year}';
  }

  double _graphMaxY(String name) {
    return name == 'น้ำ' ? 10 : 100;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$name',
              style: Theme.of(context).textTheme.headline6!.merge(
                  TextStyle(color: Theme.of(context).colorScheme.secondary)),
            ),
            if (isBody && dataList.length >= 2)
              Row(
                key: Key('historyCard_compare_body'),
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(
                      dataList[0] - dataList[1] > 0
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      color: Theme.of(context).colorScheme.secondary,
                      size: 40),
                  Text(
                    '${(dataList[0] - dataList[1]).abs()} ',
                    style: Theme.of(context).textTheme.headline5!.merge(
                        TextStyle(
                            color: Theme.of(context).colorScheme.secondary)),
                  ),
                  Text(
                    '${name == 'น้ำหนัก' ? 'กิโลกรัม' : 'เซนติเมตร'}',
                    style: Theme.of(context).textTheme.bodyText2!.merge(
                        TextStyle(
                            color: Theme.of(context).colorScheme.secondary)),
                  ),
                ],
              ),
            if (isBody && dataList.length >= 2)
              Center(
                child: Text(
                  'เทียบกับครั้งก่อนหน้า',
                  style: Theme.of(context).textTheme.bodyText1!.merge(TextStyle(
                      color: Theme.of(context).colorScheme.secondary)),
                ),
              ),
            Container(
              width: double.infinity,
              height: 100,
              padding: EdgeInsets.symmetric(vertical: 5),
              child: _LineChart(dataList, _graphMaxY(name)),
            ),
            const Divider(
              color: Color(0xFF515070),
              height: 2,
              thickness: 1.5,
            ),
            SizedBox(height: 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (dataList.length >= 2)
                  Expanded(
                    child: Text(
                      '${_dateToString(startDate)}',
                      key: Key('historyCard_startDate'),
                      style: Theme.of(context).textTheme.bodyText2!.merge(
                          TextStyle(
                              color: Theme.of(context).colorScheme.secondary)),
                    ),
                  ),
                Text(
                  '${_dateToString(stopDate)}',
                  key: Key('historyCard_stopDate'),
                  style: Theme.of(context).textTheme.bodyText2!.merge(TextStyle(
                      color: Theme.of(context).colorScheme.secondary)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _LineChart extends StatelessWidget {
  _LineChart(this.data, this.maxY);

  List<int> data;
  double maxY;

  @override
  Widget build(BuildContext context) {
    return LineChart(LineChartData(
        minX: 1,
        maxX:
            data.length <= 1 || data.length > 10 ? 10 : data.length.toDouble(),
        minY: 0, //(data.reduce(min) - 1).toDouble()
        maxY: data.reduce(max) + 1 < maxY
            ? maxY
            : (data.reduce(max) + 1).toDouble(),
        axisTitleData: FlAxisTitleData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
        lineTouchData: lineTouchData,
        lineBarsData: _getDataPoint()));
  }

  List<LineChartBarData> _getDataPoint() {
    final List<FlSpot> dataPoint = [];

    if (data.length <= 1) {
      for (int index = 1; index <= 10; index++) {
        dataPoint.add(FlSpot(index.toDouble(), data[0].toDouble()));
      }
    } else {
      List<int> yData = data.length > 10 ? data.sublist(0, 10) : data;
      for (int index = yData.length; index > 0; index--) {
        dataPoint.add(
            FlSpot(index.toDouble(), yData[yData.length - index].toDouble()));
      }
    }

    return [
      LineChartBarData(
          colors: [Color(0xFF515070)],
          spots: dataPoint,
          isCurved: false,
          dotData: FlDotData(show: false))
    ];
  }

  LineTouchData get lineTouchData => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Color(0xFF515070),
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                return LineTooltipItem(
                  '${toRound(barSpot.y)}',
                  const TextStyle(
                    color: Colors.white,
                  ),
                );
              }).toList();
            }),
      );

  String toRound(double value) {
    if (value - value.toInt() == 0.0 ||
        value - value.toInt() < 0.01 ||
        value - value.toInt() >= 0.99)
      return value.toInt().toString();
    else
      return value.toStringAsFixed(2);
  }
}
