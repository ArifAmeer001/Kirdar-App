import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc; // Alias the 'location' package
import 'package:http/http.dart' as http; // Import http package for API calls
import 'dart:convert'; // For JSON decoding

class HalalRestaurantScreen extends StatefulWidget {
  const HalalRestaurantScreen({super.key});

  @override
  _HalalRestaurantScreenState createState() => _HalalRestaurantScreenState();
}

class _HalalRestaurantScreenState extends State<HalalRestaurantScreen> {
  late GoogleMapController _mapController;
  LatLng _currentPosition = const LatLng(37.7749, -122.4194); // Default position
  Set<Marker> _markers = {};
  //final String _goMapsApiKey = 'AlzaSyV_OnPamijSWA7d-v1s2wAAF0tsUpJu79Y'; // Your GoMaps Pro API key
  final String _goMapsApiKey = 'AlzaSyh5H_BWW20TwjvRja-gEtkDcBVXBFb8cpI';
  late loc.LocationData _locationData;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    loc.Location location = loc.Location();

    bool _serviceEnabled;
    loc.PermissionStatus _permissionGranted;

    // Check if location services are enabled
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    // Check location permission
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == loc.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != loc.PermissionStatus.granted) {
        return;
      }
    }

    // Fetch the current location
    _locationData = await location.getLocation();

    // Set current position and update marker
    setState(() {
      _currentPosition = LatLng(_locationData.latitude!, _locationData.longitude!);
      // Add current location marker with blue color
      _markers.add(
        Marker(
          markerId: const MarkerId('currentLocation'),
          position: _currentPosition,
          infoWindow: const InfoWindow(title: 'Your Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue), // Set marker color to blue
        ),
      );
    });

    // Move the camera to the current location
    _mapController.animateCamera(CameraUpdate.newLatLngZoom(_currentPosition, 14.0));
  }

  Future<void> _searchNearbyHalalRestaurants() async {
    // Update the URL to search for restaurants instead of mosques
    final String url =
        'https://maps.gomaps.pro/maps/api/place/nearbysearch/json?location=${_currentPosition.latitude},${_currentPosition.longitude}&radius=5000&type=restaurant&keyword=halal&key=$_goMapsApiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Parse the response
      final data = json.decode(response.body);
      final results = data['results'];

      // Clear old markers
      setState(() {
        _markers.clear();

        // Add current location marker
        _markers.add(
          Marker(
            markerId: const MarkerId('currentLocation'),
            position: _currentPosition,
            infoWindow: const InfoWindow(title: 'Your Location'),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue), // Set marker color to blue
          ),
        );

        // Add Halal Restaurant markers to map
        for (var result in results) {
          _markers.add(
            Marker(
              markerId: MarkerId(result['place_id']),
              position: LatLng(result['geometry']['location']['lat'], result['geometry']['location']['lng']),
              infoWindow: InfoWindow(
                title: result['name'],
                snippet: result['vicinity'],
              ),
            ),
          );
        }
      });

      // Move the camera to fit all markers
      LatLngBounds bounds = _boundsFromMarkers(_markers);
      _mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    } else {
    }
  }

  LatLngBounds _boundsFromMarkers(Set<Marker> markers) {
    double? x0, x1, y0, y1;
    for (var marker in markers) {
      if (x0 == null) {
        x0 = x1 = marker.position.latitude;
        y0 = y1 = marker.position.longitude;
      } else {
        if (marker.position.latitude > x1!) x1 = marker.position.latitude;
        if (marker.position.latitude < x0) x0 = marker.position.latitude;
        if (marker.position.longitude > y1!) y1 = marker.position.longitude;
        if (marker.position.longitude < y0!) y0 = marker.position.longitude;
      }
    }
    return LatLngBounds(northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Halal Restaurant')),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _searchNearbyHalalRestaurants, // Updated function call
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: _currentPosition, zoom: 12),
        markers: _markers,
        onMapCreated: (controller) {
          _mapController = controller;
        },
      ),
    );
  }
}
