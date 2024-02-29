import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:saudimerchantsiller/models/category_model.dart';

import '../../../models/image_model.dart';
import '../../../models/product_model.dart';

class AddProductEvent {}

class StartAddProductEvent extends AddProductEvent {
  late List<ImageDatum> images;
  late TextEditingController productName, descreption, priceBeforeDicount, discountPercentage, quantity;
  late CategoryDatum mainCategory, subcategory;
  int? productId;

  late List<ProductDetailDatum> productDetailDatum;
  Map<String, dynamic> get body {
    Map<String, dynamic> _body = {
      "name": productName.text,
      "desc": descreption.text,
      "category_id": mainCategory.id,
      "sub_category_id": subcategory.id,
      "weight": 15,
      "delivery_price": 1,
      "delivery_time": 2,
      "price_before_dicount": priceBeforeDicount.text,
      "discount_percentage": discountPercentage.text,
      "quantity": quantity.text,
    };
    List<ProductDetailDatum> _productDetailDatum = productDetailDatum.toSet().toList();
    for (int i = 0; i < _productDetailDatum.length; i++) {
      if (_productDetailDatum[i].id == 0) {
        _body.addAll(
          {
            "product_details[$i][color_id]": _productDetailDatum[i].color.id,
            "product_details[$i][size_id]": _productDetailDatum[i].size.id,
          },
        );
      }
    }

    for (int i = 0; i < images.length; i++) {
      if (images[i].id == 0) {
        _body.addAll({"product_image[$i]": MultipartFile.fromFileSync(images[i].file.path)});
      }
    }
    return _body;
  }

  StartAddProductEvent() {
    images = [];
    productName = TextEditingController();
    descreption = TextEditingController();
    quantity = TextEditingController();
    priceBeforeDicount = TextEditingController();
    discountPercentage = TextEditingController();
    mainCategory = CategoryDatum.fromJson({});
    subcategory = CategoryDatum.fromJson({});
    productDetailDatum = [ProductDetailDatum.fromJson({})];
  }
  factory StartAddProductEvent.buildFromModel(ProductDatum data) {
    StartAddProductEvent _event = StartAddProductEvent();
    _event.images = data.productImage;
    _event.productId = data.id;
    _event.productName = TextEditingController(text: data.name);
    _event.descreption = TextEditingController(text: data.desc);
    _event.quantity = TextEditingController(text: data.quantity.toString());
    _event.priceBeforeDicount = TextEditingController(text: data.priceBeforeDicount.toString());
    _event.discountPercentage = TextEditingController(text: data.discountPercentage.toString());
    _event.mainCategory = data.category;
    _event.subcategory = data.subCategory;
    _event.productDetailDatum = data.productDetails;
    return _event;
  }
}
