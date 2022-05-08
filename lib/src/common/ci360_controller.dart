import 'dart:async';

import 'package:cloudimage_360_view/src/common/ci360_state.dart';
import 'package:cloudimage_360_view/src/constants/index.dart';
import 'package:flutter/material.dart';

abstract class Ci360Controller {
  late Completer readyCompleter;
  Ci360State? get state;
  set state(Ci360State? state);

  bool get ready;
  Future<void> get onReady;

  Future<void> nextImage({Duration? duration, Curve? curve, Axis axis = Axis.horizontal});
  Future<void> previousImage({Duration? duration, Curve? curve, Axis axis = Axis.horizontal});
  void rotateToImage(int index, [Axis axis = Axis.horizontal]);

  void startAutoPlay();
  void stopAutoPlay();
}

class Ci360ControllerImpl implements Ci360Controller {
  @override
  Completer readyCompleter = Completer();

  Ci360State? _state;

  @override
  Ci360State? get state => _state;

  @override
  set state(Ci360State? state) {
    _state = state;
    if (!readyCompleter.isCompleted) {
      readyCompleter.complete();
    }
  }

  void _setModeController() => _state!.changeMode(CIImageChangedReason.controller);

  @override
  bool get ready => _state != null;
  @override
  Future<void> get onReady => readyCompleter.future;

  /// The ImageView will only autoPlay if the autoPlay parameter
  /// in Ci360Options is true.
  @override
  void startAutoPlay() {
    _state!.onResumeTimer();
  }

  /// This is a more on-demand way of doing this. Use the autoPlay
  /// parameter in Ci360Options to specify the autoPlay behaviour of the ImageView.
  @override
  void stopAutoPlay() {
    _state!.onResetTimer();
  }

  @override
  void rotateToImage(int index, [Axis axis = Axis.horizontal]) {
    final _length = _state?.imageModelForAxis?.imagesLength ?? 0;
    final _index = index <= _length && index > 0 ? index : 1;
    _setModeController();
    _state
      ?..onResetTimer()
      ..onRotateImage.call(_index, axis)
      ..onResumeTimer();
  }

  @override
  Future<void> nextImage({
    Duration? duration,
    Curve? curve,
    Axis axis = Axis.horizontal,
  }) async {
    final _index = (_state?.indexForAxis ?? -1) + 1;
    _setModeController();
    _state
      ?..onResetTimer()
      ..onRotateImage.call(_index, axis)
      ..onResumeTimer();
  }

  @override
  Future<void> previousImage({
    Duration? duration,
    Curve? curve,
    Axis axis = Axis.horizontal,
  }) async {
    final _index = (_state?.indexForAxis ?? 2) - 1;
    _setModeController();
    _state
      ?..onResetTimer()
      ..onRotateImage.call(_index, axis)
      ..onResumeTimer();
  }
}
