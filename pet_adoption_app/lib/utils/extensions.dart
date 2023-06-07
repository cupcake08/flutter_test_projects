import 'dart:developer' as dev show log;

import 'package:flutter/material.dart';

extension Log on Object {
  void log([String? tag]) {
    dev.log(toString(), name: tag ?? "DEV_LOG");
  }
}

extension BuildContextX on BuildContext {
  Size get size => MediaQuery.of(this).size;
  double get width => size.width;
  double get height => size.height;
  void showSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        showCloseIcon: true,
      ),
    );
  }
}
