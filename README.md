# Tirhal - Ride-Sharing Application

**Delivered to Sayaratech**

A comprehensive ride-sharing mobile application built with Flutter, featuring real-time tracking, multilingual support, and Firebase integration.

---

## 🚀 Run Instructions

### Prerequisites

- Flutter SDK ^3.5.4
- Dart SDK ^3.0.0
- Android Studio / VS Code
- Firebase Project Setup
- Google Maps API Key

### Quick Start

1. **Clone and Setup**

   ```bash
   git clone https://github.com/yasin91h/tirhal.git
   cd tirhal
   flutter pub get
   ```

2. **Firebase Configuration**

   - Place `google-services.json` in `android/app/`
   - Place `GoogleService-Info.plist` in `ios/Runner/`
   - Ensure Firebase services are enabled: Core, Firestore, Realtime Database

3. **Google Maps API Setup**

   **Android** (`android/app/src/main/AndroidManifest.xml`):

   ```xml
   <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="YOUR_GOOGLE_MAPS_API_KEY"/>
   ```

   **iOS** (`ios/Runner/AppDelegate.swift`):

   ```swift
   GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY")
   ```

4. **Required Permissions**

   **Android** - Already configured in `AndroidManifest.xml`:

   - `ACCESS_FINE_LOCATION`
   - `ACCESS_COARSE_LOCATION`
   - `INTERNET`

   **iOS** - Already configured in `Info.plist`:

   - `NSLocationWhenInUseUsageDescription`
   - `NSLocationAlwaysAndWhenInUseUsageDescription`

5. **Run Application**
   ```bash
   flutter run
   ```

### Build for Production

```bash
# Android APK
flutter build apk --release

# Android App Bundle (for Play Store)
flutter build appbundle --release

# iOS (requires Xcode and iOS certificates)
flutter build ios --release
```

### Testing

```bash
flutter test                    # Run all tests
flutter test --coverage        # Run with coverage report
flutter analyze                # Static code analysis
```

---

## 🏗️ Architecture

### Architectural Pattern: **Feature-Based Modular Architecture with Provider State Management**

The application follows a clean, scalable architecture designed for maintainability and team collaboration:

```
lib/
├── main.dart                   # Application entry point
├── app.dart                    # App configuration and routing
├── core/                       # Shared functionality
│   ├── localization/          # i18n configuration
│   ├── models/                # Data models and entities
│   ├── provider/              # Global state providers
│   ├── providers/             # Feature-specific providers
│   ├── services/              # Business logic services
│   ├── theme/                 # App theming system
│   └── utils/                 # Utility functions
├── features/                   # Feature modules
│   ├── auth/                  # Authentication system
│   ├── booking/               # Ride booking flow
│   ├── geocoding/             # Location services
│   ├── history/               # Ride history management
│   ├── home/                  # Dashboard and main interface
│   ├── login_Screen/          # Login interface
│   ├── main_screen/           # Primary navigation
│   ├── Onboarding/            # User onboarding
│   ├── payment/               # Payment processing
│   ├── profile/               # User profile management
│   ├── ride/                  # Ride management
│   ├── search/                # Location search
│   └── tracking/              # Real-time ride tracking
├── routes/                     # Navigation configuration
└── widgets/                    # Reusable UI components
```

### State Management Architecture

**Pattern**: Provider Pattern with ChangeNotifier
**Rationale**: Chosen for its simplicity, performance, and tight integration with Flutter's widget tree.

**Key Providers** (16 total):

- `AuthProvider` - User authentication state
- `UserLocationProvider` - GPS and location management
- `RideRequestProvider` - Ride booking and management
- `GeocodingProvider` - Address and location services
- `RideTrackingProvider` - Real-time tracking
- `NavigationProvider` - App navigation state
- `ThemeProvider` - Theme and styling management
- `LanguageProvider` - Localization management

### Backend Architecture

**Firebase Services Integration**:

- **Firebase Core** ^4.1.0 - Foundation services
- **Cloud Firestore** ^6.0.1 - Primary database for structured data
- **Realtime Database** ^12.0.1 - Live updates for tracking and messaging

**Data Flow**:

```
UI Layer (Widgets)
    ↕
Provider Layer (State Management)
    ↕
Service Layer (Business Logic)
    ↕
Firebase Layer (Data Persistence)
```

### Location Services Architecture

**Multi-Service Integration**:

- **Google Maps Flutter** ^2.13.1 - Map display and interaction
- **Geolocator** ^14.0.2 - GPS positioning and location detection
- **Geocoding** ^3.0.0 - Address-to-coordinates conversion

**Location Flow**:

1. GPS location detection via Geolocator
2. Address resolution via Geocoding service
3. Map visualization via Google Maps
4. Real-time updates via Firebase Realtime Database

---

## 🎯 Architectural & Technical Decisions

### 1. **State Management: Provider Pattern**

**Decision**: Provider with ChangeNotifier over alternatives (Riverpod, BLoC, GetX)

**Reasoning**:

- ✅ **Simplicity**: Minimal boilerplate for medium-complexity app
- ✅ **Performance**: Direct widget tree integration, efficient rebuilds
- ✅ **Team Familiarity**: Lower learning curve for developers
- ✅ **Flutter Integration**: Officially recommended by Flutter team
- ✅ **Scalability**: 16 providers managing distinct concerns without complexity

**Implementation**: Each feature has dedicated providers, with global providers for shared state.

### 2. **Backend: Firebase Ecosystem**

**Decision**: Firebase over custom REST API/GraphQL solutions

**Reasoning**:

- ✅ **Real-time Requirements**: Native WebSocket connections for live tracking
- ✅ **Rapid Development**: Built-in authentication, database, and hosting
- ✅ **Scalability**: Auto-scaling infrastructure without DevOps overhead
- ✅ **Offline Support**: Built-in offline-first capabilities
- ✅ **Security**: Battle-tested security rules and authentication
- ✅ **Cost-Effective**: Pay-as-you-scale pricing model

**Services Used**:

- **Firestore**: User profiles, ride history, static data
- **Realtime Database**: Live location tracking, real-time updates
- **Firebase Core**: Authentication and app initialization

### 3. **Architecture Pattern: Feature-Based Modular**

**Decision**: Feature modules over layer-based architecture (MVC, MVP, MVVM)

**Reasoning**:

- ✅ **Team Scalability**: Multiple developers can work on different features independently
- ✅ **Maintainability**: Clear separation of concerns by business domain
- ✅ **Code Organization**: Related code grouped together (UI, logic, models)
- ✅ **Testing**: Isolated feature testing without cross-dependencies
- ✅ **Flexibility**: Easy to extract features into separate packages if needed

**Structure**: Each feature contains its screens, providers, models, and services.

### 4. **Localization: Easy Localization Package**

**Decision**: Easy Localization over Flutter's built-in intl package

**Reasoning**:

- ✅ **RTL Support**: Native Arabic right-to-left layout support
- ✅ **Runtime Switching**: Change language without app restart
- ✅ **Asset Management**: JSON-based translation files
- ✅ **Pluralization**: Advanced plural forms for Arabic
- ✅ **Developer Experience**: Hot reload support for translations

**Languages Supported**: English (primary), Arabic with full RTL layout

### 5. **Maps & Location: Google Services**

**Decision**: Google Maps ecosystem over alternatives (Mapbox, OpenStreetMap)

**Reasoning**:

- ✅ **Market Accuracy**: Superior location data quality in target regions
- ✅ **Feature Completeness**: Routing, traffic, places API integration
- ✅ **Developer Experience**: Excellent Flutter plugin support
- ✅ **User Familiarity**: Users already comfortable with Google Maps interface
- ✅ **Ecosystem Integration**: Seamless with other Google services

**Integration**: Three-package approach for comprehensive location features.

### 6. **UI Framework: Material Design with Custom Theming**

**Decision**: Material Design with custom branding over completely custom UI

**Reasoning**:

- ✅ **Development Speed**: Pre-built, accessible components
- ✅ **Consistency**: Familiar patterns for users
- ✅ **Accessibility**: Built-in screen reader and accessibility support
- ✅ **Maintenance**: Less custom code to maintain
- ✅ **Branding Flexibility**: Theming system allows brand customization

**Implementation**: Custom color palette with Material components and brand-specific styling.

### 7. **Dependency Management: Controlled Dependencies**

**Decision**: 23 carefully selected packages over extensive third-party libraries

**Reasoning**:

- ✅ **Bundle Size**: Minimal app size for better user experience
- ✅ **Security**: Fewer dependencies reduce attack surface
- ✅ **Maintenance**: Easier to update and maintain smaller dependency tree
- ✅ **Performance**: Less code compilation and runtime overhead
- ✅ **Stability**: Well-established packages with active maintenance

**Philosophy**: "Essential only" - each package serves a critical business need.

### 8. **Data Models: Shared Core Models**

**Decision**: Centralized models in `core/models/` vs. feature-specific models

**Reasoning**:

- ✅ **Consistency**: Single source of truth for data structures
- ✅ **Type Safety**: Shared models prevent data inconsistencies
- ✅ **Reusability**: Models used across multiple features
- ✅ **API Contract**: Clear contracts between features and services
- ✅ **Testing**: Centralized model testing and validation

**Structure**: Core business entities (User, Ride, Driver, Location) as shared models.

---

### Performance & Technical Considerations

**Memory Management**:

- Provider disposal patterns to prevent memory leaks
- Image caching and optimization for map markers
- Efficient list rendering with ListView.builder patterns

**Network Optimization**:

- Firebase offline persistence for critical data
- Optimistic updates for better user experience
- Connection state monitoring and error handling

**Battery & GPS Optimization**:

- Location tracking only during active rides
- Efficient GPS polling intervals
- Background processing limitations compliance

**Security Implementation**:

- Firebase security rules for data access control
- Input validation and sanitization
- Secure API key management

---

This architecture and decision set delivers a production-ready, scalable ride-sharing application optimized for Arabic-speaking markets with international standards for performance, security, and user experience.
