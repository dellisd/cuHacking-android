# project: Latios

The iOS app that will be used by attendees of cuHacking 2020 as well as by organizers to help manage attendees. Built using [Xcode 10.2](https://developer.apple.com/xcode/).

## Getting Started

To build this project you will need Xcode 10.1 or later.


You will need to do the following:
- Run `pod install`
- Put a `GoogleService-Info.plist` file in the `/cuHacking` folder in order for Firebase to work. See the [Firebase docs](https://firebase.google.com/docs/ios/setup) on adding the Firebase configuration file.
- Create a [Mapbox](https://www.mapbox.com/install/ios/cocoapods-permission/) token and create a `.mapbox` file in `cuHacking/cuHacking`. Place your token in the `.mapbox` file

For Google Firebase notifications to work, you will need to create and upload APN certificates to Firebase.
[More](https://firebase.google.com/docs/cloud-messaging/ios/certs) on how to setup Firebase notifications work on iOS. This is NOT required for the app to run.
