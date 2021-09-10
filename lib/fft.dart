
import 'dart:math';
import 'dart:typed_data';

import 'package:complex/complex.dart';

List<Complex> fft(Uint8List x) {
  int len = x.length;
  if (!isPowerOf2(len)) {
    var nearestPower = (log(len) / log(2)).floor();
    x = x.sublist(nearestPower);
    List<double> xConverted = x.buffer.asFloat32List();
    var xcp = xConverted.map((double d) => new Complex(d)).toList();
    return xcp;
  }

  List<double> xConverted = x.buffer.asFloat32List();

  var xcp = xConverted.map((double d) => new Complex(d)).toList();
  return _transform(xcp, xcp.length, 1);
}

List<Complex> _transform(List<Complex> x, int length, int step) {
  if (length == 1) return x;

  int halfLength = length ~/ 2;
  
  List<Complex> firstHalf = _transform(x.sublist(0, halfLength), halfLength, step * 2);
  List<Complex> secondHalf = _transform(x.sublist(halfLength), halfLength, step * 2);

  List<Complex> results = List<Complex>.filled(halfLength, Complex(0));

  for (var k = 0; k < halfLength; k++) {
    var p = firstHalf[k];
    var q = secondHalf[k] * Complex.polar(1, ( -2 * pi * k ) / length);
    results[k] = p + q;
  }

  return results;
}

bool isPowerOf2(int i) {
  if (i == 1) return true;
  if (i % 2 == 1) return false;
  return isPowerOf2(i ~/ 2);
}