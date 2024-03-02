import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:soko_flow/models/customer_model/customer_model.dart';
import 'package:soko_flow/views/errors/empty_failure_no_internet_view.dart';

class CustomerMapView extends StatefulWidget {
  final List<CustomerDataModel> customer;
  const CustomerMapView({Key? key, required this.customer}) : super(key: key);

  @override
  State<CustomerMapView> createState() => _CustomerMapViewState();
}

class _CustomerMapViewState extends State<CustomerMapView> {
  Set<Marker> _markers = {};

  GoogleMapController? _controller;

  // static const LatLng _center = const LatLng(45.521563, -122.677433);

  Future<void> _onMapCreated(GoogleMapController controller) async {
    // final googleOffices = await locations.getGoogleOffices();
    // _controller = controller;
    // _controller!.animateCamera(CameraUpdate.newCameraPosition(
    //   CameraPosition(target: LatLng(double.parse(customer.latitude!), double.parse(customer.longitude!)),zoom: 15),
    // ),);
    _markers.clear();
    widget.customer.forEach((customer) {
      print(
          "on maap create : ${LatLng(double.parse(customer.latitude!), double.parse(customer.longitude!))}");
      setState(() {
        final marker = Marker(
            markerId: MarkerId(customer.customerName!),
            position: LatLng(double.parse(customer.latitude!),
                double.parse(customer.longitude!)),
            infoWindow: InfoWindow(
                title: customer.customerName, snippet: customer.address),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueOrange));
        _markers.add(marker);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(LatLng(double.parse(widget.customer.latitude!), double.parse(widget.customer.latitude!)));
    return Scaffold(
      body: widget.customer.isEmpty?SingleChildScrollView(
        physics:
        BouncingScrollPhysics(),
        child:
        EmptyFailureNoInternetView(
          image:
          'lottie/no_search.json',
          title: 'No customers to map',
          description: "",
          buttonText: "Refresh",
          onPressed: () {
          },
        ),
      ):SafeArea(
        child: Container(
          child: GoogleMap(
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(double.parse(widget.customer[0].latitude!),
                    double.parse(widget.customer[0].longitude!)),
                zoom: 11,
              ),
              markers: Set<Marker>.of(_markers)),
        ),
      ),
    );
  }
}
