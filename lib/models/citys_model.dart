class CitiesDatum {
  int id;
  String name;
  CitiesDatum({this.id = 0, this.name = ""});

  factory CitiesDatum.fromJson(Map<String, dynamic> json) => CitiesDatum(id: json["id"] ?? 0, name: json["name"] ?? "");

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
