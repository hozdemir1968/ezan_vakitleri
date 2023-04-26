import 'package:flutter/material.dart';

class TimeLabel extends StatelessWidget {
  const TimeLabel({
    super.key,
    required this.label,
    required this.time,
  });

  final String? label;
  final String? time;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$label', style: const TextStyle(fontSize: 18)),
          Text('$time', style: const TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}
