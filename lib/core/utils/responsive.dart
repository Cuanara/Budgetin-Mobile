import 'package:flutter/material.dart';

extension ResponsiveContext on BuildContext {
  /// 1.0 di layar tinggi (>= 800dp), mengecil sampai 0.7 di layar pendek.
  double get vScale =>
      (MediaQuery.sizeOf(this).height / 800).clamp(0.7, 1.0).toDouble();

  double vGap(double value) => value * vScale;
}