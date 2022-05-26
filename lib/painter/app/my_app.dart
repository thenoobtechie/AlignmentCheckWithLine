import 'dart:io';
import 'dart:math';

import 'package:alignment_helper/painter/line/line_painter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AppHome extends StatefulWidget {
  const AppHome({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AppHomeState();
}

class AppHomeState extends State<AppHome> {

  XFile? file;
  double startX = 0, startY = 0, x = 0, y = 0, direction = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTapUp: onTapUp,
        onPanUpdate: onPanUpdate,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              getImageSection(),
              getPainter(),
              const SizedBox(height: 50),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    getAngleText(),
                    const SizedBox(height: 16),
                    getButtonsRow(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double angleOf(Offset p1, Offset p2) {
    // NOTE: Remember that most math has the Y axis as positive above the X.
    // However, for screens we have Y as positive below. For this reason,
    // the Y values are inverted to get the expected results.
    final double deltaY = (p1.dy - p2.dy);
    final double deltaX = (p2.dx - p1.dx);
    final double resultInDegrees = atan2(deltaY, deltaX) * 57.2958;
    return (resultInDegrees < 0) ? (360 + resultInDegrees) : resultInDegrees;
  }

  void onPanUpdate(DragUpdateDetails details) {
    if (details.delta.dx > 0) {
      x += details.delta.dx;
    } else {
      x += details.delta.dx;
    }

    if (details.delta.dy > 0) {
      y += details.delta.dy;
    } else {
      y += details.delta.dy;
    }

    double currentAngle = angleOf(Offset(startX, startY), Offset(x, y)) % 90;

    debugPrint("Current angle: $currentAngle");

    direction = (currentAngle.floorToDouble());

    setState(() {});
  }

  void onTapUp(tD) {
    debugPrint("onTapUp, x: ${tD.globalPosition.dx}, ${tD.globalPosition.dy}");
    x = tD.globalPosition.dx;
    startX = tD.globalPosition.dx;
    y = tD.globalPosition.dy;
    startY = tD.globalPosition.dy;
    setState(() {});
  }

  Widget getPainter() =>
      SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: CustomPaint(
          painter: LinePainter(startX, startY, x, y),
        ),
      );

  Widget getAngleText() =>
      Center(child: Container(
          decoration: BoxDecoration(color: Colors.black,
              borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Text("Current angle: ${direction.toInt()}",
              style: const TextStyle(color: Colors.white))));


  Widget getPickImageButton() =>
      ElevatedButton(
        onPressed: () {
          ImagePicker().pickImage(source: ImageSource.gallery).then((value) {
            setState(() {
              file = value;
            });
          });
        },
        child: const Text("Pick image"),
      );

  Widget getResetBGButton() =>
      ElevatedButton(
        onPressed: () {
          setState(() {
            file = null;
          });
        },
        child: const Text("Reset background"),
      );

  Widget getButtonsRow() =>
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          getPickImageButton(),
          const SizedBox(width: 16),
          getResetBGButton(),
        ],
      );

  Widget getImageSection() => Center(child: Image.file(File(file?.path ?? ""),
    errorBuilder: (context, obj, stackTrace) => const Text(
        "No image selected"),));
}
