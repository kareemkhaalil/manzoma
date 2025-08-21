import 'package:http/http.dart' as http;

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    try {
      // Try multiple endpoints to ensure connectivity
      final response = await http.get(
        Uri.parse('https://httpbin.org/status/200'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      try {
        // Fallback to a simpler endpoint
        final response = await http
            .head(
              Uri.parse('https://www.google.com'),
            )
            .timeout(const Duration(seconds: 3));

        return response.statusCode == 200;
      } catch (e) {
        // If both fail, assume no connection
        return false;
      }
    }
  }
}

// Alternative implementation that always returns true for development
class AlwaysConnectedNetworkInfo implements NetworkInfo {
  @override
  Future<bool> get isConnected async => true;
}
