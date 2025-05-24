import 'package:flutter/material.dart';

import 'google_map_with_geolocator.dart';


void main(){
  runApp(const GoogleMapsApp() );
}

class GoogleMapsApp extends StatelessWidget {
  const GoogleMapsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GoogleMapWithGeolocator(),
    );
  }
}
