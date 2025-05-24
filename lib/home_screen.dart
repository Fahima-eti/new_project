import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final GoogleMapController _mapController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: GoogleMap(
        mapType: MapType.terrain,
          initialCameraPosition:
          CameraPosition(
              zoom:14,
              target:LatLng(
                  22.7990846065496, 89.5672456546702)),
          zoomControlsEnabled: true,
        compassEnabled: true,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: (GoogleMapController controller){
          _mapController = controller;
        },
        onTap: (LatLng latLng){
          print(latLng);

        },
        markers:{ Marker(
            markerId:MarkerId("My location"),
        position: LatLng( 22.7990846065496, 89.5672456546702),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          onTap: () {
            print("Tapped on my marker");
          },
          visible: true,
          infoWindow: InfoWindow(
            title: "My location",
            onTap: (){
              print("Tapped on info window");
            }
          ),

        ),
          Marker(
            markerId:MarkerId("Your location"),
            position: LatLng( 22.79943032088203, 89.66680862009525),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
            onTap: () {
              print("Tapped on my marker");
            },
            visible: true,
            infoWindow: InfoWindow(
                title: "My location",
                onTap: (){
                  print("Tapped on info window");
                }
            ),

          ),
          Marker(
            markerId:MarkerId("Drag location"),
            position: LatLng( 22.93878334220189, 89.63211625814438),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
            onTap: () {
              print("Tapped on my marker");
            },
            visible: true,
            draggable: true,
            onDrag: (LatLng latLng){},
            onDragStart: (LatLng startedLatLng){},
            onDragEnd: (LatLng endLatLng){
              print(endLatLng);
            },
            infoWindow: InfoWindow(
                title: "My location",
                onTap: (){
                  print("Tapped on info window");
                }
            ),

          )},
        polylines : {
          Polyline(
            polylineId: PolylineId("StraightLine"),
            width: 10,
              color: Colors.pink,
              endCap: Cap.buttCap,
              startCap: Cap.buttCap,
              points: [
              LatLng(23.034135885480385, 89.6281848102808),
                LatLng(22.642876966117925, 89.63550891727209),
                LatLng(22.766668233225367, 89.52459923923016)
            ],
            jointType: JointType.round
          )
      },
        circles: {
          Circle(
            circleId: CircleId("virus"),
            center:LatLng(22.818178441955887, 89.56508751958609),
            radius: 2000,
            strokeWidth: 4,
            strokeColor: Colors.deepOrange,
            fillColor: Colors.deepOrange.withOpacity(0.2)
          )
        },
        polygons: {
          Polygon(
            polygonId: PolygonId("triangle"),
            fillColor: Colors.pink.withOpacity(0.2),
            strokeWidth: 2,
            strokeColor: Colors.black,
            points: [
              LatLng(22.67834680684862, 89.43972408771515),
              LatLng(22.54263835549381, 89.62126035243273),
              LatLng(22.44693417471604, 89.41670536994934)
            ]
          )
        },

      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.train),
          onPressed: (){
          _mapController.animateCamera(
            CameraUpdate.newCameraPosition(const 
            CameraPosition(
                zoom: 14,
                target: LatLng(
                22.804664490154035, 89.52701322734356)))
          );
      }),
    );
  }
  @override
  void dispose(){
    super.dispose();
    _mapController.dispose();
  }
}

