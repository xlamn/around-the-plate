# around_the_plate

An application to track the dishes you have eaten in restaurants around the world.

# App Downloads

Coming soon.


# Setup

If you're new to Flutter the first thing you'll need is to follow the [setup instructions](https://docs.flutter.dev/get-started/install).

Create a file in the lib/env folder called api_keys.dart and replace the placeholder values with your keys.
```
{
    "GOOGLE_VISION_API_KEY": "YOUR_GOOGLE_VISION_API_KEY",
    "MAPBOX_API_KEY": "YOUR_MAPBOX_API_KEY"
}
```


Execute the following command in your terminal:
```
flutter pub get
```
```
flutter run --dart-define-from-file=lib/env/api_keys.json
```
The app can be run on several platforms but is only determined for iOS and Android.