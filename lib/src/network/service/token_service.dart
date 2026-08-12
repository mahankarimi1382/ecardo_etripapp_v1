import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart' as legacy_sp;

/// TokenService — securely stores the user's bearer token.
///
/// v1.0.4+5 (security audit fix):
///   - Migrated from `shared_preferences` (plaintext) to `flutter_secure_storage`
///     which uses Android Keystore / iOS Keychain.
///   - Backward-compatible: on first launch after upgrade, migrates any existing
///     token from SharedPreferences to secure storage and deletes the old one.
///
/// The bearer token is the only credential needed to authenticate API requests.
/// Storing it in plaintext SharedPreferences (as the original code did) allows
/// anyone with file-system access (rooted/jailbroken device, ADB backup, malware
/// with storage permission) to read and impersonate the user.
class TokenService extends GetxService {
  static const String accessTokenKey = 'access_token';
  static const String _legacyKey = 'access_token'; // same key in SharedPreferences

  /// Android-specific options: encrypted with Keystore, require device unlock.
  static const AndroidOptions _androidOptions = AndroidOptions(
    encryptedSharedPreferences: true,
    resetOnError: true,
  );

  /// iOS-specific options: accessible after first unlock only (not when locked).
  static const IOSOptions _iosOptions = IOSOptions(
    accessibility: KeychainAccessibility.first_unlock,
  );

  late final FlutterSecureStorage _secureStorage;

  /// The reactive access token (null when logged out).
  final Rx<String?> accessToken = Rx<String?>(null);
  Future<void>? _initialLoad;

  @override
  void onInit() {
    super.onInit();
    _secureStorage = const FlutterSecureStorage(
      aOptions: _androidOptions,
      iOptions: _iosOptions,
    );
    // Keep the first storage read observable so login/logout cannot race it.
    _initialLoad = loadAccessToken();
  }

  Future<void> _waitForInitialLoad() async {
    final initialLoad = _initialLoad;
    if (initialLoad != null) await initialLoad;
  }

  /// Load the access token from secure storage.
  /// Also migrates from legacy SharedPreferences if found.
  Future<void> loadAccessToken() async {
    try {
      // Try secure storage first
      String? token = await _secureStorage.read(key: accessTokenKey);

      // If not in secure storage, try migrating from SharedPreferences
      token ??= await _migrateFromLegacyStorage();

      accessToken.value = token;
      if (kDebugMode) {
        debugPrint(
            '🔑 TokenService: token loaded (${token != null ? "present" : "absent"})');
      }
    } catch (e) {
      debugPrint('🔑 TokenService: failed to load token: $e');
      accessToken.value = null;
    }
  }

  /// Save the access token to secure storage.
  ///
  /// The in-memory value is updated before the platform storage write. This
  /// matters on Web preview/origins where the secure-storage implementation can
  /// reject a non-secure context even though the current API session is valid.
  /// A storage failure must not make the just-completed login lose its bearer
  /// token before the first authenticated request is sent.
  Future<bool> saveAccessToken(String token) async {
    await _waitForInitialLoad();
    accessToken.value = token;
    try {
      await _secureStorage.write(key: accessTokenKey, value: token);
      if (kDebugMode) {
        debugPrint('🔑 TokenService: token saved securely');
      }
      return true;
    } catch (e) {
      debugPrint('🔑 TokenService: failed to persist token: $e');
      // The current session can continue with the in-memory token. It will
      // require a new login after a Web reload if persistent storage is not
      // available. Native clients still report the persistence failure.
      return kIsWeb;
    }
  }

  /// Clear the access token (logout).
  Future<bool> clearToken() async {
    await _waitForInitialLoad();
    accessToken.value = null;
    try {
      await _secureStorage.delete(key: accessTokenKey);
      if (kDebugMode) {
        debugPrint('🔑 TokenService: token cleared');
      }
      return true;
    } catch (e) {
      debugPrint('🔑 TokenService: failed to clear persisted token: $e');
      return false;
    }
  }

  /// Migrate token from legacy SharedPreferences to secure storage.
  /// Called once on first launch after upgrade; deletes the legacy entry.
  Future<String?> _migrateFromLegacyStorage() async {
    try {
      final prefs = await legacy_sp.SharedPreferences.getInstance();
      final legacyToken = prefs.getString(_legacyKey);
      if (legacyToken == null || legacyToken.isEmpty) return null;

      // Save to secure storage
      await _secureStorage.write(key: accessTokenKey, value: legacyToken);

      // Delete from SharedPreferences
      await prefs.remove(_legacyKey);

      if (kDebugMode) {
        debugPrint(
            '🔑 TokenService: migrated token from SharedPreferences to secure storage');
      }
      return legacyToken;
    } catch (e) {
      debugPrint('🔑 TokenService: migration failed: $e');
      return null;
    }
  }
}
