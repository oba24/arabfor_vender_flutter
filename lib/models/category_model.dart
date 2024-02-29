class CategoryDatum {
  CategoryDatum({
    required this.id,
    required this.name,
    required this.desc,
    this.categoryImage,
  });

  int id;
  String name;
  String desc;
  String? categoryImage;

  factory CategoryDatum.fromJson(Map<String, dynamic> json) => CategoryDatum(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        desc: json["desc"] ?? "",
        categoryImage: json["category_image"] ?? json["sub_category_image"],
      );
}
