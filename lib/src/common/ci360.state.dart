import 'package:cloudimage_360_view/src/common/ci360.options.dart';
import 'package:cloudimage_360_view/src/constants/index.dart';
import 'package:flutter/foundation.dart';

/// This State Internal Use Only

class Ci360State {
  Ci360State(
    this.options,
    this.onResetTimer,
    this.onResumeTimer,
    this.changeMode,
    this.onRotateImage,
  );

  /// The [Ci360Options] to create this state
  Ci360Options options;

  /// The initial index of the [Images] on [Ci360View] init.
  ///
  int initialIndex = 0;

  /// The images count that should be shown at 360 view
  int? imagesLength;

  /// Current Image Index
  int currentIndex = 0;

  int senstivity = 1;

  int rotationCompleted = 0;

  double localPosition = 0.0;

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

  Function(int index) onRotateImage;
}
