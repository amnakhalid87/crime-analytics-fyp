import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fyp/Views/crime_prediction_screen.dart';
import 'package:fyp/services/route_service.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fyp/utils/constant/colors.dart';
import 'dart:math';

class RouteScreen extends StatefulWidget {
  final String source;
  final String destination;

  const RouteScreen({
    super.key,
    required this.source,
    required this.destination,
  });

  @override
  State<RouteScreen> createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen>
    with SingleTickerProviderStateMixin {
  final MapController _mapController = MapController();
  final RouteService _routeService = RouteService();
  LatLng? sourceLatLng;
  LatLng? destinationLatLng;
  List<LatLng> routePoints = [];
  List<LatLng> mainPoints = [];
  bool isLoading = true;
  String? errorMessage;

  static const LatLng _defaultCenter = LatLng(41.8832, -87.6324);

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _geocodeAndFetchRoute();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _geocodeAndFetchRoute() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    sourceLatLng = await _routeService.geocodeAddress(widget.source);
    destinationLatLng = await _routeService.geocodeAddress(widget.destination);

    String error = '';
    if (sourceLatLng == null) {
      error += 'Source address "${widget.source}" not found. ';
    }
    if (destinationLatLng == null) {
      error += 'Destination address "${widget.destination}" not found. ';
    }

    if (sourceLatLng != null && destinationLatLng != null) {
      final result = await _routeService.getRoutePoints(
        sourceLatLng!,
        destinationLatLng!,
      );
      routePoints = result['routePoints'] as List<LatLng>;
      mainPoints = result['mainPoints'] as List<LatLng>;
    } else {
      setState(() {
        errorMessage = error.isNotEmpty
            ? '$error\nPlease enter more specific addresses.'
            : 'Unable to find addresses. Please try again.';
      });
    }

    setState(() {
      isLoading = false;
    });

    if (sourceLatLng != null && destinationLatLng != null) {
      _fitMapToBounds();
    }
  }

  void _fitMapToBounds() {
    if ((sourceLatLng != null || destinationLatLng != null) && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          try {
            final points = routePoints.isNotEmpty
                ? routePoints
                : [
                    if (sourceLatLng != null) sourceLatLng!,
                    if (destinationLatLng != null) destinationLatLng!,
                  ];
            if (points.isEmpty) return;

            final lats = points.map((p) => p.latitude).toList();
            final lngs = points.map((p) => p.longitude).toList();
            final minLat = lats.reduce(min);
            final maxLat = lats.reduce(max);
            final minLng = lngs.reduce(min);
            final maxLng = lngs.reduce(max);

            final latPadding = (maxLat - minLat) * 0.3;
            final lngPadding = (maxLng - minLng) * 0.3;

            final bounds = LatLngBounds(
              LatLng(minLat - latPadding, minLng - lngPadding),
              LatLng(maxLat + latPadding, maxLng + lngPadding),
            );

            _mapController.fitCamera(
              CameraFit.bounds(
                bounds: bounds,
                padding: const EdgeInsets.all(60),
              ),
            );
          } catch (e) {
            setState(() {
              errorMessage = 'Unable to display route. Please try again.';
            });
          }
        }
      });
    }
  }

  Future<void> _predictCrimeRisk() async {
    if (mainPoints.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No route points available for prediction',
            style: GoogleFonts.lora(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.red[800],
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final result = await _routeService.predictCrimeRisk(mainPoints);

    setState(() {
      isLoading = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CrimePredictionScreen(
          predictions: result['predictions'] ?? [],
          timestamp: result['timestamp'] ?? DateTime.now().toIso8601String(),
          isError: result['success'] != true,
          errorMessage: result['error'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Safe Route Navigation',
          style: GoogleFonts.lora(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
      ),

      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: sourceLatLng ?? _defaultCenter,
              initialZoom: 12.0,
              minZoom: 5.0,
              maxZoom: 18.0,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
                subdomains: const ['a', 'b', 'c', 'd'],
                retinaMode: RetinaMode.isHighDensity(context),
                userAgentPackageName: 'com.example.fyp',
              ),
              PolylineLayer(
                polylines: [
                  if (routePoints.isNotEmpty)
                    Polyline(
                      points: routePoints,
                      strokeWidth: 5.0,
                      color: AppColors.primaryColor.withOpacity(0.8),
                      borderStrokeWidth: 1.0,
                      borderColor: Colors.white.withOpacity(0.7),
                    ),
                ],
              ),
              MarkerLayer(
                markers: [
                  if (sourceLatLng != null)
                    Marker(
                      point: sourceLatLng!,
                      width: 48,
                      height: 48,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          CupertinoIcons.location_fill,
                          size: 32,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  if (destinationLatLng != null)
                    Marker(
                      point: destinationLatLng!,
                      width: 48,
                      height: 48,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          CupertinoIcons.location_solid,
                          size: 32,
                          color: Colors.red,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: SafeArea(
              child: GestureDetector(
                onTapDown: (_) => _animationController.forward(),
                onTapUp: (_) {
                  _animationController.reverse();
                  _predictCrimeRisk();
                },
                onTapCancel: () => _animationController.reverse(),
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'Predict Crime Risk',
                        style: GoogleFonts.lora(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: AppColors.primaryColor),
                    const SizedBox(height: 16),
                    Text(
                      'Loading Route...',
                      style: GoogleFonts.lora(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (errorMessage != null)
            Center(
              child: Card(
                color: Colors.white.withOpacity(0.95),
                elevation: 0,
                shadowColor: Colors.black.withOpacity(0.2),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        errorMessage!,
                        style: GoogleFonts.lora(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.red[800],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTapDown: (_) => _animationController.forward(),
                        onTapUp: (_) {
                          _animationController.reverse();
                          Navigator.pop(context);
                        },
                        onTapCancel: () => _animationController.reverse(),
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              'Try Again',
                              style: GoogleFonts.lora(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
