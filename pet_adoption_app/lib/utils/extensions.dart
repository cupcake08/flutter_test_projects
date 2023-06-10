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
        backgroundColor: Theme.of(this).colorScheme.inversePrimary,
        margin: const EdgeInsets.all(8),
        behavior: SnackBarBehavior.floating,
        content: Text(
          message,
          style: Theme.of(this).textTheme.bodyMedium,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        showCloseIcon: true,
        duration: 1.s,
        closeIconColor: Theme.of(this).colorScheme.primary,
      ),
    );
  }
}

extension DurationX on num {
  Duration get ms => Duration(milliseconds: toInt());
  Duration get s => Duration(seconds: toInt());
  Duration get m => Duration(minutes: toInt());
  Duration get h => Duration(hours: toInt());
  Duration get days => Duration(days: toInt());
  Duration get weeks => Duration(days: toInt() * 7);
  Duration get months => Duration(days: toInt() * 30);
  Duration get years => Duration(days: toInt() * 365);
}
