//
//  gizmos_hud
//
//  Copyright (c) 2020, Dave Wood.
//  All rights reserved.
//  Use of this source code is governed by a BSD-style license that can be
//  found in the LICENSE file.
//

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gizmos_hud/gizmos_hud.dart';

import 'main.dart';

/// A collection of Huds we'll use throughout our app.
// This lets us keep all of our Huds and other overlays together for easy access
// throughout our app. It also gives us simple methods to show/hide each of our
// Huds while keeping the complex customization of them in one place.
class MyCustomHuds {
  /// Internal reference to our ToastHud sample.
  final Hud _toastHud = Hud();

  /// Internal reference to our FancyToastHud sample.
  final Hud _fancyToastHud = Hud();

  /// Internal reference to our ToastHud sample.
  final Hud _confettiHud = Hud();

  /// Internal reference to our BusyHud sample.
  final Hud _busyHud = Hud();

  /// Internal reference to our Dialog sample.
  final Hud _dialog = Hud();

  /// Internal counter to ensure we match each showBusy() call with a
  /// corrosponding hideBusy() call. This lets us call showBusy() at the start
  /// of all time consuming tasks, and if any overlap, the Hud will stay visible
  /// until the last task completes.
  var _busyCount = 0;

  /// Show our ToastHud with the specified message.
  void showToast(String message) {
    if (topBuildContext == null) return;

    var mediaQuery = MediaQuery.of(topBuildContext);
    var contextWidth = mediaQuery.size.width;

    var child = Center(
        child: Text(
      message,
      style: TextStyle(
        color: Colors.white,
      ),
    ));

    _toastHud.show(
      context: topBuildContext,
      child: child,
      hudDecoration: Hud.defaultDarkHudDecoration,
      position: HudPosition.bottom,
      duration: Duration(seconds: 3),
      bottom: 90,
      width: contextWidth * 0.8,
      height: 50,
    );
  }

  /// Hide our ToastHud, with an optional [animated] fade out.
  void hideToast({bool animated = true}) {
    _toastHud.hide(animated: animated);
  }

  /// Show our FancyToastHud with the specified message.
  void showFancyToast(String message, {Icon icon, Color backgroundColor}) {
    if (topBuildContext == null) return;

    var mediaQuery = MediaQuery.of(topBuildContext);
    var contextWidth = mediaQuery.size.width;

    var iconContainer = (icon == null)
        ? SizedBox.shrink()
        : Container(
            width: 40,
            height: 40,
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            child: icon,
          );

    var child = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        iconContainer,
        Center(
          child: Text(
            message,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );

    BoxDecoration fancyHudDecoration = BoxDecoration(
      color: (backgroundColor ?? Colors.yellow[50]).withOpacity(0.75),
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(width: 2.0, color: (backgroundColor ?? Colors.yellow[50])),
    );

    _fancyToastHud.show(
      context: topBuildContext,
      child: child,
      hudDecoration: fancyHudDecoration,
      position: HudPosition.top,
      duration: Duration(seconds: 3),
      width: contextWidth * 0.8,
      height: 50,
      top: 120,
    );
  }

  /// Hide our FancyToastHud, with an optional [animated] fade out.
  void hideFancyToast({bool animated = true}) {
    _fancyToastHud.hide(animated: animated);
  }

  /// Show our Confetti overlay.
  void showConfetti() {
    if (topBuildContext == null) return;

    var mediaQuery = MediaQuery.of(topBuildContext);
    var contextWidth = mediaQuery.size.width;
    var contextHeight = mediaQuery.size.height;

    Image confetti = Image(
      image: AssetImage('assets/confetti.gif'),
      width: contextWidth,
      height: contextHeight,
      repeat: ImageRepeat.repeat,
    );

    var child = Center(child: confetti);

    _confettiHud.show(
      context: topBuildContext,
      child: child,
      position: HudPosition.center,
      duration: Duration(seconds: 3),
      width: contextWidth,
      height: contextHeight,
      isBlocking: true,
    );
  }

  /// Hide our Confetti overlay, with an optional [animated] fade out.
  void hideConfetti({bool animated = true}) {
    _confettiHud.hide(animated: animated);
  }

  /// Show our BusyHud, styled based on the current platform.
  void showBusy() {
    if (topBuildContext == null) return;

    ++_busyCount;
    var mediaQuery = MediaQuery.of(topBuildContext);
    var contextWidth = mediaQuery.size.width;

    var sideLength = contextWidth * 0.33;

    var activityIndicator = Platform.isIOS || Platform.isMacOS ? CupertinoActivityIndicator(radius: sideLength * 0.25) : CircularProgressIndicator();
    var child = Center(child: activityIndicator);

    _busyHud.show(
      context: topBuildContext,
      child: child,
      hudDecoration: Hud.defaultLightHudDecoration,
      position: HudPosition.center,
      width: sideLength,
      height: sideLength,
    );
  }

  /// Hide our BusyHud, with an optional [animated] fade out.
  void hideBusy({bool animated = true}) {
    --_busyCount;
    if (_busyCount > 0) return;
    _busyCount = 0;
    _busyHud.hide(animated: animated);
  }

  /// Hide our BusyHud, with an optional [animated] fade out, while also
  /// resetting the internal counter.
  void resetBusy({bool animated = true}) {
    _busyCount = 0;
    hideBusy(animated: animated);
  }

  /// Show our FancyToastHud with the specified message.
  void showDialog(String title, String message) {
    if (topBuildContext == null) return;

    var mediaQuery = MediaQuery.of(topBuildContext);
    var contextWidth = mediaQuery.size.width;
    var contextHeight = mediaQuery.size.height;

    var header = Text(
      title,
      style: TextStyle(fontWeight: FontWeight.bold),
      maxLines: 1,
    );
    var body = Text(
      message,
      style: TextStyle(fontWeight: FontWeight.normal),
      maxLines: 10,
    );

    BoxDecoration buttonDecoration = BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(5.0),
      border: Border.all(width: 1.0, color: Colors.blue),
    );

    var dismissButton = InkWell(
      splashColor: Colors.blue,
      onTap: () {
        hideDialog();
      },
      child: Container(
        width: 100,
        padding: EdgeInsets.all(4.0),
        decoration: buttonDecoration,
        child: Center(
          child: Text(
            'Ok',
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );

    BoxDecoration dialogDecoration = BoxDecoration(
      color: Colors.white.withOpacity(0.8),
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(width: 3.0, color: Colors.blue),
    );

    var dialogContainer = Center(
      child: Container(
        width: contextWidth * 0.8,
        padding: EdgeInsets.all(10),
        decoration: dialogDecoration,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            header,
            SizedBox(height: 10),
            body,
            SizedBox(height: 10),
            dismissButton,
          ],
        ),
      ),
    );

    _dialog.show(
      context: topBuildContext,
      child: dialogContainer,
      backgroundColor: Colors.black.withOpacity(0.5),
      position: HudPosition.center,
      isBlocking: true,
      width: contextWidth,
      height: contextHeight,
    );
  }

  /// Hide our FancyToastHud, with an optional [animated] fade out.
  void hideDialog({bool animated = true}) {
    _dialog.hide(animated: animated);
  }
}
