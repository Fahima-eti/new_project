import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GoogleMapWithGeolocator extends StatefulWidget {
  const GoogleMapWithGeolocator({super.key});

  @override
  State<GoogleMapWithGeolocator> createState() => _GoogleMapWithGeolocatorState();
}

class _GoogleMapWithGeolocatorState extends State<GoogleMapWithGeolocator> {

  GoogleMapController ? _mapController;
  Location _location = Location();
  Marker? _userMarker;
  List<LatLng> _polyline = [];
StreamSubscription<LocationData> ? _locationSubscription;

@override
  void initState() {
    super.initState();
_getCurrentLocation();
  }

  Future<void> _getCurrentLocation()async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return;
    }
    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted)
        return;
    }
    _locationSubscription = _location.onLocationChanged.listen((LocationData currentLocation){
      LatLng latLng = LatLng(currentLocation.latitude!, currentLocation.longitude!);
      
      setState(() {
        _userMarker = Marker(
            markerId:
            MarkerId("My Location"),
          position: latLng,
          infoWindow: InfoWindow(title:
          "My Current Location,${latLng}"
          ),
        );
        _polyline.add(latLng);
        print("Polyline length: ${_polyline.length}");
      });
      _mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: latLng,zoom: 10)
          ));
    });
  }
  @override
  void dispose(){
  _locationSubscription?.cancel();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Google Maps with Location"),
      ),
      body:GoogleMap(
        initialCameraPosition: CameraPosition(
            target: LatLng(23.9892775592208, 90.3817850930559),
        zoom: 16),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,

        onMapCreated: (GoogleMapController controller){
          _mapController = controller;
        },
        markers: _userMarker!=null ? {_userMarker!} : {},
    polylines:{
          Polyline(polylineId:PolylineId("StraightLine or route"),
            points: _polyline,
            color: Colors.blue,
            endCap: Cap.roundCap,
            startCap: Cap.roundCap,
            width: 8

          )
    },

      ),

    );
  }
}
