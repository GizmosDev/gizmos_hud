//
//  gizmos_hud
//
//  Copyright (c) 2020, Dave Wood.
//  All rights reserved.
//  Use of this source code is governed by a BSD-style license that can be
//  found in the LICENSE file.
//

import 'package:flutter/material.dart';

/// A Widget to represent each sample in our ListView
class DemoRow extends StatelessWidget {
  /// Header for the row
  final String title;

  /// Description of what the sample is doing
  final String info;

  /// Our `show` button's onTap code
  final VoidCallback show;

  /// Our `hide` button's onTap code
  final VoidCallback? hide;

  /// Instantiate a DemoRow
  DemoRow({required this.title, required this.info, required this.show, this.hide});

  @override
  Widget build(BuildContext context) {
    // layout/size calculations
    var mediaQuery = MediaQuery.of(context);
    var contextWidth = mediaQuery.size.width;

    // magic numbers etc
    var buttonLength = 50.0;
    var marginLength = 4.0;
    var buttonColor = Colors.grey.withOpacity(0.5);

    var showButton = InkWell(
        splashColor: Colors.blue,
        onTap: show,
        child: Container(
          width: buttonLength,
          height: buttonLength,
          margin: EdgeInsets.all(marginLength),
          color: buttonColor,
          child: Icon(Icons.play_arrow, color: Colors.black),
        ));

    var hideButton = (hide != null)
        ? InkWell(
            splashColor: Colors.blue,
            onTap: hide,
            child: Container(
              width: buttonLength,
              height: buttonLength,
              margin: EdgeInsets.all(marginLength),
              color: buttonColor,
              child: Icon(Icons.stop, color: Colors.black),
            ))
        : SizedBox(
            width: buttonLength + marginLength * 2,
            height: buttonLength + marginLength * 2,
          );

    var buttons = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        showButton,
        hideButton,
      ],
    );

    var header = Text(
      title,
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      maxLines: 1,
    );

    var body = Container(
      width: (contextWidth - (buttonLength * 2) - (marginLength * 4)) * 0.9,
      child: Text(
        info,
        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
        maxLines: 10,
        softWrap: true,
      ),
    );

    var row = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        body,
        buttons,
      ],
    );

    var column = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        header,
        row,
      ],
    );

    var container = Container(
      color: Colors.transparent,
      margin: EdgeInsets.all(marginLength),
      padding: EdgeInsets.all(marginLength),
      child: column,
    );

    return container;
  }
}
