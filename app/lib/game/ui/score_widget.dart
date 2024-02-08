import 'score_controller.dart';
import 'package:flutter/material.dart';

class ProgressBarWidget extends StatelessWidget {
  const ProgressBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = ProgressBarController();
    return Material(
      type: MaterialType.transparency,
      child: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          return Padding(
            padding: const EdgeInsets.only(left: 40, top: 40),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      '${(controller.goals).toInt()} 🔥     ${(controller.enemies).toInt()} 👹',
                      style: const TextStyle(
                          color: Colors.yellowAccent, fontSize: 20),
                    )
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
