import 'package:flutter/material.dart';

class ExerciseCardList extends StatelessWidget {
  ExerciseCardList({Key? key}) : super(key: key);

  late List<Exercise> _exercise = [
    Exercise(exercise: "แอโรบิค", time: "30", calories: 165),
    Exercise(exercise: "วิ่ง", time: "30", calories: 240),
    Exercise(exercise: "ปั่นจักรยาน", time: "45", calories: 265)
  ];

  @override
  Widget build(BuildContext context) {
    List<Widget> _exerciseList = [];
    for (int index = 0; index < _exercise.length; index++) {
      _exerciseList.add(_buildExerciseCard(context, _exercise[index]));
    }

    return Column(
      children: _exerciseList,
    );
  }

  Widget _buildExerciseCard(BuildContext context, Exercise item) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 6,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 16, top: 16),
                  child: Text(
                    "${item.exercise}",
                    style: Theme.of(context).textTheme.subtitle1!.merge(
                          TextStyle(
                            color: Color(0xFF515070),
                          ),
                        ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 16, bottom: 16),
                  child: Text(
                    "${item.time} นาที",
                    style: Theme.of(context).textTheme.bodyText2!.merge(
                          TextStyle(
                            color: Color(0xFFA19FB9),
                          ),
                        ),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 15),
            child: Text(
              "${item.calories.round()}",
              style: Theme.of(context).textTheme.headline6!.merge(
                    TextStyle(
                      color: Color(0xFF515070),
                    ),
                  ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 16),
            child: Text(
              "แคล",
              style: Theme.of(context).textTheme.caption!.merge(
                    TextStyle(
                      color: Color(0xFF515070),
                    ),
                  ),
            ),
          )
        ],
      ),
    );
  }
}

//test class: can delete when implement complete
class Exercise {
  Exercise(
      {required this.exercise, required this.time, required this.calories});
  final String exercise;
  final String time;
  final double calories;
}
