import 'dart:io';

class ImageDatum {
  ImageDatum({
    required this.id,
    required this.url,
    required this.file,
  });

  int id;
  String url;
  File file;

  factory ImageDatum.fromJson(Map<String, dynamic> json) => ImageDatum(
        id: json["id"] ?? 0,
        url: json["url"] ?? "",
        file: File(json["url"] ?? ""),
      );
}
