import 'dart:convert';

CustomerCheckinDetailsModel customerCheckinDetailsModelFromJson(String str) =>
    CustomerCheckinDetailsModel.fromJson(json.decode(str));

String customerCheckinDetailsModelToJson(CustomerCheckinDetailsModel data) =>
    json.encode(data.toJson());

class CustomerCheckinDetailsModel {
  CustomerCheckinDetailsModel({
    this.success,
    this.message,
    this.checkin,
    this.customer,
  });

  bool? success;
  String? message;
  Checkin? checkin;
  Customer? customer;

  factory CustomerCheckinDetailsModel.fromJson(Map<String, dynamic> json) =>
      CustomerCheckinDetailsModel(
        success: json["success"],
        message: json["message"],
        checkin: Checkin.fromJson(json["checkin"]),
        customer: Customer.fromJson(json["customer"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "checkin": checkin!.toJson(),
        "customer": customer!.toJson(),
      };
}

class Checkin {
  Checkin({
    this.id,
    this.code,
    this.customerId,
    this.accountNumber,
    this.checkinType,
    this.userCode,
    this.ip,
    this.startTime,
    this.stopTime,
    this.notes,
    this.cancellationReason,
    this.adjusmentReason,
    this.orderNumber,
    this.amount,
    this.orderStatus,
    this.orderType,
    this.deliveryDate,
    this.deliveryTime,
    this.nextDeliveryDate,
    this.nextDeliveryTime,
    this.approvedBy,
    this.businessCode,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? code;
  int? customerId;
  String? accountNumber;
  String? checkinType;
  String? userCode;
  String? ip;
  String? startTime;
  String? stopTime;
  String? notes;
  String? cancellationReason;
  String? adjusmentReason;
  String? orderNumber;
  String? amount;
  String? orderStatus;
  String? orderType;
  String? deliveryDate;
  String? deliveryTime;
  String? nextDeliveryDate;
  String? nextDeliveryTime;
  String? approvedBy;
  String? businessCode;
  String? createdAt;
  String? updatedAt;

  factory Checkin.fromJson(Map<String, dynamic> json) => Checkin(
        id: json["id"],
        code: json["code"],
        customerId: json["customer_id"],
        accountNumber: json["account_number"],
        checkinType: json["checkin_type"],
        userCode: json["user_code"],
        ip: json["ip"],
        startTime: json["start_time"],
        stopTime: json["stop_time"],
        notes: json["notes"],
        cancellationReason: json["cancellation_reason"],
        adjusmentReason: json["adjusment_reason"],
        orderNumber: json["order_number"],
        amount: json["amount"],
        orderStatus: json["order_status"],
        orderType: json["order_type"],
        deliveryDate: json["delivery_date"],
        deliveryTime: json["delivery_time"],
        nextDeliveryDate: json["next_delivery_date"],
        nextDeliveryTime: json["next_delivery_time"],
        approvedBy: json["approved_by"],
        businessCode: json["business_code"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "customer_id": customerId,
        "account_number": accountNumber,
        "checkin_type": checkinType,
        "user_code": userCode,
        "ip": ip,
        "start_time": startTime,
        "stop_time": stopTime,
        "notes": notes,
        "cancellation_reason": cancellationReason,
        "adjusment_reason": adjusmentReason,
        "order_number": orderNumber,
        "amount": amount,
        "order_status": orderStatus,
        "order_type": orderType,
        "delivery_date": deliveryDate,
        "delivery_time": deliveryTime,
        "next_delivery_date": nextDeliveryDate,
        "next_delivery_time": nextDeliveryTime,
        "approved_by": approvedBy,
        "business_code": businessCode,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class Customer {
  Customer({
    this.id,
    this.customerName,
    this.account,
    this.manufacturerNumber,
    this.vatNumber,
    this.approval,
    this.deliveryTime,
    this.address,
    this.city,
    this.province,
    this.postalCode,
    this.country,
    this.latitude,
    this.longitude,
    this.contactPerson,
    this.telephone,
    this.customerGroup,
    this.customerSecondaryGroup,
    this.priceGroup,
    this.route,
    this.branch,
    this.status,
    this.email,
    this.phoneNumber,
    this.businessCode,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? customerName;
  String? account;
  String? manufacturerNumber;
  String? vatNumber;
  String? approval;
  String? deliveryTime;
  String? address;
  String? city;
  String? province;
  String? postalCode;
  String? country;
  String? latitude;
  String? longitude;
  String? contactPerson;
  String? telephone;
  String? customerGroup;
  String? customerSecondaryGroup;
  String? priceGroup;
  String? route;
  String? branch;
  String? status;
  String? email;
  String? phoneNumber;
  String? businessCode;
  String? createdBy;
  String? updatedBy;
  String? createdAt;
  String? updatedAt;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"],
        customerName: json["customer_name"],
        account: json["account"],
        manufacturerNumber: json["manufacturer_number"],
        vatNumber: json["vat_number"],
        approval: json["approval"],
        deliveryTime: json["delivery_time"],
        address: json["address"],
        city: json["city"],
        province: json["province"],
        postalCode: json["postal_code"],
        country: json["country"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        contactPerson: json["contact_person"],
        telephone: json["telephone"],
        customerGroup: json["customer_group"],
        customerSecondaryGroup: json["customer_secondary_group"],
        priceGroup: json["price_group"],
        route: json["route"],
        branch: json["branch"],
        status: json["status"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        businessCode: json["business_code"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_name": customerName,
        "account": account,
        "manufacturer_number": manufacturerNumber,
        "vat_number": vatNumber,
        "approval": approval,
        "delivery_time": deliveryTime,
        "address": address,
        "city": city,
        "province": province,
        "postal_code": postalCode,
        "country": country,
        "latitude": latitude,
        "longitude": longitude,
        "contact_person": contactPerson,
        "telephone": telephone,
        "customer_group": customerGroup,
        "customer_secondary_group": customerSecondaryGroup,
        "price_group": priceGroup,
        "route": route,
        "branch": branch,
        "status": status,
        "email": email,
        "phone_number": phoneNumber,
        "business_code": businessCode,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
