import 'package:cloudimage_360_view/src/constants/index.dart';
import 'package:flutter/material.dart';

class Ci360Options {
  Ci360Options({
    this.autoRotate = false,
    this.allowSwipeToRotate = true,
    this.rotationCount = 1,
    this.swipeSensitivity = 3,
    this.frameChangeDuration = kShortDuration,
    this.rotationDirection = CIRotationDirection.clockwise,
    this.onImageChanged,
  });

  /// By default false. If set to true, the images will be displayed in incremented manner.
  final bool autoRotate;

  /// By default true. If set to false, the gestures to rotate the image will be disabed.
  final bool allowSwipeToRotate;

  /// By default 1. The number of cycles the whole image rotation should take place.
  /// If you want to be infinite rotation, set this to 0
  final int rotationCount;

  /// By default 3. Based on the value the sensitivity of swipe gesture increases and decreases proportionally
  /// 1 means slow .... then increases speed +1
  final int swipeSensitivity;

  /// By default Duration(milliseconds: 80). The time interval between shifting from one image frame to other.
  final Duration frameChangeDuration;

  /// By default RotationDirection.clockwise. Based on the value the direction of rotation is set.
  final CIRotationDirection rotationDirection;

  /// Callback function to provide you the index of current image when image frame is changed.
  final Function(int index, CIImageChangedReason reason, Axis axis)? onImageChanged;

  ///Generate new [Ci360Options] based on old ones.
  Ci360Options copyWith({
    bool? autoRotate,
    bool? allowSwipeToRotate,
    int? rotationCount,
    int? swipeSensitivity,
    Duration? frameChangeDuration,
    CIRotationDirection? rotationDirection,
    Function(int index, CIImageChangedReason reason, Axis axis)? onImageChanged,
  }) {
    return Ci360Options(
      autoRotate: autoRotate ?? this.autoRotate,
      allowSwipeToRotate: allowSwipeToRotate ?? this.allowSwipeToRotate,
      rotationCount: rotationCount ?? this.rotationCount,
      swipeSensitivity: swipeSensitivity ?? this.swipeSensitivity,
      frameChangeDuration: frameChangeDuration ?? this.frameChangeDuration,
      rotationDirection: rotationDirection ?? this.rotationDirection,
      onImageChanged: onImageChanged ?? this.onImageChanged,
    );
  }
}
