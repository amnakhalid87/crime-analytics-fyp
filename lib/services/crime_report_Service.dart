import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fyp/utils/widgets/build_toast.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class CrimeReportService {
  static const String baseUrl = 'https://crime-app-report-api.onrender.com';

  static const Duration timeoutDuration = Duration(minutes: 2);

  static Map<String, String> get headers {
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'User-Agent': kIsWeb ? 'Flutter-Web-App/1.0' : 'Flutter-Android-App/1.0',
    };
  }

  static Future<bool> hasInternetConnection() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        return false;
      }

      try {
        final result = await InternetAddress.lookup(
          'google.com',
        ).timeout(const Duration(seconds: 5));
        return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      } catch (e) {
        return connectivityResult != ConnectivityResult.none;
      }
    } catch (e) {
      print('Internet connectivity check failed: $e');
      return false;
    }
  }

  static Future<List<dynamic>> getCrimeReports() async {
    print('🔍 DEBUG: Using URL: $baseUrl/msg');

    try {
      if (!await hasInternetConnection()) {
        BuildToast.toastMessages(
          'No internet connection available. Please check your network.',
        );
        return [];
      }

      print('Attempting to fetch crime reports from: $baseUrl/crime-reports');

      final response = await http
          .get(Uri.parse('$baseUrl/crime-reports'), headers: headers)
          .timeout(timeoutDuration);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final reports = json.decode(response.body);

        if (reports is List) {
          // Sort reports by ID in descending order (newest first)
          reports.sort((a, b) {
            final aId = (a['id'] is String) ? int.tryParse(a['id']) : a['id'];
            final bId = (b['id'] is String) ? int.tryParse(b['id']) : b['id'];
            return (bId ?? 0).compareTo(aId ?? 0);
          });

          // Return only the latest 5 reports for home screen
          return reports.length > 5 ? reports.sublist(0, 5) : reports;
        }
        return reports;
      } else {
        BuildToast.toastMessages(
          'Failed to load crime reports: Server returned ${response.statusCode}',
        );
        return [];
      }
    } on SocketException catch (e) {
      BuildToast.toastMessages(
        'Network error: Unable to connect to the server. Please check your internet connection.',
      );
      return [];
    } on TimeoutException catch (e) {
      BuildToast.toastMessages(
        'Request timed out. The server may be slow or unreachable.',
      );
      return [];
    } on http.ClientException catch (e) {
      BuildToast.toastMessages('Network error: ${e.message}');
      return [];
    } catch (e) {
      print('Error fetching crime reports: $e');
      BuildToast.toastMessages(
        'An unexpected error occurred while loading reports.',
      );
      return [];
    }
  }

  static Future<Map<String, dynamic>> submitCrimeReport({
    required String userName,
    required String email,
    required String crimeType,
    required String crimeLocation,
    required String date,
    required String time,
    required String crimeDescription,
  }) async {
    try {
      if (!await hasInternetConnection()) {
        return {
          'success': false,
          'message':
              'No internet connection available. Please check your network.',
        };
      }

      print('Submitting crime report to: $baseUrl/crime-report');

      final response = await http
          .post(
            Uri.parse('$baseUrl/crime-report'),
            headers: headers,
            body: jsonEncode({
              'userName': userName,
              'email': email,
              'crimeType': crimeType,
              'crimeLocation': crimeLocation,
              'date': date,
              'time': time,
              'crimeDescription': crimeDescription,
            }),
          )
          .timeout(timeoutDuration);

      print('Submit response status: ${response.statusCode}');
      print('Submit response body: ${response.body}');

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Crime report submitted successfully',
        };
      } else {
        return {
          'success': false,
          'message':
              'Failed to submit report: Server returned ${response.statusCode}',
        };
      }
    } on SocketException catch (e) {
      return {
        'success': false,
        'message': 'Network error: Unable to connect to the server.',
      };
    } on TimeoutException catch (e) {
      return {
        'success': false,
        'message': 'Request timed out. Please try again later.',
      };
    } catch (e) {
      print('Error submitting crime report: $e');
      return {
        'success': false,
        'message': 'An unexpected error occurred while submitting the report.',
      };
    }
  }

  static Future<String> testApiConnection() async {
    try {
      if (!await hasInternetConnection()) {
        return '❌ No internet connection available. Please check your network settings.';
      }

      print('Testing API connection to: $baseUrl');

      final response = await http
          .get(Uri.parse('$baseUrl/'), headers: headers)
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return '✅ API Connection Successful!\n\nServer: $baseUrl\nStatus: ${response.statusCode}\nResponse: ${response.body.isNotEmpty ? response.body : "Connection established"}';
      } else {
        return '❌ API Connection Failed\nServer: $baseUrl\nStatus Code: ${response.statusCode}\nResponse: ${response.body}';
      }
    } on SocketException catch (e) {
      return '❌ Network Error: Unable to connect to the server at $baseUrl\n\nPlease check:\n1. Your internet connection\n2. Server is running\n3. Correct server URL';
    } on TimeoutException catch (e) {
      return '❌ Connection Timeout: Server at $baseUrl did not respond within ${timeoutDuration.inSeconds} seconds\n\nThis could mean:\n1. Server is down or overloaded\n2. Network issues\n3. Firewall blocking the connection';
    } on http.ClientException catch (e) {
      return '❌ Client Error: ${e.message}\n\nTrying to reach: $baseUrl';
    } catch (e) {
      return '❌ Unexpected Error: ${e.toString()}\n\nPlease check your configuration and try again.';
    }
  }
}
