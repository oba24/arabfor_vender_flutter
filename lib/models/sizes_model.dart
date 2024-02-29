class SizesDatum {
  SizesDatum({
    required this.id,
    required this.name,
    required this.abbreviation,
  });

  int id;
  String name;
  String abbreviation;

  factory SizesDatum.fromJson(Map<String, dynamic> json) => SizesDatum(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        abbreviation: json["abbreviation"] ?? "",
      );
      
}
