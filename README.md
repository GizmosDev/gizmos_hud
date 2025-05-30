# gizmos_hud

[![badge-pubdev]][pub.dev]
[![badge-repo]][repo]
![github-stars][]

![badge-platforms][]
[![badge-language]][dart.dev]
[![badge-license]][license]

[![badge-sponsors]][cerebral-gardens]
[![badge-githubsponsors]][github-davewoodcom]
[![badge-patreon]][patreon-davewoodx]

[![badge-mastodon]][mastodon-davewoodx]
[![badge-twitter]][twitter-davewoodx]
[![badge-twitter-gizmosdev]][twitter-gizmosdev]

A Flutter package for displaying custom HUDs, Toasts, Pop-Ups, Dialogs or other screen overlays. Any widget can be displayed, in any position on the screen for a completely customized interface.


## Installation

To use this package, add `gizmos_hud` as a [dependency in your pubspec.yaml file](https://flutter.dev/docs/development/packages-and-plugins/using-packages#adding-a-package-dependency-to-an-app).

```yaml
dependencies:
  gizmos_hud: any
```


## Import the library

```dart
import 'package:gizmos_hud/gizmos_hud.dart';
```


## Usage

For each overlay you want to use in your app, create a `Hud` instance.

To display the Hud, call the `show()`.
To hide it, call `hide()`.


### show()

#### Parameter: context _required_

The `context` is the `BuildContext` that will be used to present the hud. Depending on where/how you're displaying the hud, this won't likely be the `context` for the current `build()` method. Because we want the hud to have access to the full screen, you need to pass in the `context` for the top most page.

#### Parameter: child _required_

The `child` parameter is the `Widget` to be displayed.

#### Parameter: position

The `position` parameter determines where the hud is displayed. There are four options:

###### HudPosition.top
	
For `HudPosition.top`, the `top` parameter becomes the offset (defaults to 100) from the top of the context. You must also pass in either a `width` with an optional `left` or `right` value, or omit `width` and specify both `left` and `right` values. `height` is also required.

###### HudPosition.bottom

For `HudPosition.bottom`, the `bottom` parameter becomes the offset (defaults to 100) from the bottom of the context. You must also pass in either a `width` with an optional `left` or `right` value, or omit `width` and specify both `left` and `right` values. `height` is also required.

###### HudPosition.center

For `HudPosition.center`, `width` and `height` are required, `top`, `bottom`, `left`, `right` should be omitted.

###### HudPosition.custom

For a `position` of `HudPosition.custom`, the positional parameters are passed directly to a `Position` `Widget`.

#### Parameter: duration

Set a `duration` to have the hud automatically fade out after that duration has passed. Omit `duration` to have the overlay stay on screen until programmatically dismissed by calling the `hide()` method.

#### Parameter: isBlocking

Set `isBlocking` to `true` to create a full screen background behind the hud that blocks user interaction.

#### Parameter: backgroundColor

`backgroundColor` specifies the colour to display behind the hud. Currently this is ignored if `isBlocking` is set to `true`, however I expect that to change in a later version.

#### Parameter: hudDecoration

Use `hudDecoration` to display a custom `BoxDecoration` as the background of the hud. There are two default `hudDecorations` included that you can use: `Hud.defaultDarkHudDecoration` and `Hud.defaultLightHudDecoration`

#### Parameter: hudColor

The `hudColor` parameter can be used as a shortcut to create a basic `hudDecoration`.

#### Parameter: left/top/right/bottom/width/height

These parameters are related to `position` above.

### hide()

The only parameter in `hide()` is the optional boolean `animated` that specifies whether or not to animate (fade out) the Hud. This defaults to `true`.


## Screenshots

<img src="https://github.com/GizmosDev/gizmos_hud/raw/master/assets/iOSDemo.gif" alt="iOS Demo" width="319" height="638" />&nbsp;<img src="https://github.com/GizmosDev/gizmos_hud/raw/master/assets/AndroidDemo.gif" alt="Android Demo" width="297" height="638" />


## Example

```dart
fancyToastHud.show(
  context: topBuildContext,
  child: child,
  hudDecoration: fancyHudDecoration,
  position: HudPosition.top,
  duration: Duration(seconds: 3),
  width: 280,
  height: 50,
  top: 120,
);
```

Please see the example app in this package for a full example.


## Notes

* This is my first Flutter package, and I'm still learning the Flutter way of doing things so a lot of this package may change. Please send me suggestions/bug fixes.
* Some initial questions:
	* Is there a better way to get the `topBuildContext`?
	* Is there a better way to handle the fade in/out, rather than using the delay/markNeedsBuild process?

   ***
   
# [![gizmosdev-logo]][gizmos.dev] gizmos.dev


<!-- Link references -->

[pub.dev]: https://pub.dev/packages/gizmos_hud
[license]: https://github.com/GizmosDev/gizmos_hud/blob/master/LICENSE
[repo]: https://github.com/GizmosDev/gizmos_hud
[badge-repo]: https://img.shields.io/badge/GitHub-gizmos__hud-blue.svg?style=flat
[badge-pubdev]: https://img.shields.io/pub/v/gizmos_hud.svg?label=gizmos_settings_screen
[github-stars]: https://img.shields.io/github/stars/gizmosdev/gizmos_hud?style=social

[gizmos.dev]: https://gizmos.dev/
[gizmosdev-logo]: https://gizmos.dev/images/GizmosDevLogo_32@2x.png

[dart.dev]: https://dart.dev
[cerebral-gardens]: https://www.cerebralgardens.com/
[cerebral-gardens-apps]: https://www.cerebralgardens.com/apps/

[github-davewoodcom]: https://github.com/DaveWoodCom
[mastodon-davewoodx]: https://mastodon.social/@davewoodx
[twitter-davewoodx]: https://twitter.com/davewoodx
[patreon-davewoodx]: https://www.patreon.com/DaveWoodX

[github-gizmosdev]: https://github.com/GizmosDev
[twitter-gizmosdev]: https://twitter.com/gizmosdev

[badge-language]: https://img.shields.io/badge/Dart-%3E2.7.x-orange.svg?style=flat
[badge-platforms]: https://img.shields.io/badge/Platforms-iOS%20%7C%20Android-lightgray.svg?style=flat
[badge-license]: https://img.shields.io/badge/License-BSD%203--Clause-blue.svg?style=flat

[badge-githubsponsors]: https://img.shields.io/badge/GitHub-DaveWoodCom-blue.svg?style=flat
[badge-sponsors]: https://img.shields.io/badge/Sponsors-Cerebral%20Gardens-orange.svg?style=flat
[badge-mastodon]: https://img.shields.io/mastodon/follow/000415670?domain=https%3A%2F%2Fmastodon.social&style=social
[badge-twitter]: https://img.shields.io/twitter/follow/DaveWoodX.svg?style=social
[badge-twitter-gizmosdev]: https://img.shields.io/twitter/follow/GizmosDev.svg?style=social
[badge-patreon]: https://img.shields.io/badge/Patreon-DaveWoodX-F96854.svg?style=flat
