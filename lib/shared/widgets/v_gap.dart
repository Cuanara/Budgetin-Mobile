import 'package:flutter/material.dart';
import '../../core/utils/responsive.dart';

class VGap extends StatelessWidget {
  const VGap(this.height, {super.key});

  final double height;

  @override
  Widget build(BuildContext context) =>
      SizedBox(height: context.vGap(height));
}