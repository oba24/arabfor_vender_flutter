// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
// import 'package:easy_localization/easy_localization.dart' as lang;
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:saudimerchantsiller/helper/extintions.dart';

// import '../gen/assets.gen.dart';
// import '../helper/asset_image.dart';

// class SearchGoogleMap extends StatefulWidget {
//   final Function(LatLng, String) onChange;
//   final bool cancelSearch;
//   final bool? onSearch;
//   const SearchGoogleMap({Key? key, required this.onChange, required this.cancelSearch, this.onSearch}) : super(key: key);
//   @override
//   _SearchGoogleMapState createState() => _SearchGoogleMapState();
// }

// class _SearchGoogleMapState extends State<SearchGoogleMap> {
//   bool onSearch = false;
//   final search = TextEditingController();
//   final outoFoucs = FocusNode();
//   @override
//   void initState() {
//     onSearch = widget.onSearch ?? false;
//     super.initState();
//   }

//   Timer? _typingTimer;
//   bool _isTyping = false;
//   void _runTimer(String searchKey) {
//     if (_typingTimer != null && _typingTimer!.isActive) _typingTimer!.cancel();
//     _typingTimer = Timer(800.milliseconds, () {
//       if (!_isTyping) return;
//       _isTyping = false;
//       if (search.text.isEmpty) {
//         setState(() {
//           auto.clear();
//         });
//       } else {
//         autoCompleteSearch(searchKey);
//       }
//     });
//     _isTyping = true;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: AnimatedSwitcher(
//                 duration: 500.milliseconds,
//                 child: onSearch == true
//                     ? SizedBox(
//                         child: TextFormField(
//                           focusNode: outoFoucs,
//                           controller: search,
//                           onChanged: (v) {
//                             setState(() {
//                               onSearch = true;
//                             });
//                             _runTimer(v);
//                           },
//                           decoration: InputDecoration(
//                             fillColor: Colors.white,
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(24),
//                               borderSide: BorderSide.none,
//                             ),
//                             hintText: context.locale.languageCode == "en" ? "Type what you want to search for" : "اكتب ما تريد البحث عنه",
//                             hintStyle: context.textTheme.bodyText1?.copyWith(fontSize: 16, color: Colors.grey),
//                             filled: true,
//                             contentPadding: EdgeInsets.all(8.h),
//                             prefixIcon: IconButton(
//                               onPressed: () {
//                                 if (widget.onSearch != true) {
//                                   setState(() {
//                                     onSearch = !onSearch;
//                                   });
//                                 }
//                               },
//                               icon: CustomIconImg(Assets.svg.iconSearch, color: context.color.primary),
//                             ),
//                           ),
//                         ),
//                       )
//                     : Row(
//                         children: [
//                           IconButton(
//                             onPressed: () {
//                               setState(() {
//                                 onSearch = !onSearch;
//                               });
//                             },
//                             icon: CustomIconImg(Assets.svg.iconSearch, color: context.color.primary),
//                           ),
//                         ],
//                       ),
//               ),
//             ),
//           ],
//         ),
//         if (auto.isNotEmpty && search.text.length > 1)
//           AnimatedSwitcher(
//             duration: const Duration(milliseconds: 500),
//             child: Container(
//               margin: EdgeInsets.only(top: 10.h),
//               height: MediaQuery.of(context).size.height / 3,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 color: Colors.white.withOpacity(0.8),
//               ),
//               child: ListView.builder(
//                 itemCount: auto.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     onTap: () async {
//                       Result location = await getPositionLocation(auto[index].placeId);
//                       if (location != null) {
//                         widget.onChange(
//                           LatLng(
//                             location.geometry.location.lat,
//                             location.geometry.location.lng,
//                           ),
//                           location.formattedAddress,
//                         );
//                       }
//                       setState(() {
//                         auto.clear();
//                       });
//                       search.clear();
//                       outoFoucs.unfocus();
//                     },
//                     title: Text(auto[index].description),
//                   );
//                 },
//               ),
//             ),
//           ),
//       ],
//     );
//   }

//   // double opacityLevel = 1.0;

//   // void _changeOpacity() {
//   //   setState(() => opacityLevel = opacityLevel == 0 ? 1.0 : 0.0);
//   // }

//   autoCompleteSearch(String input) async {
//     try {
//       final response = await http.get(
//         Uri.parse(
//           "https://maps.googleapis.com/maps/api/place/autocomplete/json?key=AIzaSyAITrPfT5r_qmCm_8ekZyPmnebGo8o_r18&input=$input",
//         ),
//       );

//       AutoComplete _model = AutoComplete.fromJson(json.decode(response.body));

//       print(response.body);
//       setState(() {
//         auto = _model.predictions;
//       });
//       // _changeOpacity();
//     } catch (e) {
//       print(e);
//       setState(() {
//         auto = [];
//       });
//     }
//   }

//   Future<Result> getPositionLocation(String placeid) async {
//     try {
//       final response = await http.get(
//         Uri.parse(
//           "https://maps.googleapis.com/maps/api/place/details/json?key=AIzaSyAITrPfT5r_qmCm_8ekZyPmnebGo8o_r18&placeid=$placeid",
//         ),
//       );
//       _positionLocation = PositionLocation.fromJson(json.decode(response.body));
//       print(response.body);
//       return _positionLocation.result;
//     } catch (e) {
//       print(e);
//       setState(() {
//         auto = [];
//       });
//       search.clear();
//       return null;
//     }
//   }

//   List<Prediction> auto = [];
//   PositionLocation _positionLocation;
// }

// class AutoComplete {
//   AutoComplete({
//     this.predictions,
//   });

//   List<Prediction> predictions;

//   factory AutoComplete.fromJson(Map<String, dynamic> json) => AutoComplete(
//         predictions: json["predictions"] == null ? null : List<Prediction>.from(json["predictions"].map((x) => Prediction.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "predictions": predictions == null ? null : List<dynamic>.from(predictions.map((x) => x.toJson())),
//       };
// }

// class Prediction {
//   Prediction({
//     this.description,
//     this.placeId,
//   });

//   String description;
//   String placeId;

//   factory Prediction.fromJson(Map<String, dynamic> json) => Prediction(
//         description: json["description"] == null ? null : json["description"],
//         placeId: json["place_id"] == null ? null : json["place_id"],
//       );

//   Map<String, dynamic> toJson() => {
//         "description": description == null ? null : description,
//         "place_id": placeId == null ? null : placeId,
//       };
// }

// class PositionLocation {
//   PositionLocation({
//     this.result,
//   });

//   Result result;

//   factory PositionLocation.fromJson(Map<String, dynamic> json) => PositionLocation(
//         result: json["result"] == null ? null : Result.fromJson(json["result"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "result": result == null ? null : result.toJson(),
//       };
// }

// class Result {
//   Result({
//     this.formattedAddress,
//     this.geometry,
//   });

//   String formattedAddress;
//   Geometry geometry;

//   factory Result.fromJson(Map<String, dynamic> json) => Result(
//         formattedAddress: json["formatted_address"] == null ? null : json["formatted_address"],
//         geometry: json["geometry"] == null ? null : Geometry.fromJson(json["geometry"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "formatted_address": formattedAddress == null ? null : formattedAddress,
//         "geometry": geometry == null ? null : geometry.toJson(),
//       };
// }

// class Geometry {
//   Geometry({
//     this.location,
//   });

//   Location location;

//   factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
//         location: json["location"] == null ? null : Location.fromJson(json["location"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "location": location == null ? null : location.toJson(),
//       };
// }

// class Location {
//   Location({
//     this.lat,
//     this.lng,
//   });

//   double lat;
//   double lng;

//   factory Location.fromJson(Map<String, dynamic> json) => Location(
//         lat: json["lat"] == null ? null : json["lat"].toDouble(),
//         lng: json["lng"] == null ? null : json["lng"].toDouble(),
//       );

//   Map<String, dynamic> toJson() => {
//         "lat": lat == null ? null : lat,
//         "lng": lng == null ? null : lng,
//       };
// }
