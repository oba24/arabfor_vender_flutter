import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:saudimerchantsiller/common/btn.dart';
import 'package:saudimerchantsiller/helper/extintions.dart';
import 'package:saudimerchantsiller/helper/flash_helper.dart';
import 'package:saudimerchantsiller/helper/location_helper.dart';
import '../generated/locale_keys.g.dart';

class PickLocationMap extends StatefulWidget {
  final LatLng? latLng;
  final Function(String locationName, LatLng latLng) onSelect;

  const PickLocationMap({Key? key, required this.onSelect, this.latLng})
      : super(key: key);

  @override
  _PickLocationMapState createState() => _PickLocationMapState();
}

class _PickLocationMapState extends State<PickLocationMap> {
  final Completer<GoogleMapController> _controller = Completer();

  // String _mapStyle;
  String? _locationName;
  late LatLng _latLong;
  late CameraPosition _kGooglePlex;
  late GoogleMapController mapController;
  Set<Marker> markers = {};

  @override
  void initState() {
    _latLong = widget.latLng ?? const LatLng(24.7249328, 47.1020293);

    super.initState();
    _kGooglePlex = CameraPosition(
      target: _latLong,
      zoom: 8.4746,
    );
    // rootBundle.loadString('assets/map_style.txt').then((string) {
    //   _mapStyle = string;
    // });
  }

  // Timer? _timer;
  // _onCameraMove(void Function(CameraPosition)? onCameraMove) {
  //   if (_timer != null && _timer!.isActive) _timer!.cancel();
  //   _timer = Timer(500.milliseconds, () {
  //     //// add your function here ////
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            initialCameraPosition: _kGooglePlex,
            markers: LocationHelper.markers,
            onCameraMove: (position) {
              _latLong = position.target;
            },
            onTap: (argument) {
              _goToTheLake(argument);
            },
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              mapController = controller;
              // mapController.setMapStyle(_mapStyle);
            },
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SearchGoogleMap(
                    //   onChange: (lat, lng) {
                    //     _goToTheLake(lat);
                    //     _locationName = lng;
                    //   },
                    // ),
                    Container(
                      decoration: BoxDecoration(
                          color: context.color.primary, shape: BoxShape.circle),
                      child: IconButton(
                        icon: Icon(
                          Icons.gps_fixed,
                          color: context.color.secondary,
                        ),
                        onPressed: () async {
                          var _location = await LocationHelper.getLocation();
                          if (_location != null) {
                            LocationHelper.setMarkers(
                                LatLng(_location.lat, _location.lng));
                            _goToTheLake(LatLng(_location.lat, _location.lng));
                            setState(() {
                              _locationName = _location.desc;
                              _latLong = LatLng(_location.lat, _location.lng);
                            });
                          } else {
                            FlashHelper.infoBar(
                                message: LocaleKeys.failed_to_get_your_location
                                    .tr());
                          }
                          // LocationHelper.getLocation().then((value) {
                          //   if (value != null) {
                          //     _latLong = LatLng(value.latitude, value.longitude);
                          //     _goToTheLake(LatLng(value.latitude, value.longitude));
                          //     LocationHelper()
                          //         .getPlacemarks(
                          //       latLng: LatLng(
                          //         value.latitude,
                          //         value.longitude,
                          //       ),
                          //     )
                          //         .then((value) {
                          //       _locationName = "${value.street}";
                          //     });
                          //   }
                          // });
                        },
                      ),
                    )
                  ],
                ).paddingAll(24.w),
              ),
              const Expanded(child: SizedBox()),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.all(40.h),
                  child: Btn(
                    onTap: () {
                      Navigator.pop(context);
                      widget.onSelect(_locationName ?? "", _latLong);
                    },
                    text: LocaleKeys.selecte_your_location.tr(),
                    textColor: context.color.secondary,
                    color: context.color.primary,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _goToTheLake(LatLng latLng) async {
    final GoogleMapController controller = await _controller.future;
    _latLong = latLng;
    var desc = await LocationHelper.getPlacemarks(latLng);
    _locationName = desc.street;

    LocationHelper.setMarkers(latLng);
    setState(() {});
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: latLng,
          zoom: 12,
        ),
      ),
    );
  }
}
