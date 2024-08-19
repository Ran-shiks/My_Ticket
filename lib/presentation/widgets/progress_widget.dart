import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class progressWidget extends StatelessWidget {
  final String progressText1;
  final String progressText2;

  const progressWidget(
      {super.key, required this.progressText1, required this.progressText2});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Center(child: CircularProgressIndicator()),
        content: Text(progressText1),
        actions: [
          TextButton(
            onPressed: () => context.router.pop(),
            child: Text(progressText2),
          )
        ]);
  }
}
