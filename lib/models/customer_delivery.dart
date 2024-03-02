import 'dart:convert';

CustomerDeliveryModel customerDeliveryModelFromJson(String str) =>
    CustomerDeliveryModel.fromJson(json.decode(str));

String customerDeliveryModelToJson(CustomerDeliveryModel data) =>
    json.encode(data.toJson());

class CustomerDeliveryModel {
  CustomerDeliveryModel({
    required this.products,
  });

  List<dynamic> products;

  factory CustomerDeliveryModel.fromJson(Map<String, dynamic> json) =>
      CustomerDeliveryModel(
        products: List<dynamic>.from(json["productsModel"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "productsModel": List<dynamic>.from(products.map((x) => x)),
      };
}
