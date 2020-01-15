# cuHacking: Mobile App
This is an experiment to test the feasibility of migrating to a Kotlin Multiplatform project for cuHacking's mobile apps.

## Getting Started
To build this project you will need Android Studio 3.6 and the Android SDK for Android 10 (29).

To work on iOS code, you will also need Xcode.

You will need to put a `google-services.json` file in the `/app` folder in order for Firebase to work. See the [Firebase docs](https://firebase.google.com/docs/android/setup#add-config-file) on adding the Firebase configuration file.

In your `local.properties` file (in the project root directory) you will need to include the following properties:
```properties
mapbox.key=your mapbox key here
api.endpoint=your "/"-terminated root api endpoint here
```
