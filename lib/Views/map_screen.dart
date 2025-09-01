import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fyp/Views/route_screen.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _sourceController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();

  static const LatLng _initialCenter = LatLng(41.8832, 87.6324);

  void _navigateToRouteScreen() {
    if (_sourceController.text.isEmpty || _destinationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both addresses')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RouteScreen(
          source: _sourceController.text,
          destination: _destinationController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],

      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _initialCenter,
              initialZoom: 2.0,
              minZoom: 1.0,
              maxZoom: 18.0,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
                subdomains: const ['a', 'b', 'c', 'd'],
                retinaMode: RetinaMode.isHighDensity(context),
                userAgentPackageName: "com.example.yourapp",
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _initialCenter,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.location_pin,
                      size: 40,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 20,
            left: 16,
            right: 16,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _sourceController,
                    decoration: InputDecoration(
                      hintText: 'Source Address',
                      hintStyle: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                      prefixIcon: Container(
                        padding: const EdgeInsets.all(12),
                        child: const CircleAvatar(
                          radius: 6,
                          backgroundColor: Colors.green,
                        ),
                      ),
                      suffixIcon: Icon(
                        Icons.my_location,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _destinationController,
                    decoration: InputDecoration(
                      hintText: 'Destination Address',
                      hintStyle: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                      prefixIcon: Container(
                        padding: const EdgeInsets.all(12),
                        child: const CircleAvatar(
                          radius: 6,
                          backgroundColor: Colors.red,
                        ),
                      ),
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: _navigateToRouteScreen,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        "Search Route",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
