import 'package:flutter/material.dart';

const horizontalSpacer = _DefaultSpacer(axis: Axis.horizontal);
const smallHorizontalSpacer = _DefaultSpacer(
  axis: Axis.horizontal,
  factor: .5,
);

const verticalSpacer = _DefaultSpacer(axis: Axis.vertical);
const smallVerticalSpacer = _DefaultSpacer(
  axis: Axis.vertical,
  factor: .5,
);

class _DefaultSpacer extends StatelessWidget {
  const _DefaultSpacer({
    required this.axis,
    this.factor = 1,
  });

  final Axis axis;
  final double factor;

  @override
  Widget build(BuildContext context) {
    final paddingValue = 16 * factor;

    return SizedBox(
      width: axis == Axis.horizontal ? paddingValue : 0,
      height: axis == Axis.vertical ? paddingValue : 0,
    );
  }
}


