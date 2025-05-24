import 'package:flutter/material.dart';
import 'package:location/location.dart';

class GpsHomeScreen extends StatefulWidget {
  const GpsHomeScreen({super.key});

  @override
  State<GpsHomeScreen> createState() => _GpsHomeScreenState();
}

class _GpsHomeScreenState extends State<GpsHomeScreen> {
  LocationData ? currentLocation;
  Future<void> _getCurrentLocation()async{
    // TODO: check if the app has permission
    bool isPermissionEnabled = await _isLocationPermissionEnable();
    if(isPermissionEnabled){
      // TODO: check if the GPS service on/off
      bool isGpsServiceEnabled = await Location.instance.serviceEnabled();

      if(isGpsServiceEnabled){
        //TODO:Get current location
        Location.instance.changeSettings(accuracy: LocationAccuracy.balanced);
        LocationData locationData = await Location.instance.getLocation();
        print(locationData);
        currentLocation = locationData;
        setState(() {});
      }else{
        //TODO: if not,then move to gps service settings
        Location.instance.requestService();
      }

    }else{
      // TODO: if not,then request the permission
      bool isPermissionGranted = await _requestPermission();
      if(isPermissionGranted){
        _getCurrentLocation();
      }
    }
  }

  Future<void> _listenCurrentLocation()async{
    // TODO: check if the app has permission
  bool isPermissionEnabled = await _isLocationPermissionEnable();
  if(isPermissionEnabled){
    // TODO: check if the GPS service on/off
    bool isGpsServiceEnabled = await Location.instance.serviceEnabled();

    if(isGpsServiceEnabled){
     //TODO:Get current location
      Location.instance.changeSettings(accuracy: LocationAccuracy.balanced,interval: 10000,distanceFilter: 3);

      Location.instance.onLocationChanged.listen((LocationData location){
        print(location);
      });

    }else{
      //TODO: if not,then move to gps service settings
     Location.instance.requestService();
    }

  }else{
    // TODO: if not,then request the permission
    bool isPermissionGranted = await _requestPermission();
    if(isPermissionGranted){
      _listenCurrentLocation();
    }
   }
  }

  Future<bool> _isLocationPermissionEnable()async {
    PermissionStatus locationPermission =
    await Location.instance.hasPermission();
    if (locationPermission == PermissionStatus.granted ||
        locationPermission == PermissionStatus.grantedLimited) {
      return true;
    } else {
      return false;
    }
  }
    Future<bool> _requestPermission ()async {
      PermissionStatus locationPermission =
      await Location.instance.requestPermission();
      if (locationPermission == PermissionStatus.granted ||
          locationPermission == PermissionStatus.grantedLimited) {
        return true;
      } else {
        return false;
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gps Service Home"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Current Location:${currentLocation?.latitude},${currentLocation?.longitude}"),
            TextButton(onPressed: (){
              _getCurrentLocation();
            },
                child:Text("Get Current Location")),
            TextButton(onPressed: (){
              _listenCurrentLocation();
            },
                child:Text("Listen Current Location"))
          ],
        ),
      ),
    );
  }
}
