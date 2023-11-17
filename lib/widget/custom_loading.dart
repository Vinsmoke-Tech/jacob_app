import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CustomLoading extends StatelessWidget {
  const CustomLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: LoadingAnimationWidget.discreteCircle(
            color:  Color(0xffFCE183),
            size: 50,
            secondRingColor: Color(0xffF749A2),
            thirdRingColor: Color(0xffF68D7F),
        ),
      ),
    );
  }
}
