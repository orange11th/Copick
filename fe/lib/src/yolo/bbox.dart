import 'package:fe/src/models/screen_params.dart';
import 'package:flutter/material.dart';

class Bbox extends StatelessWidget {
  const Bbox({
    super.key,
    required this.box,
    required this.name,
    required this.score,
  });
  final List<double> box;
  final String name;
  final double score;

  @override
  Widget build(BuildContext context) {
    final double width = box[2] * ScreenParams.screenSize.width;
    final double height = box[3] * ScreenParams.screenSize.height;
    final double left = (box[0] * ScreenParams.screenSize.width) - (width / 2);
    final double top = (box[1] * ScreenParams.screenSize.height) - (height / 2);

    //print(name + "" + score.toString());
    // 태두리 색상을 name 값에 따라 조건부로 설정합니다.
    final Color borderColor = name == 'good' ? Colors.green : Colors.red;

    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: 1), // 조건부 색상 적용
        ),
      ),
    );
  }
}
