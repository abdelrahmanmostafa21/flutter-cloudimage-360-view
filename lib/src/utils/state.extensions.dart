import 'dart:async';

import 'package:flutter/material.dart';

extension SafeSetStateExtension on State {
  FutureOr<void> safeSetState(FutureOr<dynamic> Function() fn) async {
    await fn();
    if (mounted) {
      // ignore: invalid_use_of_protected_member
      setState(() {});
    }
  }
}
