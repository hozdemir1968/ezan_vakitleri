import 'package:flutter/material.dart';

class LabelLabelTime extends StatelessWidget {
  const LabelLabelTime({
    super.key,
    required this.label,
    required this.time,
  });

  final String? label;
  final String? time;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    MainAxisAlignment thisAlignment;
    size.width < 750
        ? thisAlignment = MainAxisAlignment.spaceBetween
        : thisAlignment = MainAxisAlignment.spaceAround;

    return Container(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: thisAlignment,
        children: [
          Text('$label', style: const TextStyle(fontSize: 18)),
          Text('$time', style: const TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}
