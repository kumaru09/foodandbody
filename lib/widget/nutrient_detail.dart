import 'package:flutter/material.dart';

class NutrientDetail extends StatelessWidget {
  const NutrientDetail({Key? key, required this.label, required this.value})
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
        Text('$value',
            style: Theme.of(context).textTheme.bodyText2!.merge(
                TextStyle(color: Theme.of(context).colorScheme.secondary))),
      ],
    );
  }
}