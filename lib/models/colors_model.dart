class ColorsDatum {
  ColorsDatum({
    required this.id,
    required this.hexValue,
    required this.name,
  });

  int id;
  String hexValue;
  String name;

  factory ColorsDatum.fromJson(Map<String, dynamic> json) => ColorsDatum(
        id: json["id"] ?? 0,
        hexValue: json["hex_value"] ?? "#000000",
        name: json["name"] ?? "",
      );

  @override
  bool operator ==(Object other) => identical(this, other) || other is ColorsDatum && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
