Geofencing Location-Based Notification App

A Flutter Android application that sends location-based notifications when a user enters predefined physical locations. The app continues monitoring even in the background or when minimized and triggers a unique notification for each target location.

Features

✅ Background location monitoring

✅ Location-specific notifications

✅ Works even when the app is minimized or the screen is locked

✅ Single notification per location entry (no spam)

✅ Start/stop monitoring from the app

Target Locations

The app monitors the following locations:

Name	Latitude	Longitude
Shyamoli Square Shopping Mall	23.77487430923034	90.3678324945658
Progressive Byte Ltd, Shyamoli	23.773731	90.369333
Adabor Thana	23.770822	90.357447
PC Culture Housing, Mohammadpur	23.763895	90.358347
Home, Tongi	23.8873	90.4035
Screenshots


Monitoring active in background


Monitoring stopped, can restart manually

Getting Started
Prerequisites

Flutter SDK >= 3.10.1

Android device/emulator

Location permissions enabled

Installation

Clone the repository:

git clone https://github.com/yourusername/geofencing-app.git
cd geofencing-app


Install dependencies:

flutter pub get


Run the app on your device:

flutter run

Usage

App automatically starts monitoring on launch.

When you enter a target location, a notification is triggered with a location-specific message.

Use the Close Monitoring button to stop background monitoring.

After stopping, you can restart monitoring using the Start Monitoring button.

Dependencies

flutter_bloc – State management

geolocator – Fetch location data

flutter_background_service – Background service for continuous monitoring

flutter_local_notifications – Local notifications

permission_handler – Request location and background permissions

Folder Structure
lib/
├── core/
│   ├── services/          # Notification & location services
│   └── utils/             # Helper utilities (distance calculation)
├── features/
│   └── home/
│       ├── cubit/         # BLoC cubit for state management
│       └── home_page.dart # UI for monitoring controls
├── locations/
│   └── target_locations.dart # Predefined locations
└── main.dart              # App entry point

Notes

The app does not include a map UI.

Location monitoring and notifications work in the background.

Each target location triggers the notification only once per entry.

License

This project is private and for learning/demo purposes.