import 'package:flutter/material.dart';

class TopLabel extends StatelessWidget {
  const TopLabel({
    super.key,
    required this.data,
  });

  final String? data;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(data!, style: const TextStyle(fontSize: 18)),
      ],
    );
  }
}
