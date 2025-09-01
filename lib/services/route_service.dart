import 'package:fyp/utils/widgets/build_toast.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'dart:convert';

class RouteService {
  Future<LatLng?> geocodeAddress(String address) async {
    final cleanedAddress = address.replaceAll(RegExp(r'[\s,]+,'), '').trim();
    final formattedAddress = '$cleanedAddress, Chicago, IL';
    final url =
        'https://nominatim.openstreetmap.org/search?format=json&q=${Uri.encodeComponent(formattedAddress)}&limit=1&bounded=1&viewbox=-87.94,41.64,-87.52,42.02';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.isNotEmpty) {
          final lat = double.parse(data[0]['lat']);
          final lon = double.parse(data[0]['lon']);
          return LatLng(lat, lon);
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>> getRoutePoints(
    LatLng source,
    LatLng destination,
  ) async {
    final url =
        'https://router.project-osrm.org/route/v1/driving/${source.longitude},${source.latitude};${destination.longitude},${destination.latitude}?overview=full&geometries=geojson';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['routes'] != null && data['routes'].isNotEmpty) {
          final coordinates = data['routes'][0]['geometry']['coordinates'];
          final allPoints = coordinates
              .map<LatLng>((coord) => LatLng(coord[1], coord[0]))
              .toList();

          List<LatLng> mainPoints = [];
          if (allPoints.length <= 5) {
            mainPoints = allPoints;
          } else {
            mainPoints.add(allPoints.first);
            mainPoints.add(allPoints[(allPoints.length * 0.25).round()]);
            mainPoints.add(allPoints[(allPoints.length * 0.5).round()]);
            mainPoints.add(allPoints[(allPoints.length * 0.75).round()]);
            mainPoints.add(allPoints.last);
          }

          return {'routePoints': allPoints, 'mainPoints': mainPoints};
        }
      }
    } catch (e) {
      BuildToast.toastMessages(e.toString());
    }
    return {
      'routePoints': [source, destination],
      'mainPoints': [source, destination],
    };
  }

  Future<Map<String, dynamic>> predictCrimeRisk(List<LatLng> mainPoints) async {
    const url = '';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'locations': mainPoints
              .map((point) => {'lat': point.latitude, 'lng': point.longitude})
              .toList(),
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'predictions': data['predictions'],
          'timestamp': data['timestamp'],
          'total_predictions': data['total_predictions'],
        };
      } else {
        return {
          'success': false,
          'error': 'Failed to fetch predictions: Status ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Error connecting to prediction API: $e',
      };
    }
  }
}
