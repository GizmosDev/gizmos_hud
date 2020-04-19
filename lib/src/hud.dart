//
//  gizmos_hud
//
//  Copyright (c) 2020, Dave Wood.
//  All rights reserved.
//  Use of this source code is governed by a BSD-style license that can be
//  found in the LICENSE file.
//

/// A Flutter package for displaying custom HUDs, Toasts, Pop-Ups, Dialogs or
/// other screen overlays. Any widget can be displayed, in any position on the
/// screen for a completely customized interface.
library gizmos_hud;

import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Enum for the hud's base position.
enum HudPosition {
  top,
  center,
  bottom,
  custom,
}

/// Our main Hud class.
class Hud {
  // Constants
  /// A preset decoration that can be used Huds, dark version intended to have
  /// light content.
  static BoxDecoration defaultDarkHudDecoration = BoxDecoration(
    color: Colors.black.withOpacity(0.6),
    borderRadius: BorderRadius.circular(10.0),
  );

  /// A preset decoration that can be used Huds, light version intended to have
  /// dark content.
  static BoxDecoration defaultLightHudDecoration = BoxDecoration(
    color: Colors.black.withOpacity(0.2),
    borderRadius: BorderRadius.circular(10.0),
  );

  // Fields
  OverlayState _overlayState;
  OverlayEntry _overlayEntry;
  double _opacity = 0.0;

  // Properties
  /// Property that let's us determine if this Hud is currently visible.
  bool get isVisible => _overlayEntry != null;

  /// The duration used for built-in animations.
  Duration animationDuration = Duration(milliseconds: 300);

  /// Main method to display this [Hud]. A [context] and [child] widget are
  /// required. You can optionally set a [backgroundColor] to perhaps dim the
  /// screen behind the hud. Set a [hudColor] or [hudDecoration] to customize
  /// the background of the Hud itself. The [duration] indicates how long the
  /// Hud should be visible before it auto-hides, if you omit this, the Hud will
  /// remain on screen until you dismiss it by calling [hide()]. [isBlocking]
  /// determines whether the background of the overlay prevents user interaction
  /// with elements behind it. The Hud itself always blocks elements underneath
  /// it, meaning a fullscreen overlay will block regardless of this setting.
  /// Set the [position] parameter to a [HudPosition] value to determine where
  /// the Hud will be laid out.
  ///
  /// The value of [position] determines how the positional parameters:
  /// ([left], [top], [right], [bottom], [width], and [height]) are used.
  ///
  /// For a [position] of [HudPosition.custom], the positional parameters are
  /// passed directly to a Position Widget.
  ///
  /// For [HudPosition.top], the [top] parameter becomes the offset (defaults
  /// to 100) from the top of the context. You must also pass in either a
  /// [width] with an optional [left] or [right] value, or omit [width] and
  /// specify both [left] and [right] values. [height] is also required.
  ///
  /// For [HudPosition.bottom], the [bottom] parameter becomes the offset
  /// (defaults to 100) from the bottom of the context. You must also pass in
  /// either a [width] with an optional [left] or [right] value, or omit
  /// [width] and specify both [left] and [right] values. [height] is also
  /// required.
  ///
  /// For [HudPosition.center], [width] and [height] are required, [top],
  /// [bottom], [left], [right] should be omitted.
  Hud show({
    @required BuildContext context,
    @required Widget child,
    HudPosition position = HudPosition.custom,
    Duration duration,
    bool isBlocking = false,
    Color backgroundColor = Colors.transparent,
    Color hudColor,
    BoxDecoration hudDecoration,
    double left,
    double top,
    double right,
    double bottom,
    double width,
    double height,
  }) {
    assert(context != null, 'You must specific a valid context.');
    assert(child != null, 'You must include a child widget.');
    assert(
        hudColor == null || hudDecoration == null,
        'You can\'t specify a hudColor and hudDecoration, choose one or the '
        'other.');
    switch (position) {
      case HudPosition.top:
        assert(width != null || (left != null && right != null),
            'When using HudPosition.top, you must specify a width or both left and right parameters.');
        assert(width == null || left == null || right == null,
            'When using HudPosition.top, can\'t specify all three width, left and right values.');
        assert(
            bottom == null, 'When using HudPosition.top, bottom is not used.');
        break;
      case HudPosition.center:
        assert(
            width != null && height != null,
            'When using HudPosition.center, you must specify both a width and '
            'a height.');
        assert(top == null, 'When using HudPosition.center, top is not used.');
        assert(bottom == null,
            'When using HudPosition.center, bottom is not used.');
        assert(
            left == null, 'When using HudPosition.center, left is not used.');
        assert(
            right == null, 'When using HudPosition.center, right is not used.');
        break;
      case HudPosition.bottom:
        assert(width != null || (left != null && right != null),
            'When using HudPosition.bottom, you must specify a width or both left and right parameters.');
        assert(width == null || left == null || right == null,
            'When using HudPosition.bottom, can\'t specify all three width, left and right values.');
        assert(top == null, 'When using HudPosition.bottom, top is not used.');
        break;
      case HudPosition.custom:
        assert(left == null || right == null || width == null,
            'When using HudPosition.custom, you need to specify either left, right, or width.');
        assert(top == null || bottom == null || height == null,
            'When using HudPosition.custom, you need to specify either top, bottom, or height.');
        break;
    }

    _showOverlay(
      context: context,
      child: child,
      position: position,
      duration: duration,
      isBlocking: isBlocking,
      backgroundColor: backgroundColor,
      hudColor: hudColor,
      hudDecoration: hudDecoration,
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      width: width,
      height: height,
    );

    return this;
  }

  /// Hide this Hud, optionally with an [animated] fade-out.
  void hide({bool animated = true}) async {
    if (animated && isVisible) {
      // Note: savedOverlayEntry is a copy of our _overlayEntry so we can abort
      // the fade in/out animations, auto-hide, if _overlayEntry changes (due to
      // a subsequent show() call)
      var savedOverlayEntry = _overlayEntry;

      // Fade out
      _opacity = 0.0;
      _overlayEntry?.markNeedsBuild();

      await Future<dynamic>.delayed(
          animationDuration + Duration(milliseconds: 50));
      if (savedOverlayEntry != _overlayEntry) return;
    }

    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  /// Internal method that does the work of displaying the Hud. See [show()]
  /// for details on the parameters.
  void _showOverlay({
    @required BuildContext context,
    @required Widget child,
    HudPosition position = HudPosition.custom,
    Duration duration,
    bool isBlocking = false,
    Color backgroundColor = Colors.transparent,
    Color hudColor,
    BoxDecoration hudDecoration,
    double left,
    double top,
    double right,
    double bottom,
    double width,
    double height,
  }) async {
    _overlayEntry?.remove();
    _overlayEntry = null;

    _overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
        opaque: false,
        builder: (BuildContext context) {
          var mediaQuery = MediaQuery.of(context);
          var contextWidth = mediaQuery.size.width;
          var contextHeight = mediaQuery.size.height;

          switch (position) {
            case HudPosition.top:
              top = top ?? mediaQuery.viewInsets.top + 100;
              bottom = null;
              if (left == null && right == null) {
                // center horizontally
                left = (contextWidth - width) / 2;
                right = null;
              }
              break;
            case HudPosition.center:
              top = (contextHeight - height) / 2;
              left = (contextWidth - width) / 2;
              bottom = null;
              right = null;
              break;
            case HudPosition.bottom:
              top = null;
              bottom = bottom ?? mediaQuery.viewInsets.bottom + 100;
              if (left == null && right == null) {
                // center horizontally
                left = (contextWidth - width) / 2;
                right = null;
              }
              break;
            case HudPosition.custom:
              break;
          }

          var hudContainer = Container(
            width: width,
            height: height,
            color: (hudDecoration != null) ? null : hudColor,
            decoration: hudDecoration,
            child: child,
          );

          var positioned = Positioned(
            left: left,
            top: top,
            right: right,
            bottom: bottom,
            width: width,
            height: height,
            child: Material(
              color: Colors.transparent,
              child: AnimatedOpacity(
                opacity: _opacity,
                duration: animationDuration,
                child: hudContainer,
              ),
            ),
          );

          var background = isBlocking
              ? ModalBarrier(color: backgroundColor, dismissible: false)
              : SizedBox.shrink();

          var stack = Stack(
            children: [background, positioned],
          );

          return stack;
        });

    // Note: savedOverlayEntry is a copy of our _overlayEntry so we can abort
    // the fade in/out animations, auto-hide, if _overlayEntry changes (due to
    // a subsequent show() call)
    var savedOverlayEntry = _overlayEntry;
    _overlayState.insert(_overlayEntry);

    await Future<dynamic>.delayed(Duration(milliseconds: 50));
    if (savedOverlayEntry != _overlayEntry) return;
    // Fade in
    _opacity = 1.0;
    _overlayEntry?.markNeedsBuild();

    // if no duration was specified, the hud should remain visible until hide()
    // is called
    if (duration == null) return;

    await Future<dynamic>.delayed(duration);
    if (savedOverlayEntry != _overlayEntry) return;
    hide(animated: true);
  }
}
