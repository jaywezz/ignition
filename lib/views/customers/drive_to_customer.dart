import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:soko_flow/configs/styles.dart';

import '../../controllers/find_me.dart';

class CustomerTrackingPage extends ConsumerStatefulWidget {
  const CustomerTrackingPage(
      {Key? key,
        required this.destination,
        required this.sourceLocation,
        required this.shopName})
      : super(key: key);
  final LatLng destination;
  final LatLng sourceLocation;
  final String shopName;
  @override
  ConsumerState<CustomerTrackingPage> createState() =>
      CustomerTrackingPageState();
}

class CustomerTrackingPageState extends ConsumerState<CustomerTrackingPage> {
  final Completer<GoogleMapController> _controller = Completer();
  //static const LatLng sourceLocation = LatLng(-1.4309, 36.6917);
  //static  LatLng destination = LatLng(widget.destination.latitude, 36.7644);

  //Draw route
  List<LatLng> polylineCoordinates = [];
  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyAxZ1URLS-svsDlkAxuS08u89nO_yink4A", // Your Google Map Key
      PointLatLng(
          widget.sourceLocation.latitude, widget.sourceLocation.longitude),
      PointLatLng(widget.destination.latitude, widget.destination.longitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach(
            (PointLatLng point) => polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      setState(() {});
    }
  }

  @override
  void initState() {
    getPolyPoints();
    getCurrentLocation();

    setCustomMarkerIcon();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    locationSubscription!.cancel();
    super.dispose();
  }

//Real time location

  //late LocationData currentLocation;
  LocationData? locationData;
  Location location = Location();
  StreamSubscription<LocationData>? locationSubscription;
  void getCurrentLocation() async {
    location.getLocation().then(
          (location) {
        locationData = location;
        setState(() {});
        print("My current location is $locationData");
      },
    );
    GoogleMapController googleMapController = await _controller.future;
    locationSubscription = location.onLocationChanged.listen(
          (newLoc) {
        googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: 13.5,
              target: LatLng(
                locationData!.latitude!,
                locationData!.longitude!,
              ),
            ),
          ),
        );
        locationData = newLoc;
        print("My new location is $locationData");
      },
    );
  }

  //Custom marker
  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;
  void setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, "assets/images/driving_pin.png")
        .then(
          (icon) {
        sourceIcon = icon;
      },
    );
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty,
        "assets/images/destination_map_marker.png")
        .then(
          (icon) {
        destinationIcon = icon;
      },
    );
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, "assets/images/driving_pin.png")
        .then(
          (icon) {
        currentLocationIcon = icon;
      },
    );
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  @override
  Widget build(BuildContext context) {
    //print("My current location is $locationData");
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          getCurrentLocation();
        },
        label: locationData == null
            ? Text("Loading")
            : Text(calculateDistance(
            widget.sourceLocation.latitude,
            widget.sourceLocation.longitude,
            widget.destination.latitude,
            widget.destination.longitude)
            .floorToDouble()
            .toString() +
            " km"),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            locationData == null
                ? const Center(child: Text("Loading"))
                : GoogleMap(
              zoomControlsEnabled: true,
              trafficEnabled: true,
              //liteModeEnabled: true,
              buildingsEnabled: true,
              myLocationEnabled: true,
              indoorViewEnabled: true,
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                tilt: 90,
                bearing: 30,
                target: LatLng(
                    locationData!.latitude!, locationData!.longitude!),
                zoom: 13.5,
              ),
              // markers: {
              //   const Marker(
              //     markerId: MarkerId("source"),
              //     position: sourceLocation,
              //   ),
              //   const Marker(
              //     markerId: MarkerId("destination"),
              //     position: destination,
              //   ),
              // },
              markers: {
                Marker(
                  markerId: const MarkerId("currentLocation"),
                  icon: currentLocationIcon,
                  position: LatLng(
                      locationData!.latitude!, locationData!.longitude!),
                ),
                Marker(
                  markerId: const MarkerId("source"),
                  icon: sourceIcon,
                  position: widget.sourceLocation,
                ),
                Marker(
                  markerId: MarkerId("destination"),
                  icon: destinationIcon,
                  position: widget.destination,
                ),
              },
              onMapCreated: (mapController) {
                _controller.complete(mapController);
              },
              polylines: {
                Polyline(
                  polylineId: const PolylineId("route"),
                  points: polylineCoordinates,
                  color: const Color(0xFF7B61FF),
                  width: 6,
                ),
              },
            ),
            Positioned(
              top: 40,
              left: 80,
              right: 80,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Styles.appPrimaryColor,
                ),
                child: Center(
                  child: Text(
                    widget.shopName,
                    style: GoogleFonts.poppins()
                        .copyWith(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
