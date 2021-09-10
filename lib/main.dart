import 'dart:math';
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:fork/dial.dart';
import 'package:fork/fft.dart';
import 'package:sound_stream/sound_stream.dart';

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

  RecorderStream _recorder = RecorderStream();

  List<Uint8List> _micChunks = [];
  bool _isRecording = false;

  late StreamSubscription _recorderStatus;
  late StreamSubscription _audioStream;

  callback(newBackgroundColor) {
    setState(() {
      backgroundColor = newBackgroundColor;
    });
  }

  @override
  void initState() {
    super.initState();
    initPlugin();
  }

  @override
  void dispose() {
    _recorderStatus.cancel();
    _audioStream.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlugin() async {
    _recorderStatus = _recorder.status.listen((status) {
      if (mounted)
        setState(() {
          _isRecording = status == SoundStreamStatus.Playing;
        });
    });

    _audioStream = _recorder.audioStream.listen((data) {
      _micChunks.add(data);
      var dataFT = fft(data);
      // print('FT');
      // print(dataFT);
      // print(dataFT.length);
      // print(data.length);
      // print("");
    });

    await Future.wait([
      _recorder.initialize()
    ]);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    double mainWidth = min(min(200, width), height);

    _recorder.start();

    return Scaffold(
      body: Container(
        color: Colors.blueGrey,
        child: Stack(
          children: [
            Center(
              child: Container(
                width: mainWidth,
                height: mainWidth,
                child: Center(
                  child: Dial(callback)
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text("Here " + this._isRecording.toString())
            ),
          ]
        ),
      ),
    );
  }
}