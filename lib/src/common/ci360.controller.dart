import 'dart:async';

import 'package:flutter/material.dart';

import 'package:cloudimage_360_view/src/common/ci360.state.dart';
import 'package:cloudimage_360_view/src/constants/index.dart';

abstract class Ci360Controller {
  late Completer readyCompleter;
  set state(Ci360State? state);

  bool get ready;
  Future<void> get onReady;

  Future<void> nextImage({Duration? duration, Curve? curve});
  Future<void> previousImage({Duration? duration, Curve? curve});
  void rotateToImage(int index);

  void startAutoPlay();
  void stopAutoPlay();
}

class Ci360ControllerImpl implements Ci360Controller {


  @override
  Completer readyCompleter = Completer();

  Ci360State? _state;

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

  /// The ImageView will only autoPlay if the [autoPlay] parameter
  /// in [Ci360Options] is true.
  @override
  void startAutoPlay() {
    _state!.onResumeTimer();
  }

  /// This is a more on-demand way of doing this. Use the [autoPlay]
  /// parameter in [Ci360Options] to specify the autoPlay behaviour of the ImageView.
  @override
  void stopAutoPlay() {
    _state!.onResetTimer();
  }

  @override
  void rotateToImage(int index) {
    final _index = index < (_state?.imagesLength ?? 0) && index > -1 ? index : 0;
    _setModeController();
    _state
      ?..onResetTimer()
      ..onRotateImage.call(_index)
      ..onResumeTimer();
  }

  @override
  Future<void> nextImage({Duration? duration, Curve? curve}) async {
    final _index = (_state?.currentIndex ?? -1) + 1;
    _setModeController();
    _state
      ?..onResetTimer()
      ..onRotateImage.call(_index)
      ..onResumeTimer();
  }

  @override
  Future<void> previousImage({Duration? duration, Curve? curve}) async {
    final _index = (_state?.currentIndex ?? 1) - 1;
    _setModeController();
    _state
      ?..onResetTimer()
      ..onRotateImage.call(_index)
      ..onResumeTimer();
  }
}
