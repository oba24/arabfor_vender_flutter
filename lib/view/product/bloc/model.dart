import '../../../models/product_model.dart';

class ProductModel {
  ProductModel({
    required this.data,
    required this.links,
    required this.single,
    required this.status,
    required this.message,
  });

  List<ProductDatum> data;
  ProductDatum single;
  _Links links;
  String status;
  String? message;

  factory ProductModel.fromJson(Map<String, dynamic> json, bool isSingle) => ProductModel(
        data: isSingle ? [] : List<ProductDatum>.from((json["data"] ?? []).map((x) => ProductDatum.fromJson(x))),
        single: ProductDatum.fromJson(isSingle && json["data"] != null ? json["data"] : {}),
        links: _Links.fromJson(json["links"] ?? {}),
        status: json["status"] ?? "",
        message: json["message"],
      );
}

class _Links {
  _Links({
    this.first,
    this.last,
    this.prev,
    this.next,
  });

  String? first;
  String? last;
  String? prev;
  String? next;

  factory _Links.fromJson(Map<String, dynamic> json) => _Links(
        first: json["first"],
        last: json["last"],
        prev: json["prev"],
        next: json["next"],
      );
}

// class Meta {
//   Meta({
//     this.currentPage,
//     this.from,
//     this.lastPage,
//     this.links,
//     this.path,
//     this.perPage,
//     this.to,
//     this.total,
//   });

//   int currentPage;
//   int from;
//   int lastPage;
//   List<Link> links;
//   String path;
//   int perPage;
//   int to;
//   int total;

//   factory Meta.fromJson(Map<String, dynamic> json) => Meta(
//         currentPage: json["current_page"],
//         from: json["from"],
//         lastPage: json["last_page"],
//         links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
//         path: json["path"],
//         perPage: json["per_page"],
//         to: json["to"],
//         total: json["total"],
//       );

//   Map<String, dynamic> toJson() => {
//         "current_page": currentPage,
//         "from": from,
//         "last_page": lastPage,
//         "links": List<dynamic>.from(links.map((x) => x.toJson())),
//         "path": path,
//         "per_page": perPage,
//         "to": to,
//         "total": total,
//       };
// }

// class Link {
//   Link({
//     this.url,
//     this.label,
//     this.active,
//   });

//   String url;
//   String label;
//   bool active;

//   factory Link.fromJson(Map<String, dynamic> json) => Link(
//         url: json["url"] == null ? null : json["url"],
//         label: json["label"],
//         active: json["active"],
//       );

//   Map<String, dynamic> toJson() => {
//         "url": url == null ? null : url,
//         "label": label,
//         "active": active,
//       };
// }
