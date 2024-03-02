import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geofence_service/geofence_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:soko_flow/controllers/geolocation_controller.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatefulWidget {
  const ExampleApp({Key? key}) : super(key: key);

  @override
  _ExampleAppState createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  final _activityStreamController = StreamController<Activity>();
  final _geofenceStreamController = StreamController<Geofence>();


  // Create a [GeofenceService] instance and set options.
  final _geofenceService = GeofenceService.instance.setup(
      interval: 5000,
      accuracy: 100,
      loiteringDelayMs: 60000,
      statusChangeDelayMs: 10000,
      useActivityRecognition: true,
      allowMockLocations: true,
      printDevLog: true,
      geofenceRadiusSortType: GeofenceRadiusSortType.DESC);

  // Create a [Geofence] list.

  static final Logger _log = Logger(
    printer: PrettyPrinter(),
  );

  List<Geofence> _geofenceActive = <Geofence>[];
  List<Geofence> _geofenceList = <Geofence>[];
  List<Geofence> _geofenceList1= <Geofence>[
    Geofence(
      id: 'place_1',
      latitude: -1.2837976080820288,
      longitude: 36.888925220840434,
      radius: [
        GeofenceRadius(id: 'radius_100m', length: 100),
        GeofenceRadius(id: 'radius_25m', length: 25),
      ],
    ),
    Geofence(
      id: 'place_2',
      latitude: -1.2324524259580383,
      longitude: 36.92714533668971,
      radius: [
        GeofenceRadius(id: 'radius_25m', length: 25),
        GeofenceRadius(id: 'radius_100m', length: 100),
      ],
    ),
    Geofence(
      id: 'DI',
      latitude: -1.2787034,
      longitude: 36.7791394,
      radius: [
        GeofenceRadius(id: 'radius_10m', length: 10),
        GeofenceRadius(id: 'radius_100m', length: 100),
      ],
    ),
    Geofence(
      id: 'DI Point 2',
      latitude: -1.283110,
      longitude: 36.785399,
      radius: [
        GeofenceRadius(id: 'radius_10m', length: 10),
        GeofenceRadius(id: 'radius_100m', length: 100),
      ],
    ),
    Geofence(
      id: 'My Place',
      latitude: -1.27924046,
      longitude: 36.90724691,
      radius: [
        GeofenceRadius(id: 'radius_10m', length: 10),
        GeofenceRadius(id: 'radius_100m', length: 100),
      ],
    ),
  ];

  // This function is to be called when the geofence status is changed.
  Future<void> _onGeofenceStatusChanged(
      Geofence geofence,
      GeofenceRadius geofenceRadius,
      GeofenceStatus geofenceStatus,
      Location location) async {

    if(geofenceStatus == GeofenceStatus.EXIT){
      _geofenceActive.remove(geofence);
    }else if(geofenceStatus == GeofenceStatus.ENTER){
      _geofenceActive.add(geofence);
    }
    print('geofence: ${geofence.toJson()}');
    _log.i('geofence: ${geofence.toJson()}');
    print('geofenceRadius: ${geofenceRadius.toJson()}');
    print('geofenceStatus: ${geofenceStatus.toString()}');
    _geofenceStreamController.sink.add(geofence);
  }

  // This function is to be called when the activity has changed.
  void _onActivityChanged(Activity prevActivity, Activity currActivity) {
    print('prevActivity: ${prevActivity.toJson()}');
    print('currActivity: ${currActivity.toJson()}');
    _activityStreamController.sink.add(currActivity);
  }

  // This function is to be called when the location has changed.
  void _onLocationChanged(Location location) {
    print('location: ${location.toJson()}');
  }

  // This function is to be called when a location services status change occurs
  // since the service was started.
  void _onLocationServicesStatusChanged(bool status) {
    print('isLocationServicesEnabled: $status');
  }

  // This function is used to handle errors that occur in the service.
  void _onError(error) {
    final errorCode = getErrorCodesFromError(error);
    if (errorCode == null) {
      print('Undefined error: $error');
      return;
    }

    print('ErrorCode: $errorCode');
  }
  final geofenceService = GeofenceService.instance.setup(
      interval: 5000,
      accuracy: 100,
      loiteringDelayMs: 60000,
      statusChangeDelayMs: 10000,
      useActivityRecognition: true,
      allowMockLocations: true,
      printDevLog: true,
      geofenceRadiusSortType: GeofenceRadiusSortType.DESC);


  @override
  void initState() {
    super.initState();
    _geofenceList1.forEach((element) {
      _geofenceList.add(element);
    });
    // _geofenceList.addAll(_geofenceList1);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _geofenceService.addGeofenceStatusChangeListener(_onGeofenceStatusChanged);
      _geofenceService.addLocationChangeListener(_onLocationChanged);
      _geofenceService.addLocationServicesStatusChangeListener(_onLocationServicesStatusChanged);
      _geofenceService.addActivityChangeListener(_onActivityChanged);
      _geofenceService.addStreamErrorListener(_onError);
      _geofenceService.start(_geofenceList).catchError(_onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillStartForegroundTask(

      onWillStart: () async {
        // You can add a foreground task start condition.
        return _geofenceService.isRunningService;
      },
      foregroundTaskOptions: const ForegroundTaskOptions(
        interval: 5000,
        autoRunOnBoot: false,
        allowWifiLock: false,
      ),
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'geofence_service_notification_channel',
        channelName: 'Geofence Service Notification',
        channelDescription: 'This notification appears when the geofence service is running in the background.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        isSticky: false,
      ),
      iosNotificationOptions: const IOSNotificationOptions(),
      notificationTitle: 'Geofence Service is running',
      notificationText: 'Tap to return to the app',
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Geofence Service'),
          centerTitle: true,
        ),
        body: _buildContentView(),
      ),
    );
  }

  @override
  void dispose() {
    _activityStreamController.close();
    _geofenceStreamController.close();
    super.dispose();
  }

  Widget _buildContentView() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(8.0),
      children: [
        _buildActivityMonitor(),
        const SizedBox(height: 20.0),
        _buildGeofenceMonitor(),
      ],
    );
  }

  Widget _buildActivityMonitor() {
    return StreamBuilder<Activity>(
      stream: _activityStreamController.stream,
      builder: (context, snapshot) {
        final updatedDateTime = DateTime.now();
        final content = snapshot.data?.toJson().toString() ?? '';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('•\t\tActivity (updated: $updatedDateTime)'),
            const SizedBox(height: 10.0),
            Text(content),
          ],
        );
      },
    );
  }

  Widget _buildGeofenceMonitor() {
    return StreamBuilder<Geofence>(
      stream: _geofenceStreamController.stream,
      builder: (context, snapshot) {
        final updatedDateTime = DateTime.now();
        // final content = snapshot.data?.toJson() ;
        // GeofenceData g_c = GeofenceData();

        // if(content != null){
        //
        //   // GeofenceData g_c = GeofenceData.fromJson(content);
        //   return Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       // Text('•\t\tGeofence (updated: $updatedDateTime)'),
        //       // const SizedBox(height: 10.0),
        //       // Text("Place ${g_c.id.toString()} Geofence Status 25m ${g_c.status.toString()} for radius ${g_c.radius![0].length}"),
        //       // Text("Place ${g_c.id.toString()} Geofence Status 100m ${g_c.status.toString()} for radius ${g_c.radius![1].length}"),
        //       // SizedBox(height: 20,),
        //
        //       for (Geofence fence in _geofenceActive)
        //         Column(
        //           children: [
        //             Text("Place ${fence.id.toString()} Geofence Status 25m ${fence.status.toString()} for radius ${fence.radius[0].length}"),
        //             Text("Place ${fence.id.toString()} Geofence Status 25m ${fence.status.toString()} for radius ${fence.radius[1].length}"),
        //           ],
        //         )
        //     ],
        //   );
        // }
        // else{
        //   return Text("No data geofence data");
        // }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text('•\t\tGeofence (updated: $updatedDateTime)'),
            // const SizedBox(height: 10.0),
            // Text("Place ${g_c.id.toString()} Geofence Status 25m ${g_c.status.toString()} for radius ${g_c.radius![0].length}"),
            // Text("Place ${g_c.id.toString()} Geofence Status 100m ${g_c.status.toString()} for radius ${g_c.radius![1].length}"),
            // SizedBox(height: 20,),

            for (Geofence fence in _geofenceActive)
              Column(
                children: [
                  Text("Place ${fence.id.toString()} Geofence Status 25m ${fence.status.toString()} for radius ${fence.radius[0].length}"),
                  Text("Place ${fence.id.toString()} Geofence Status 25m ${fence.status.toString()} for radius ${fence.radius[1].length}"),
                ],
              )
          ],
        );
        // print(content["status"]);



      },
    );
  }
}

// To parse this JSON data, do
//
//     final geofenceData = geofenceDataFromJson(jsonString);

GeofenceData geofenceDataFromJson(String str) => GeofenceData.fromJson(json.decode(str));

String geofenceDataToJson(GeofenceData data) => json.encode(data.toJson());

class GeofenceData {
  GeofenceData({
    this.id,
    this.data,
    this.latitude,
    this.longitude,
    this.radius,
    this.status,
    this.timestamp,
    this.remainingDistance,
  });

  String? id;
  dynamic data;
  double? latitude;
  double? longitude;
  List<RadiusModel>? radius;
  GeofenceStatus? status;
  String? timestamp;
  double? remainingDistance;

  // bool? _success;
  // String? _message;
  //
  // late List<AllocationHistoryModel> _allocationHistory;
  // List<AllocationHistoryModel> get allocationsHist => _allocationHistory;
  //
  // GeofenceData.fromJson(Map<String, dynamic> json) {
  //   _success = json['success'];
  //   _message = json['message'];
  //   if (json['allocation_history_model'] != null) {
  //     _allocationHistory = <AllocationHistoryModel>[];
  //     json['allocation_history_model'].forEach((v) {
  //       _allocationHistory.add(AllocationHistoryModel.fromJson(v));
  //     });
  //   }
  // }


  factory GeofenceData.fromJson(Map<String, dynamic> json) => GeofenceData(
    id: json["id"],
    data: json["data"],
    latitude: json["latitude"].toDouble(),
    longitude: json["longitude"].toDouble(),
    radius: List<RadiusModel>.from(json["radius"].map((x) => RadiusModel.fromJson(x))),
    status: json["status"],
    // timestamp: DateTime.parse(json["timestamp"]).toString(),
    remainingDistance: json["remainingDistance"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "data": data,
    "latitude": latitude,
    "longitude": longitude,
    "radius": List<dynamic>.from(radius!.map((x) => x.toJson())),
    "status": status,
    "timestamp": timestamp!,
    "remainingDistance": remainingDistance,
  };
}

class RadiusModel {
  RadiusModel({
    this.id,
    this.data,
    this.length,
    this.status,
    this.activity,
    this.speed,
    this.timestamp,
    this.remainingDistance,
  });

  String? id;
  dynamic? data;
  double? length;
  GeofenceStatus? status;
  Activity? activity;
  double? speed;
  String? timestamp;
  double? remainingDistance;

  factory RadiusModel.fromJson(Map<String, dynamic> json) => RadiusModel(
    id: json["id"],
    data: json["data"],
    length: json["length"],
    status: json["status"],
    // activity: Activity.fromJson(json["activity"]),
    speed: json["speed"],
    // timestamp: DateTime.parse(json["timestamp"]).toString(),
    remainingDistance: json["remainingDistance"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "data": data,
    "length": length,
    "status": status,
    "activity": activity!.toJson(),
    "speed": speed,
    "timestamp": timestamp!,
    "remainingDistance": remainingDistance,
  };
}
//
// class Activity {
//   Activity({
//     this.type,
//     this.confidence,
//   });
//
//   String? type;
//   String? confidence;
//
//   factory Activity.fromJson(Map<String, dynamic> json) => Activity(
//     type: json["type"],
//     confidence: json["confidence"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "type": type,
//     "confidence": confidence,
//   };
// }
