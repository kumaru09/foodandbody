import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

import 'package:foodandbody/models/body.dart';
import 'package:foodandbody/models/weight_list.dart';

class WeightGraph extends StatelessWidget {
  WeightGraph(this.weightList);

  final List<WeightList> weightList;
  static const int NUMBER_OF_DATE = 10;
  late List<int> weight = weightList.map((e) => e.weight).toList();
  // [];
  // [50, 51, 52, 49, 50, 49, 48];
  // [50, 51, 52, 49, 50, 52, 51, 50, 50, 48];

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

class _LineChart extends StatelessWidget {
  _LineChart({required this.weight});

  List<int> weight;

  @override
  Widget build(BuildContext context) {
    bool isEmpty = weight.length == 0;

    if (isEmpty)
      weight = List<int>.generate(10, (int index) => 0);
    else if (weight.length < 10) {
      for (int index = 0; index < 10 - weight.length; index++) {
        weight.insert(index, 0);
      }
    }

    return LineChart(LineChartData(
        minX: 1,
        maxX: 10,
        minY: isEmpty ? 0 : (weight.reduce(min) - 1).toDouble(),
        maxY: isEmpty ? 10 : (weight.reduce(max) + 1).toDouble(),
        axisTitleData: FlAxisTitleData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
        lineBarsData: _getDataPoint()));
  }

  List<LineChartBarData> _getDataPoint() {
    final List<FlSpot> weightPoint = [];

    for (int index = 0; index < weight.length; index++) {
      weightPoint.add(FlSpot((index + 1).toDouble(), weight[index].toDouble()));
    }

    return [
      LineChartBarData(
          colors: [Color(0xFF515070)],
          spots: weightPoint,
          isCurved: false,
          dotData: FlDotData(show: false))
    ];
  }
}
