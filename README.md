# FluCast

Open Source Podcast app for your Show

## Getting Started

Have you always wanted an exclusive app for your Podcast? Now you can customize and make available to your audience a player for Android and iOS developed with [Flutter](https://github.com/flutter/flutter).

Simply configure your Podcast feed, tweak the app icon, build and make it available in stores.

## Main Features

FluCast has the most features that you need to play your show:

- [x] Podcast Cover
- [x] Podcast Description
- [x] Episodes Listing
- [x] Player Status
- [x] Play, Pause and Stop
- [x] 30 Seconds Seek
- [x] Episode Description

## Setting Up Feed

Just change the `podcastFeedUrl` located on [feed.dart](https://github.com/luizeof/flucast_app/blob/master/lib/feed.dart) file with a valid **Podcast RSS Feed**.

```dart
final podcastFeedUrl = 'https://anchor.fm/s/848f2e4/podcast/rss';
```

## Setting Up App Name

### For Android

Open the configuration file [android/app/src/main/AndroidManifest.xml](https://github.com/luizeof/flucast_app/blob/master/android/app/src/main/AndroidManifest.xml) and change this line:

```xml
<application
    android:label="FluCast" ...> // Your app name here
```

### For iOS

Open the configuration file [ios/Runner/Info.plist](https://github.com/luizeof/flucast_app/blob/master/ios/Runner/Info.plist) and change this line:


```xml
<key>CFBundleName</key>
<string>FluCast</string> // Your app name here
```

## Setting Up App Icon

FluCast default icon <img align="left" width="48" height="48" src="lib/icon/app_icon.png"> is located at [lib/icon/app_icon.png](https://github.com/luizeof/flucast_app/blob/master/lib/icon/app_icon.png) and you can change it to your brand. After change the app icon, you need to run this command on app root directory:

```bash
 flutter pub get
 flutter pub run flutter_launcher_icons:main -f pubspec.yaml
```

## Screens
Home | Episodes | Playing | Details
---- | ---- | ---- | ----
<img align="left" src="docs/home.png"> |  <img align="left" src="docs/episodes.png"> |  <img align="left" src="docs/playing.png"> |  <img align="left" src="docs/details.png">

## Dependencies

- flutter_launcher_icons (https://pub.dev/packages/flutter_launcher_icons)
- dart_pod (https://pub.dev/packages/dart_pod)
- html (https://pub.dev/packages/html)
- audioplayer (https://pub.dev/packages/audioplayer)

## Resources

- Default App Icon (https://www.flaticon.com/free-icon/record_1064911)

## How to Contribute

- Fork the the project
- Create your feature branch (git checkout -b my-new-feature)
- Make required changes and commit (git commit -am 'Add some feature')
- Push to the branch (git push origin my-new-feature)
- Create new Pull Request

## Licence

```
Copyright 2019, luizeof

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```