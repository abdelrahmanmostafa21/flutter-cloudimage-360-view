import 'dart:async';

import 'package:cloudimage_360_view/src/common/index.dart';
import 'package:cloudimage_360_view/src/constants/index.dart';
import 'package:cloudimage_360_view/src/models/index.dart';
import 'package:cloudimage_360_view/src/utils/index.dart';
import 'package:flutter/material.dart';

class Ci360View extends StatefulWidget {
  Ci360View({
    required this.options,
    this.xImageModel,
    this.yImageModel,
    this.loadingIndicator,
    Ci360Controller? controller,
    Key? key,
  })  : _controller = controller ?? Ci360ControllerImpl(),
        assert(
          xImageModel != null || yImageModel != null,
          'No Provided Image Models For Any Axis [X|Y]',
        ),
        super(key: key);

  final Ci360ImageModel? xImageModel;
  final Ci360ImageModel? yImageModel;

  /// [Ci360Options] to create a [Ci360State] with
  final Ci360Options options;

  /// A [Ci360Controller], used to control the ImageView logic.
  final Ci360Controller _controller;

  final Widget? loadingIndicator;

  @override
  State<Ci360View> createState() => _Ci360ViewState();
}

class _Ci360ViewState extends State<Ci360View> {
  ///Initialized Variables
  ///
  late Ci360State state;

  @override
  void initState() {
    super.initState();
    //Init Ci360ImageView State
    state = Ci360State(
      true,
      widget.options,
      clearTimer,
      resumeTimer,
      changeMode,
      rotateImage,
    )
      ..xImageModel = widget.xImageModel
      ..yImageModel = widget.yImageModel;

    //Set Controller State
    widget._controller.state = state;

    handleAutoRotate();
  }

  @override
  void didUpdateWidget(covariant Ci360View oldWidget) {
    if (oldWidget.options != state.options ||
        oldWidget.xImageModel != widget.xImageModel ||
        oldWidget.yImageModel != widget.yImageModel) {
      state
        ..options = widget.options
        ..xImageModel = widget.xImageModel
        ..yImageModel = widget.yImageModel
        ..invalidateInfiniteRotate(true);
      handleAutoRotate();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    precacheImages(context);
    super.didChangeDependencies();
  }

  void onVerticalDragEnd(DragEndDetails details) {
    state.localYPosition = 0.0;
    handleAutoRotate();
  }

  void onHorizontalDragEnd(DragEndDetails details) {
    state.localXPosition = 0.0;
    handleAutoRotate();
  }

  void onVerticalDragUpdate(DragUpdateDetails details) {
    if (!state.options.allowSwipeToRotate || state.yImageModel == null) {
      return;
    }
    state.currentAxis = Axis.vertical;
    state.currentXIndex = 1;
    if (state.options.autoRotate) {
      clearTimer();
    }
    if (details.delta.dy > 0) {
      handleDownSwipe(details);
    } else if (details.delta.dy < 0) {
      handleTopSwipe(details);
    }
  }

  void onHorizontalDragUpdate(DragUpdateDetails details) {
    if (!state.options.allowSwipeToRotate || state.xImageModel == null) {
      return;
    }
    state.currentAxis = Axis.horizontal;
    state.currentYIndex = 1;
    if (state.options.autoRotate) {
      clearTimer();
    }
    if (details.delta.dx > 0) {
      handleRightSwipe(details);
    } else if (details.delta.dx < 0) {
      handleLeftSwipe(details);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: onVerticalDragEnd,
      onHorizontalDragEnd: onHorizontalDragEnd,
      onVerticalDragUpdate: onVerticalDragUpdate,
      onHorizontalDragUpdate: onHorizontalDragUpdate,
      child: Builder(
        builder: (context) {
          if (state.loading) {
            return widget.loadingIndicator ?? const Center(child: CircularProgressIndicator());
          }

          final provider = state.currentImageProvider;
          assert(provider != null,
              'image at index ${state.indexForAxis} for axis ${state.currentAxis} not found');

          return Image(
            loadingBuilder: (_, child, progress) {
              if (progress == null) return child;
              return widget.loadingIndicator ?? const Center(child: CircularProgressIndicator());
            },
            image: provider!,
            gaplessPlayback: true,
          );
        },
      ),
    );
  }

  ///Functionallity
  ///

  //**************************************** Gestures ********************************************** */

  void handleRightSwipe(DragUpdateDetails details) {
    final xLength = state.xImageModel?.imagesLength ?? 0;
    if (xLength < 1) {
      return;
    }
    final originalindex = state.currentXIndex;
    final pos = state.localXPosition + state.position(xLength);

    if (pos <= details.localPosition.dx) {
      state.currentXIndex -= 1;
      state.localXPosition = details.localPosition.dx;
    }
    // Check to ignore rebuild of widget is index is same
    if (originalindex != state.currentXIndex) {
      safeSetState(() {
        if (state.currentXIndex < 1) {
          state.currentXIndex = xLength;
        }
      });
      changeMode(CIImageChangedReason.interactive);
      state.onImageChanged();
    }
  }

  void handleLeftSwipe(DragUpdateDetails details) {
    final xLength = state.xImageModel?.imagesLength ?? 0;
    if (xLength < 1) {
      return;
    }
    final originalindex = state.currentXIndex;

    final pos = state.position(xLength);

    double distancedifference = (details.localPosition.dx - state.localXPosition);
    if (distancedifference < 0) {
      distancedifference = (-distancedifference);
    }

    if (distancedifference >= pos) {
      state.currentXIndex += 1;
      state.localXPosition = details.localPosition.dx;
    }
    // Check to ignore rebuild of widget is index is same
    if (originalindex != state.currentXIndex) {
      safeSetState(() {
        if (state.currentXIndex > xLength) {
          state.currentXIndex = 1;
        }
      });
      changeMode(CIImageChangedReason.interactive);
      state.onImageChanged();
    }
  }

  void handleTopSwipe(DragUpdateDetails details) {
    final yLength = state.yImageModel?.imagesLength ?? 0;
    if (yLength < 1) {
      return;
    }
    double distancedifference = (details.localPosition.dy - state.localYPosition);
    final originalindex = state.currentYIndex;
    if (distancedifference < 0) {
      distancedifference = (-distancedifference);
    }
    final pos = state.position(yLength);
    if (distancedifference >= pos) {
      state.currentYIndex += 1;
      state.localYPosition = details.localPosition.dy;
    }
    // Check to ignore rebuild of widget is index is same
    if (originalindex != state.currentYIndex) {
      safeSetState(() {
        if (state.currentYIndex > yLength) {
          state.currentYIndex = 1;
        }
      });
      changeMode(CIImageChangedReason.interactive);
      state.onImageChanged();
    }
  }

  void handleDownSwipe(DragUpdateDetails details) {
    final yLength = state.yImageModel?.imagesLength ?? 0;
    if (yLength < 1) {
      return;
    }
    final originalindex = state.currentYIndex;

    final pos = state.localYPosition + state.position(yLength);
    if (pos <= details.localPosition.dy) {
      state.currentYIndex -= 1;
      state.localYPosition = details.localPosition.dy;
    }
    // Check to ignore rebuild of widget is index is same
    if (originalindex != state.currentYIndex) {
      safeSetState(() {
        if (state.currentYIndex < 1) {
          state.currentYIndex = yLength;
        }
      });
      changeMode(CIImageChangedReason.interactive);
      state.onImageChanged();
    }
  }

  //**************************************** Rotation Logic ********************************************** */

  void autoRotateImage(int index, [Axis axis = Axis.horizontal]) {
    final diffAxis = axis == Axis.horizontal ? Axis.vertical : Axis.horizontal;
    if (!state.canAutoRotate) {
      clearTimer();
      return;
    }
    if (state.rotaionDoneOnAxis(axis) && !state.rotaionDoneOnAxis(diffAxis)) {
      if (state.canAutoRotateOnAxis(diffAxis)) {
        state.invalidateInfiniteRotate();
        state.currentAxis = diffAxis;
        resumeTimer();
      }
      return;
    }
    rotateImage(index, axis);
  }

  ///Rotate Image Logic
  void rotateImage(int index, [Axis axis = Axis.horizontal]) {
    // Check for rotationCount
    safeSetState(() {
      switch (axis) {
        case Axis.horizontal:
          final length = state.xImageModel?.imagesLength ?? 0;
          if (length <= 0) {
            return;
          }
          if (state.options.rotationDirection == CIRotationDirection.clockwise) {
            // Logic to bring the frame to initial position on cycle complete in positive direction
            if (index < length) {
              state.currentXIndex++;
            } else {
              state.rotationXCompleted++;
              state.currentXIndex = 1;
            }
          } else {
            // Logic to bring the frame to initial position on cycle complete in negative direction
            if (index > 0) {
              state.currentXIndex--;
            } else {
              state.rotationXCompleted++;
              state.currentXIndex = length;
            }
          }
          break;
        case Axis.vertical:
          final length = state.yImageModel?.imagesLength ?? 0;
          if (length <= 0) {
            return;
          }
          if (state.options.rotationDirection == CIRotationDirection.clockwise) {
            // Logic to bring the frame to initial position on cycle complete in positive direction
            if (index < length) {
              state.currentYIndex++;
            } else {
              state.rotationYCompleted++;
              state.currentYIndex = 1;
            }
          } else {
            // Logic to bring the frame to initial position on cycle complete in negative direction
            if (index > 0) {
              state.currentYIndex--;
            } else {
              state.rotationYCompleted++;
              state.currentYIndex = length;
            }
          }
          break;
        default:
          break;
      }
    });
    state.onImageChanged();
  }

  //********************************** Timers & Auto Rotate ******************************************** */

  ///Check The Auto Rotate Option
  void handleAutoRotate() {
    if (state.options.autoRotate) {
      resumeTimer();
    }
  }

  ///Resume Timer
  void resumeTimer() => state.timer ??= lookupTimer();

  ///Invalidate Timer
  void clearTimer() {
    if (state.timer != null) {
      state.timer?.cancel();
      state.timer = null;
    }
  }

  ///Lookup for current timer with state
  Timer? lookupTimer() {
    if (!state.options.autoRotate) {
      return null;
    }
    // Frame change duration logic
    return Timer.periodic(
      state.options.frameChangeDuration,
      (_) {
        if (mounted) {
          final route = ModalRoute.of(context);
          if (route?.isCurrent == false) {
            return;
          }
        }

        final previousReason = state.currentMode;
        changeMode(CIImageChangedReason.timer);
        changeMode(previousReason);
        autoRotateImage(state.indexForAxis, state.currentAxis);
      },
    );
  }

  //********************************** Helpers ***************************************************** */

  void precacheImages(BuildContext context) {
    Future.wait([
      if (state.xImageModel != null && state.xImageModel!.imageProviders.isNotEmpty)
        for (var i = 0; i < state.xImageModel!.imageProviders.length; i++)
          precacheImage(state.xImageModel!.imageProviders[i], context),
      if (state.yImageModel != null && state.yImageModel!.imageProviders.isNotEmpty)
        for (var i = 0; i < state.yImageModel!.imageProviders.length; i++)
          precacheImage(state.yImageModel!.imageProviders[i], context),
    ]).then((_) => toggleLoading());
  }

  void toggleLoading() => safeSetState(
        () {
          state.loading = !state.loading;
        },
      );

  ///Change Mode Reason [CIImageChangedReason]
  void changeMode(CIImageChangedReason _mode) => state.currentMode = _mode;
}
