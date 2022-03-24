import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

import 'package:foodandbody/models/weight_list.dart';

// ignore: must_be_immutable
class WeightGraph extends StatelessWidget {
  WeightGraph(this.weightList);

  final List<WeightList> weightList;
  static const int NUMBER_OF_DATE = 10;
  late List<int> weight = weightList.map((e) => e.weight).toList();

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.45,
        height: MediaQuery.of(context).size.height * 0.1,
        padding: EdgeInsets.only(left: 16, top: 10, right: 16, bottom: 10),
        child: _LineChart(
          weight: weight,
        ));
  }
}

// ignore: must_be_immutable
class _LineChart extends StatelessWidget {
  _LineChart({required this.weight});

  List<int> weight;

  @override
  Widget build(BuildContext context) {
    bool isEmpty = weight.length == 0;

    if (isEmpty)
      weight = List<int>.generate(10, (int index) => 0);
    else if (weight.length < 10) {
      for (int index = weight.length; index < 10; index++) {
        weight.add(weight[weight.length - 1]);
      }
    }
    return LineChart(
      LineChartData(
          minX: 1,
          maxX: 10,
          minY: isEmpty ? 0 : (weight.reduce(min) - 1).toDouble(),
          maxY: isEmpty ? 10 : (weight.reduce(max) + 1).toDouble(),
          axisTitleData: FlAxisTitleData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: false),
          lineTouchData: lineTouchData,
          lineBarsData: _getDataPoint()),
      key: const Key("body_weight_graph"),
    );
  }

  List<LineChartBarData> _getDataPoint() {
    final List<FlSpot> weightPoint = [];

    for (int index = weight.length - 1; index >= 0; index--) {
      weightPoint.add(
          FlSpot((weight.length - index).toDouble(), weight[index].toDouble()));
    }

    return [
      LineChartBarData(
          colors: [Color(0xFF515070)],
          spots: weightPoint,
          isCurved: true,
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