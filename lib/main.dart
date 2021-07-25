import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fork',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color backgroundColor = Colors.grey;

  callback(newBackgroundColor) {
    setState(() {
      backgroundColor = newBackgroundColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    double mainWidth = min(min(200, width), height);

    return Scaffold(
      body: Container(
        color: Colors.blueGrey,
        child: Center(
          child: Container(
            width: mainWidth,
            height: mainWidth,
            child: Center(
              child: Dial(callback)
            ),
          ),
        )
      ),
    );
  }
}

class Dial extends StatefulWidget {
  final Function(Color) callback;

  Dial(this.callback);

  @override
  _DialState createState() => _DialState();
}

class _DialState extends State<Dial> {
  double inputFreq = 82.41;
  double targetFreq = 82.41;

  static const double minValue = 40;
  static const double maxValue = 440;

  static const double minAngle = 0;
  static const double maxAngle = 8 * pi;
  static const double sweepAngle = maxAngle - minAngle;

  @override
  Widget build(BuildContext context) {
    double _normalisedValue = (targetFreq - minValue) / (maxValue - minValue);
    double _angle = minAngle + _normalisedValue * sweepAngle;

    double distanceToAngle = 0.01;
  
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double mainWidth = min(min(200, width), height);

    return Container(
      width: mainWidth,
      height: mainWidth,
      child: GestureDetector(
        onVerticalDragUpdate: (DragUpdateDetails details) {
          print(details);
          double changeInY = -1.0 * details.delta.dy.abs() * details.delta.dy;
          double changeInValue = distanceToAngle * changeInY;
          double newValue = targetFreq + changeInValue;
          targetFreq = min(max(newValue, minValue), maxValue);
          _normalisedValue = (targetFreq - minValue) / (maxValue - minValue);
          _angle = minAngle + _normalisedValue * sweepAngle;
          setState(() { 
            targetFreq = targetFreq;
            _angle = _angle;
          });
        },
        child: Stack(
          children: [
            Transform.rotate(
              angle: _angle,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: mainWidth * 0.9,
                    height: mainWidth * 0.9,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Align(
                    alignment: Alignment(0, 0.8),
                    child: Container(
                      width: mainWidth * 0.1,
                      height: mainWidth * 0.1,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Text(
                targetFreq.toStringAsFixed(2),
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}