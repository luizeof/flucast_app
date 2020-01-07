# FluCast

Open Source Podcast app for your Show.

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
- [x] Google Analytics Tracking

See more at [changelog.md](https://github.com/luizeof/flucast_app/blob/master/CHANGELOG.md).

## Setting Up Feed

Just change the key `feed` located at [`assets/cfg/app_settings.json`](https://github.com/luizeof/flucast_app/blob/master/assets/cfg/app_settings.json) file with a [Valid Podcast RSS Feed](https://developers.google.com/search/reference/podcast/rss-feed).

The key `ga` enable [Google Analytics App Tracking](https://support.google.com/analytics/answer/2587086).

```json
{
  "feed": "https://anchor.fm/s/848f2e4/podcast/rss",
  "ga": "UA-00000000-1"
}
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

![Image of Yaktocat](lib/icon/app_icon.png)

FluCast default icon is located at [lib/icon/app_icon.png](https://github.com/luizeof/flucast_app/blob/master/lib/icon/app_icon.png) and you can change it.

After change the app icon, you need to run this command on app root directory:

```bash
 flutter pub get
 flutter pub run flutter_launcher_icons:main -f pubspec.yaml
```

## Screens
| Home                                   | Episodes                                   | Details                                   |
| -------------------------------------- | ------------------------------------------ | ----------------------------------------- |
| <img align="left" src="docs/home.png"> | <img align="left" src="docs/episodes.png"> | <img align="left" src="docs/details.png"> |

## Dependencies

- flutter_launcher_icons [https://pub.dev/packages/flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons)
- dart_pod [https://pub.dev/packages/dart_pod](https://pub.dev/packages/dart_pod)
- html [https://pub.dev/packages/html](https://pub.dev/packages/html)
- audioplayer [https://pub.dev/packages/audioplayer](https://pub.dev/packages/audioplayer)
- flutter_volume [https://pub.dev/packages/flutter_volume](https://pub.dev/packages/flutter_volume)
- package_info [https://pub.dev/packages/package_info](https://pub.dev/packages/package_info)
- global_configuration [https://pub.dev/packages/global_configuration](https://pub.dev/packages/global_configuration)
- path_provider [https://pub.dev/packages/path_provider](https://pub.dev/packages/path_provider)
- usage [https://pub.dev/packages/usage](https://pub.dev/packages/usage)

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
