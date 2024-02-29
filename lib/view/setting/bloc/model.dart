import 'package:google_maps_flutter/google_maps_flutter.dart';

class SettingModel {
  SettingModel({
    required this.question,
    required this.message,
    required this.support,
  });

  List<QuestionDatum> question;
  SupportDatum support;
  String message;

  factory SettingModel.questionFromjson(Map<String, dynamic> json) => SettingModel(
        question: List<QuestionDatum>.from((json["data"] ?? "").map((x) => QuestionDatum.fromJson(x))),
        support: SupportDatum.fromJson({}),
        message: json["message"] ?? "",
      );

  factory SettingModel.supportFromJson(Map<String, dynamic> json) => SettingModel(
        question: [],
        support: SupportDatum.fromJson(json["data"] ?? {}),
        message: json["message"],
      );
}

class QuestionDatum {
  QuestionDatum({
    required this.id,
    required this.question,
    required this.answer,
  });

  int id;
  String question;
  String answer;

  factory QuestionDatum.fromJson(Map<String, dynamic> json) => QuestionDatum(
        id: json["id"] ?? 0,
        question: json["question"] ?? "",
        answer: json["answer"] ?? "",
      );
}

class SupportDatum {
  SupportDatum({
    required this.phone,
    required this.email,
    required this.whatsapp,
    required this.social,
    required this.location,
  });

  String phone;
  String email;
  String whatsapp;
  Social social;
  LocationDatum location;

  factory SupportDatum.fromJson(Map<String, dynamic> json) => SupportDatum(
        phone: json["phone"] ?? "",
        email: json["email"] ?? "",
        whatsapp: json["whatsapp"] ?? "",
        social: Social.fromJson(json["social"] ?? {}),
        location: LocationDatum.fromJson(json["location"] ?? {}),
      );
}

class LocationDatum {
  LocationDatum({
    required this.latLng,
    required this.desc,
  });

  LatLng latLng;
  String desc;

  factory LocationDatum.fromJson(Map<String, dynamic> json) => LocationDatum(
        latLng: LatLng((json["lat"] ?? 24.7171365) + 0.0, (json["lng"] ?? 46.88265) + 0.0),
        desc: json["desc"] ?? "",
      );
}

class Social {
  Social({
    required this.facebook,
    required this.twitter,
    required this.instagram,
  });

  String facebook;
  String twitter;
  String instagram;
  List<String> get sochialList => [facebook, twitter, instagram];

  factory Social.fromJson(Map<String, dynamic> json) => Social(
        facebook: json["facebook"] ?? "",
        twitter: json["twitter"] ?? "",
        instagram: json["instagram"] ?? "",
      );
}
