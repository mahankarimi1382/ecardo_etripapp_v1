import 'package:flutter/foundation.dart';

/// Runtime API endpoint policy.
///
/// Native builds use the public HTTPS APIs directly. Web builds use same-origin
/// paths so a hosting reverse proxy can keep credentials and custom headers
/// same-origin. The paths are intentionally configurable for preview/staging
/// environments without changing product code.
class ApiEnvironment {
  const ApiEnvironment._();

  static String get mainApiBaseUrl {
    const configured = String.fromEnvironment('ECARDO_MAIN_API_BASE_URL');
    if (configured.isNotEmpty) return configured;
    if (kIsWeb) return Uri.base.resolve('/api').toString();
    return 'https://ecardo.ir/api';
  }

  static String get travelApiBaseUrl {
    const configured = String.fromEnvironment('ECARDO_TRAVEL_API_BASE_URL');
    if (configured.isNotEmpty) return configured;
    if (kIsWeb) return Uri.base.resolve('/travel-api/v1').toString();
    return 'https://trip.ecardo.ir/api/v1';
  }
}
