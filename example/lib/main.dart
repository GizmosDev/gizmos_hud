//
//  gizmos_hud
//
//  Copyright (c) 2020, Dave Wood.
//  All rights reserved.
//  Use of this source code is governed by a BSD-style license that can be
//  found in the LICENSE file.
//

import 'dart:math';

import 'package:flutter/material.dart';

import 'huds.dart';
import 'fancy_toast_details.dart';

// Keep a reference to the top level BuildContext so our Huds can easily be
// displayed on top of everything, regardless of the navigation in place, or
// how deep we are in a navigation stack.
/// Global reference to our top level buildContext.
BuildContext topBuildContext;
MyCustomHuds huds = MyCustomHuds();

/// Whether to randomize which fancy toast to display. This is just so I can
/// disable the randomness when recording the demo videos
var randomizeFancyToasts = true;

/// Main app widget
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'gizmos_hud Examples',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'gizmos_hud Examples'),
    );
  }
}

/// HomePage
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

/// State for the HomePage
class _MyHomePageState extends State<MyHomePage> {
  final _scrollController = ScrollController();

  /// Variable to keep track of the previous fancy message to avoid dups.
  static int previousIndex = -1;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Convenience method to make consistent looking buttons
  Widget sample(
      {@required String title,
      String info,
      @required VoidCallback show,
      VoidCallback hide}) {
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

  @override
  Widget build(BuildContext context) {
    topBuildContext = context;

    /// List of our example buttons
    var children = List<Widget>();

    /// Toast
    children.add(sample(
      title: 'Simple Toast Message',
      info: 'A toast message that appears near the bottom of the screen, and '
          'disappears 3 seconds later. It can be hidden early if needed.',
      show: () {
        huds.showToast('Our simple toast message!');

        // Tool for recording demo videos
        if (!randomizeFancyToasts) {
          // Reset order
          previousIndex = -1;
        }
      },
      hide: () {
        huds.hideToast();
      },
    ));

    /// Fancy Toast
    children.add(sample(
      title: 'Fancy Toast Message',
      info: 'A toast message with an icon that appears near the top of the '
          'screen, and disappears 3 seconds later. It can be hidden early if '
          'needed.',
      show: () {
        var randomToasts = List<FancyToastDetails>();

        // Create a few random toasts to pick from
        randomToasts.add(
          FancyToastDetails(
            message: 'Please file any bugs you see',
            backgroundColor: Colors.blue,
            icon: Icon(
              Icons.bug_report,
              color: Colors.yellow,
            ),
          ),
        );
        randomToasts.add(
          FancyToastDetails(
            message: 'Payment successful',
            backgroundColor: Colors.green,
            icon: Icon(
              Icons.monetization_on,
              color: Colors.white,
            ),
          ),
        );
        randomToasts.add(
          FancyToastDetails(
            message: 'Warning: Battery low',
            backgroundColor: Colors.orange,
            icon: Icon(
              Icons.battery_alert,
              color: Colors.white,
            ),
          ),
        );
        randomToasts.add(
          FancyToastDetails(
            message: 'Error: Unable to reach the Internet',
            backgroundColor: Colors.red,
            icon: Icon(
              Icons.offline_bolt,
              color: Colors.black,
            ),
          ),
        );

        var randIndex = Random().nextInt(randomToasts.length);
        if (randomizeFancyToasts) {
          while (randIndex == previousIndex) {
            randIndex = Random().nextInt(randomToasts.length);
          }
        } else {
          // Tool for recording demo videos
          randIndex = previousIndex + 1;
          if (randIndex >= randomToasts.length) {
            randIndex = 0;
          }
        }
        previousIndex = randIndex;

        FancyToastDetails details = randomToasts[randIndex];

        huds.showFancyToast(
          details.message,
          icon: details.icon,
          backgroundColor: details.backgroundColor,
        );
      },
      hide: () {
        huds.hideFancyToast();
      },
    ));

    /// Busy
    children.add(sample(
      title: 'Non-Blocking Activity Indicator',
      info:
          'A non-blocking, indeterminate activity indicator. Appears on screen '
          'until dismissed, here with the hide button, but in practise it would'
          ' be dismissed when the long running task completes. gizmos_hud can '
          'create a blocking Activity Indicator, by passing `true` to '
          '`isBlocking`, but it\'s not as interesting for a demo.',
      show: () {
        huds.showBusy();
      },
      hide: () {
        huds.hideBusy();
      },
    ));

    /// Dialog
    children.add(sample(
      title: 'Custom Dialog',
      info: 'This presents a custom, blocking dialog widget. It includes a '
          'button that allows the user to dismiss the dialog after they\'ve '
          'read the contents. The dialog could have other options for the user,'
          ' offer a choice, or trigger a series of dialogs, perhaps as an '
          'on-boarding process.',
      show: () {
        huds.showDialog('A Custom Dialog',
            'Please submit feature requests, and or improvements to the package\'s Github page.');
      },
    ));

    /// Confetti
    children.add(sample(
      title: 'Confetti!',
      info: 'An overlay with a transparent, animated GIF covering the full '
          'screen. It automatically disappears 3 seconds later, but can be '
          'hidden early if needed. Because it\'s a full screen image however, '
          'it blocks the interface, so there\'s no hide button here to test '
          'with.',
      show: () {
        huds.showConfetti();
      },
    ));

    var header = Container(
      color: Colors.blue.withOpacity(0.2),
      height: 40.0,
      child: Center(
          child: Text('Visit https://gizmos.dev/ for more information.')),
    );

    var listView = ListView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      children: children,
    );

    var scrollView = Expanded(
        child: Scrollbar(
      controller: _scrollController,
      child: listView,
    ));

    var column = Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          header,
          scrollView,
        ]);

    var body = column;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: body,
    );
  }
}

/// Run the app.
void main() => runApp(MyApp());
