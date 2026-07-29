// ─── API Service Stub ─────────────────────────────────────────────────────────
// This file is intentionally empty of real HTTP logic for now.
//
// ARCHITECTURE NOTE (for Spring Boot integration later):
// ─────────────────────────────────────────────────────────────────────────────
// Flutter App  ──HTTP──▶  Spring Boot (port 8080)
//                           └─ /api/auth      (login, register, JWT)
//                           └─ /api/users     (profile, update)
//                           └─ /api/contacts  (trusted contacts CRUD)
//                           └─ /api/routes    (safe route suggestions)
//                           └─ /api/reports   (community reports)
//                           └─ /api/alerts    (nearby alerts)
//                           └─ /api/sos       (SOS events)
//
// HOW TO ADD A REAL API CALL:
//   1. Add a method below that returns a Future<T>
//   2. Use the http package (or dio) to call your Spring Boot endpoint
//   3. Deserialize the JSON response using the model's .fromJson() factory
//   4. Replace the MockData.xxx call in the widget with the ApiService call
//
// EXAMPLE (for reference only – not active):
// Future<List<SafetyAlertModel>> fetchNearbyAlerts(double lat, double lng) async {
//   final response = await http.get(
//     Uri.parse('${AppConstants.baseUrl}/alerts/nearby?lat=$lat&lng=$lng'),
//     headers: {'Authorization': 'Bearer $token'},
//   );
//   if (response.statusCode == 200) {
//     final List<dynamic> jsonList = jsonDecode(response.body);
//     return jsonList.map((e) => SafetyAlertModel.fromJson(e)).toList();
//   }
//   throw Exception('Failed to fetch alerts');
// }

class ApiService {
  ApiService._();

  // ── All methods below return mock/local data for now ─────────────────────────
  // Replace each method body with a real HTTP call when the backend is ready.

  static Future<bool> login(String email, String password) async {
    // TODO: POST to /api/auth/login, receive JWT token, store in SharedPreferences
    await Future.delayed(const Duration(milliseconds: 800)); // simulate network
    return true; // always succeeds in mock
  }

  static Future<bool> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    // TODO: POST to /api/auth/register
    await Future.delayed(const Duration(milliseconds: 1000));
    return true;
  }

  static Future<void> triggerSos(double lat, double lng) async {
    // TODO: POST to /api/sos with location data and JWT token
    await Future.delayed(const Duration(milliseconds: 500));
  }

  static Future<bool> submitReport({
    required String category,
    required String location,
    required String description,
  }) async {
    // TODO: POST to /api/reports
    await Future.delayed(const Duration(milliseconds: 700));
    return true;
  }
}
