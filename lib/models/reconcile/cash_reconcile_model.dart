// To parse this JSON data, do
//
//     final cashReconcile = cashReconcileFromJson(jsonString);

import 'dart:convert';

CashReconcile cashReconcileFromJson(String str) => CashReconcile.fromJson(json.decode(str));

String cashReconcileToJson(CashReconcile data) => json.encode(data.toJson());

class CashReconcile {
  CashReconcile({
    this.success,
    this.message,
    this.mpesa,
    this.cash,
    this.cheque,
    this.bank,
  });

  bool? success;
  String? message;
  List<Mpesa>? mpesa;
  List<Cash>? cash;
  List<Cheque>? cheque;
  List<Bank>? bank;

  bool? _success;
  String? _message;
  late List<Mpesa> _mpesa;
  List<Mpesa> get mpesaMoney => _mpesa;

  late List<Cash> _cash;
  List<Cash> get cashMoney => _cash;

  late List<Cheque> _cheque;
  List<Cheque> get chequeMoney => _cheque;

  late List<Bank> _bank;
  List<Bank> get bankMoney => _bank;

  CashReconcile.fromJson(Map<String, dynamic> json) {
    _success = json['success'];
    _message = json['message'];
    if (json['Mpesa'] != null) {
      _cash = <Cash>[];
      _cheque = <Cheque>[];
      _mpesa = <Mpesa>[];
      _bank= <Bank>[];
      json['Mpesa'].forEach((v) {
        _mpesa.add(Mpesa.fromJson(v));
      });
      json['Cheque'].forEach((v) {
        _cheque.add(Cheque.fromJson(v));
      });
      json['Cash'].forEach((v) {
        _cash.add(Cash.fromJson(v));
      });
      json['Bank'].forEach((v) {
        _bank.add(Bank.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "Mpesa": List<dynamic>.from(mpesa!.map((x) => x.toJson())),
    "Cash": List<dynamic>.from(cash!.map((x) => x.toJson())),
    "Cheque": List<dynamic>.from(cheque!.map((x) => x.toJson())),
  };
}

class Cash {
  Cash({
    this.cash,
  });

  int? cash;

  factory Cash.fromJson(Map<String, dynamic> json) => Cash(
    cash: json["Cash"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "Cash": cash,
  };
}

class Cheque {
  Cheque({
    this.cheque,
  });

  int? cheque;

  factory Cheque.fromJson(Map<String, dynamic> json) => Cheque(
    cheque: json["Cheque"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "Cheque": cheque,
  };
}

class Mpesa {
  Mpesa({
    this.mpesa,
  });

  int? mpesa;

  factory Mpesa.fromJson(Map<String, dynamic> json) => Mpesa(
    mpesa: json["Mpesa"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "Mpesa": mpesa,
  };
}

class Bank {
  Bank({
    this.bank,
  });

  int? bank;

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
    bank: json["Cash"] ?? 0,
  );
}
