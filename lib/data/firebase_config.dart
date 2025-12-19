/// Compile-time flag to toggle between in-memory and Firestore data sources.
///
/// This constant is set at compile-time using the `USE_FIRESTORE` environment variable.
/// - Default: `false` (uses in-memory storage)
/// - To enable Firestore: `flutter run --dart-define=USE_FIRESTORE=true`
///
/// **Note:** Since this is a compile-time constant, changing it requires a full app
/// restart. Hot-reload will not pick up changes to this value.
const bool useFirestore = bool.fromEnvironment('USE_FIRESTORE', defaultValue: false);
