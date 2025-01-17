# Karma Coin App

This repo contains the source code for the Karma Coin cross-platform app.
To learn more about KarmaCoin visit https://karmaco.in

## Supported Platforms
Web, iOS, Android

## Testing

```bash
flutter test
```

## Scripts

### Create native splash screen
Needed if you modify `flutter_native_splash.yaml`
```bash
flutter pub run flutter_native_splash:create
```

### Build an Android Relase
```bash
# apk for app stores
flutter build apk
# app bundle for google play store
flutter build appbundle
```

### Build Web App
- Push to remote github branch 'web-deploy'
- Run the deploy action when the build action completes.

### Build an iOS release
```bash
flutter build ipa --release
```

### Dealing with iOS Archive issues
https://github.com/flutter/flutter/issues/123852

Modify line 44 of 'Target Support Files/Pods-Runner/Pods-Runner-frameworks.sh' to make it:

```
source="$(readlink -f "${source}")"
```

 

Copyright (c) 2022 by the KarmaCoin Authors. This work is licensed under the [KarmaCoin License](https://github.com/karma-coin/.github/blob/main/LICENSE).


