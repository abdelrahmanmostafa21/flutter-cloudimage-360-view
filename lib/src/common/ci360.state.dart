import 'dart:async';
import 'dart:math' as math;

import 'package:cloudimage_360_view/src/common/ci360.options.dart';
import 'package:cloudimage_360_view/src/constants/index.dart';
import 'package:cloudimage_360_view/src/models/index.dart';
import 'package:flutter/rendering.dart';

/// This State Internal Use Only

class Ci360State {
  Ci360State(
    this.loading,
    this.options,
    this.onResetTimer,
    this.onResumeTimer,
    this.changeMode,
    this.onRotateImage,
  );

  bool loading;

  /// The [Ci360Options] to create this state
  Ci360Options options;

  /// The images count that should be shown at 360 view on X-Axis
  Ci360ImageModel? xImageModel;

  /// The images count that should be shown at 360 view on Y-Axis
  Ci360ImageModel? yImageModel;

  /// Current Image Index on X-Axis
  int currentXIndex = 1;

  /// Current Image Index on Y-Axis
  int currentYIndex = 1;

  /// Current Rotaion Axis
  Axis currentAxis = Axis.horizontal;

  // mode is related to why the page is being changed
  CIImageChangedReason currentMode = CIImageChangedReason.controller;

  ///Completed Rotaions For AutoRotate
  /// To Check The RotationCount
  /// While Auto Rotate Enabled
  int rotationXCompleted = 0;
  int rotationYCompleted = 0;

  /// Last X Position
  double localXPosition = 0.0;

  /// Last Y Position
  double localYPosition = 0.0;

  //Timer Used To Autoplay
  Timer? timer;

  /// Will be called when using to go to next image or
  /// previous image. It will clear the autoPlay timer.
  /// Internal use only
  VoidCallback onResetTimer;

  /// Will be called when using to go to next image or
  /// previous image. It will restart the autoPlay timer.
  /// Internal use only
  VoidCallback onResumeTimer;

  /// The callback to set the Reason Carousel changed
  Function(CIImageChangedReason) changeMode;

  Function(int index, Axis axis) onRotateImage;
}

extension Ci360StateExtension on Ci360State {
  int get indexForAxis => currentAxis == Axis.horizontal ? currentXIndex : currentYIndex;

  Ci360ImageModel? get imageModelForAxis =>
      currentAxis == Axis.horizontal ? xImageModel : yImageModel;

  ImageProvider? get currentImageProvider =>
      imageModelForAxis?.imageProviders[indexForAxis > 0 ? indexForAxis - 1 : indexForAxis + 1];

  bool get infiniteRotate => options.rotationCount <= 0;

  bool get canAutoRotate =>
      options.autoRotate &&
      (infiniteRotate ||
          canAutoRotateOnAxis(Axis.horizontal) ||
          canAutoRotateOnAxis(Axis.vertical));

  bool canAutoRotateOnAxis(Axis axis) {
    switch (axis) {
      case Axis.horizontal:
        return infiniteRotate
            ? xImageModel != null
            : rotationXCompleted < options.rotationCount && xImageModel != null;
      case Axis.vertical:
        return infiniteRotate
            ? yImageModel != null
            : rotationYCompleted < options.rotationCount && yImageModel != null;
    }
  }

  bool rotaionDoneOnAxis(Axis axis) {
    switch (axis) {
      case Axis.horizontal:
        return infiniteRotate
            ? rotationXCompleted == 1
            : rotationXCompleted >= options.rotationCount;
      case Axis.vertical:
        return infiniteRotate
            ? rotationYCompleted == 1
            : rotationYCompleted >= options.rotationCount;
    }
  }

  void invalidateInfiniteRotate([bool force = false]) {
    if (infiniteRotate || force) {
      rotationXCompleted = 0;
      rotationYCompleted = 0;
      currentXIndex = 1;
      currentYIndex = 1;
    }
  }

  void onImageChanged() => options.onImageChanged?.call(indexForAxis, currentMode, currentAxis);

  double position(int length) => math.pow(4, (6 - options.swipeSensitivity)) / length;
}
