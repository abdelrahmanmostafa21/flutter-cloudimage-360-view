// ignore_for_file: unnecessary_this

import 'dart:async';
import 'dart:math' as math;

import 'package:cloudimage_360_view/src/common/index.dart';
import 'package:cloudimage_360_view/src/constants/index.dart';
import 'package:flutter/material.dart';

class Ci360View extends StatefulWidget {
  Ci360View(
    this.imageList, {
    required this.options,
    Ci360Controller? controller,
    Key? key,
  })  : _controller = controller ?? Ci360ControllerImpl(),
        super(key: key);

  // List of ImageProviders used to generate the 360 image effect.
  final List<ImageProvider> imageList;

  /// [Ci360Options] to create a [Ci360State] with
  final Ci360Options options;

  /// A [Ci360Controller], used to control the ImageView logic.
  final Ci360Controller _controller;

  @override
  State<Ci360View> createState() => _Ci360ViewState();
}

class _Ci360ViewState extends State<Ci360View> {
  ///Widget Variables
  List<ImageProvider> get _imageProvides => widget.imageList;
  Ci360Controller get _controller => widget._controller;
  Ci360Options get _options => widget.options;

  ///Initialized Variables
  ///
  late Ci360State state;
  //Timer Used To Autoplay
  Timer? timer;
  // mode is related to why the page is being changed
  var mode = CIImageChangedReason.controller;

  @override
  void initState() {
    super.initState();

    //Init Ci360ImageView State
    state = Ci360State(
      _options,
      clearTimer,
      resumeTimer,
      changeMode,
      rotateImage,
    )..imagesLength = _imageProvides.length;

    //Set Controller State
    _controller.state = state;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onHorizontalDragEnd: (details) {
            state.localPosition = 0.0;
          },
          onHorizontalDragUpdate: (details) {
            // Swipe check,if allowed than only will image move
            if (_options.allowSwipeToRotate) {
              if (details.delta.dx > 0) {
                handleRightSwipe(details);
              } else if (details.delta.dx < 0) {
                handleLeftSwipe(details);
              }
            }
          },
          child: Image(
            image: widget.imageList[state.currentIndex],
            gaplessPlayback: true,
          ),
        ),
      ],
    );
  }

  ///Functionallity
  ///

  //****************************************Gestures********************************************** */

  void handleRightSwipe(DragUpdateDetails details) {
    final originalindex = state.currentIndex;
    final pos =
        state.localPosition + (math.pow(4, (6 - state.senstivity)) / (_imageProvides.length));
    if (pos <= details.localPosition.dx) {
      state.currentIndex += 1;
      state.localPosition = details.localPosition.dx;
    }
    // Check to ignore rebuild of widget is index is same
    if (originalindex != state.currentIndex) {
      setState(() {
        if (state.currentIndex < _imageProvides.length - 1) {
          state.currentIndex = state.currentIndex;
        } else {
          state.currentIndex = 0;
        }
      });
      changeMode(CIImageChangedReason.interactive);
      _options.onImageChanged?.call((state.currentIndex), mode);
    }
  }

  void handleLeftSwipe(DragUpdateDetails details) {
    double distancedifference = (details.localPosition.dx - state.localPosition);
    final originalindex = state.currentIndex;
    if (distancedifference < 0) {
      distancedifference = (-distancedifference);
    }
    final pos = math.pow(4, (6 - state.senstivity)) / (_imageProvides.length);
    if (distancedifference >= pos) {
      state.currentIndex += 1;
      state.localPosition = details.localPosition.dx;
    }
    // Check to ignore rebuild of widget is index is same
    if (originalindex != state.currentIndex) {
      setState(() {
        if (state.currentIndex > 0) {
          state.currentIndex = state.currentIndex;
        } else {
          state.currentIndex = _imageProvides.length - 1;
        }
      });
      changeMode(CIImageChangedReason.interactive);
      _options.onImageChanged?.call((state.currentIndex), mode);
    }
  }

  //****************************************Rotation Logic********************************************** */

  ///Rotate Image Logic
  void rotateImage(int index) async {
    // Check for rotationCount
    if ((state.rotationCompleted >= _options.rotationCount) || !mounted) {
      return;
    }
    setState(() {
      final length = state.imagesLength ?? _imageProvides.length;
      if (_options.rotationDirection == CIRotationDirection.anticlockwise) {
        // Logic to bring the frame to initial position on cycle complete in positive direction
        if (index < length - 1) {
          state.currentIndex++;
        } else {
          state.rotationCompleted++;
          state.currentIndex = 0;
        }
      } else {
        // Logic to bring the frame to initial position on cycle complete in negative direction
        if (index > 0) {
          state.currentIndex--;
        } else {
          state.rotationCompleted++;
          state.currentIndex = length - 1;
        }
      }
    });

    _options.onImageChanged?.call((state.currentIndex), mode);
    //Recursive call
    rotateImage(state.currentIndex);
  }

  //***********************************Timer******************************************** */

  ///Resume Timer
  void resumeTimer() => timer ??= lookupTimer();

  ///Invalidate Timer
  void clearTimer() {
    if (timer != null) {
      timer?.cancel();
      timer = null;
    }
  }

  ///Lookup for current timer with state
  Timer? lookupTimer() {
    if (!_options.autoRotate) {
      return null;
    }
    // Frame change duration logic
    return Timer.periodic(
      _options.frameChangeDuration,
      (_) {
        final route = ModalRoute.of(context);
        if (route?.isCurrent == false) {
          return;
        }
        final previousReason = mode;
        changeMode(CIImageChangedReason.timer);
        var nextIndex = state.currentIndex;
        final itemCount = state.imagesLength ?? _imageProvides.length;
        if (nextIndex >= itemCount) {
          clearTimer();
          return;
        }
        state.onRotateImage.call(nextIndex);
        changeMode(previousReason);
      },
    );
  }

  //**********************************Helpers***************************************************** */

  //Change Mode Reason
  void changeMode(CIImageChangedReason _mode) => mode = _mode;
}
