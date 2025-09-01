import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fyp/utils/widgets/build_toast.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class FeedbackService {
  static const String baseUrl =
      'https://crimeapplication-feedback.onrender.com';

  // Web ke liye special headers
  static Map<String, String> get headers {
    if (kIsWeb) {
      return {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': '*/*',
        'Access-Control-Allow-Origin': '*',
        'User-Agent': 'Flutter-Web-App/1.0',
      };
    } else {
      return {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'User-Agent': 'Flutter-Android-App/1.0',
      };
    }
  }

  static Future<bool> hasInternetConnection() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (!connectivityResult.contains(ConnectivityResult.mobile) &&
          !connectivityResult.contains(ConnectivityResult.wifi)) {
        return false;
      }
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      print('Internet connectivity check failed: $e');
      return false;
    }
  }

  static Future<bool> submitFeedback({
    required String userId,
    required String message,
  }) async {
    try {
      if (!await hasInternetConnection()) {
        BuildToast.toastMessages(
          'No internet connection available. Please check your network.',
        );
        return false;
      }

      final response = await http
          .post(
            Uri.parse('$baseUrl/feedback'),
            headers: headers,
            body: json.encode({'user_id': userId, 'message': message}),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 201) {
        BuildToast.toastMessages('Feedback submitted successfully');
        return true;
      } else {
        BuildToast.toastMessages(
          'Failed to submit feedback: ${response.statusCode} - ${response.body}',
        );
        return false;
      }
    } on SocketException catch (e) {
      BuildToast.toastMessages(
        'Network error: Unable to connect to the server. $e',
      );
      return false;
    } on TimeoutException catch (e) {
      BuildToast.toastMessages(
        'Request timed out. The server may be slow or unreachable. $e',
      );
      return false;
    } catch (e) {
      print('Error submitting feedback: $e');
      print('Stack trace: ${StackTrace.current}');
      BuildToast.toastMessages('An error occurred: $e');
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getAllFeedback() async {
    try {
      if (!await hasInternetConnection()) {
        BuildToast.toastMessages(
          'No internet connection available. Please check your network.',
        );
        return [];
      }

      final response = await http
          .get(Uri.parse('$baseUrl/feedback'), headers: headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('Feedback response: $jsonData');
        if (jsonData is List) {
          return jsonData.cast<Map<String, dynamic>>();
        }
        return [];
      } else {
        BuildToast.toastMessages(
          'Failed to load feedback: ${response.statusCode} - ${response.body}',
        );
        return [];
      }
    } on SocketException catch (e) {
      BuildToast.toastMessages(
        'Network error: Unable to connect to the server. $e',
      );
      return [];
    } on TimeoutException catch (e) {
      BuildToast.toastMessages(
        'Request timed out. The server may be slow or unreachable. $e',
      );
      return [];
    } catch (e) {
      print('Error fetching feedback: $e');
      print('Stack trace: ${StackTrace.current}');
      BuildToast.toastMessages('An error occurred: $e');
      return [];
    }
  }

  // Test API connection function add karta hoon
  static Future<String> testApiConnection() async {
    try {
      if (!await hasInternetConnection()) {
        return '❌ No internet connection available';
      }

      final response = await http
          .get(Uri.parse(baseUrl), headers: headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return '✅ API Connection Successful!\n\nResponse: ${response.body}';
      } else {
        return '❌ API Connection Failed\nStatus Code: ${response.statusCode}\nResponse: ${response.body}';
      }
    } on SocketException catch (e) {
      return '❌ Network error: Unable to connect to the server. $e';
    } on TimeoutException catch (e) {
      return '❌ Request timed out. The server may be slow or unreachable. $e';
    } catch (e) {
      return '❌ Error: ${e.toString()}';
    }
  }
}
