# Freight Management: Driver App

This is the Flutter companion app for the Freight Management Platform. While the web portals handle bidding and shipment posting, this mobile app manages the actual execution of trips on the road.

It is responsible for trip lifecycle management, location tracking, and delivery verification.

## Tech Stack

- **Framework:** Flutter
- **Local Storage:** SharedPreferences
- **Maps & Location:** geolocator

## Core Architecture & Features

### No-Password Login (JWT Deep Links)

When a transporter assigns a driver to a trip, the backend triggers an SMS containing a JWT-secured deep link.

- Tapping the link opens the app.
- The driver is authenticated automatically.
- Active trip data is fetched immediately and loaded into the UI.
- The active-trip state is persisted locally on the device as soon as it is retrieved.

### Background GPS Tracking

The app runs a background service that periodically polls the device's coordinates.

- Location updates are collected at configured intervals.
- Coordinates are transmitted to the backend whenever network connectivity is available.
- The backend reverse-geocodes coordinates into timestamped, city-level checkpoints.
- These checkpoints power the shipment tracking timeline displayed in the client dashboard.

### Secure Delivery Verification

To prevent a shipment from being closed out prematurely or by mistake, the system enforces a physical handoff process.

- The driver cannot simply press a "Delivered" button.
- A secure Delivery OTP must be obtained directly from the client at the destination.
- The OTP is submitted through the app.
- The backend only finalizes the shipment after successful OTP verification.

## Running Locally

### Prerequisites

- Flutter SDK installed
- Android Emulator running or a physical device connected

### Setup Steps

#### 1. Clone the Repository

```bash
git clone https://github.com/w-2006-aksh/freight-management-mobile.git
cd freight-management-mobile
```

#### 2. Install Dependencies

```bash
flutter pub get
```

#### 3. Environment Variables

Create a `.env` file in the root directory and configure it to point to your backend API.

#### 4. Run the App

```bash
flutter run
```
