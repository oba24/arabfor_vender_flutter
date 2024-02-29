import 'dart:async';
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as locat;
import '../generated/locale_keys.g.dart';

import '../main.dart';

class LocationHelper {
  static late String getAddressName;
  static bool loading = false;
  static Future<bool> _checkGps() async {
    var location = locat.Location();
    bool checkGps;
    if (!await location.serviceEnabled()) {
      checkGps = await location.requestService();
    } else if (await location.hasPermission() == locat.PermissionStatus.denied) {
      checkGps = await location.requestService();
    } else {
      checkGps = true;
    }
    return checkGps;
  }

  static UserLocation? userLocation;
  static Future<UserLocation?> getLocation() async {
    userLocation = _getSaveLocation();
    if (userLocation != null) return userLocation;
    locat.Location location = locat.Location();
    bool _gps = await _checkGps();
    if (_gps == true) {
      bool _serviceEnabled;
      locat.PermissionStatus _permissionGranted;
      locat.LocationData _locationData;
      location.hasPermission();
      _serviceEnabled = await location.serviceEnabled();

      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return null;
        }
      }
      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == locat.PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != locat.PermissionStatus.granted) {
          return null;
        }
      }
      _locationData = await location.getLocation();
      geo.Placemark _disc = await getPlacemarks(LatLng(_locationData.latitude!, _locationData.longitude!));
      return _saveLocation(_locationData, _disc.street ?? LocaleKeys.unknow_address.tr());
    } else {
      return null;
    }
  }

  static UserLocation _saveLocation(locat.LocationData locationData, String desc) {
    UserLocation _data = UserLocation(
      lat: locationData.latitude!,
      dateTime: DateTime.now(),
      lng: locationData.longitude!,
      desc: desc,
      isAvilable: false,
    );
    Prefs.setString("location_data", jsonEncode(_data.toMap()));
    return _data;
  }

  static UserLocation? _getSaveLocation() {
    UserLocation _data;
    String result = Prefs.getString("location_data") ?? "";
    if (result != "") {
      _data = UserLocation.fromMap(jsonDecode(result));
      return _data.isAvilable ? _data : null;
    }
    return null;
  }

  // String sessionToken = Uuid().generateV4();

  static Future<geo.Placemark> getPlacemarks(LatLng latLng) async {
    try {
      List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      getAddressName = placemarks[0].street ?? "";
      return placemarks[0];
    } catch (e) {
      List<geo.Placemark> placemarks = [geo.Placemark(locality: "لا يوجد عنوان")];
      return placemarks[0];
    }
  }

  static BitmapDescriptor? _customIcon;
  static Set<Marker> markers = {};
  static Future<Set<Marker>> setMarkers(LatLng latLng, {MarkerId? markerId}) async {
    markers.clear();

    // if (_customIcon == null) {
    //   ImageConfiguration configuration = createLocalImageConfiguration(navigator.currentContext!);
    //   _customIcon = await BitmapDescriptor.fromAssetImage(configuration, 'assets/icons/marker.png');
    // }
    markers.add(
      Marker(markerId: markerId ?? const MarkerId('1'), icon: _customIcon ?? BitmapDescriptor.defaultMarker, position: latLng),
    );

    return markers;
  }
}

class UserLocation {
  UserLocation({required this.dateTime, required this.desc, required this.lat, required this.lng, required this.isAvilable});
  String desc;
  double lat;
  double lng;
  DateTime dateTime;
  bool isAvilable;

  factory UserLocation.fromMap(Map<String, dynamic> json) => UserLocation(
        dateTime: DateTime.parse(json["locationData_time"]),
        lat: json["locationData_latitude"],
        lng: json["locationData_longitude"],
        desc: json["locationData_desc"],
        isAvilable: DateTime.now().difference(DateTime.parse(json["locationData_time"])).inHours < 25,
      );

  Map<String, dynamic> toMap() => {
        "locationData_time": dateTime.toString(),
        "locationData_latitude": lat,
        "locationData_longitude": lng,
        "locationData_desc": desc,
      };
}
