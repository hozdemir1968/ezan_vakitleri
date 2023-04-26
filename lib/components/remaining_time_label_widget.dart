import 'package:flutter/material.dart';

class RemainingTimeLabel extends StatelessWidget {
  const RemainingTimeLabel({
    super.key,
    required this.isVisible,
    required this.label,
    required this.remainingTime,
  });

  final bool isVisible;
  final String label;
  final String remainingTime;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$label $remainingTime', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
