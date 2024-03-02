// To parse this JSON data, do
//
//     final targets = targetsFromJson(jsonString);

import 'dart:convert';

// Target targetsFromJson(String str) => Target.fromJson(json.decode(str));
Target targetsFromJson(dynamic str) =>Target.fromJson(str);
// String targetsToJson(Target data) => json.encode(data.toJson());
class Target {
  Target({
    this.targetSales,
    this.achievedSalesTarget,
    this.achievedDailySalesTarget,
    this.achievedWeeklySalesTarget,
    this.achievedMonthlySalesTarget,
    this.targetLeads,
    this.achievedLeadsTarget,
    this.achievedLeadsDailyTarget,
    this.achievedLeadsWeeklyTarget,
    this.achievedLeadsMonthlyTarget,
    this.targetsOrder,
    this.achievedOrderTarget,
    this.achievedDailyOrderTarget,
    this.achievedWeeklyOrderTarget,
    this.achievedMonthlyOrderTarget,
    this.targetsVisit,
    this.achievedVisitTarget,
    this.achievedDailyVisitTarget,
    this.achievedWeeklyVisitTarget,
    this.achievedMonthlyVisitTarget,

  });

  String? targetSales;
  String? achievedSalesTarget;
  String? achievedDailySalesTarget;
  String? achievedLeadsSalesTarget;
  String? achievedWeeklySalesTarget;
  String? achievedMonthlySalesTarget;
  String? targetLeads;
  String? achievedLeadsTarget;
  String? achievedLeadsDailyTarget;
  String? achievedLeadsWeeklyTarget;
  String? achievedLeadsMonthlyTarget;
  String? targetsOrder;
  String? achievedOrderTarget;
  String? achievedDailyOrderTarget;
  String? achievedWeeklyOrderTarget;
  String? achievedMonthlyOrderTarget;
  String? targetsVisit;
  String? achievedVisitTarget;
  String? achievedDailyVisitTarget;
  String? achievedWeeklyVisitTarget;
  String? achievedMonthlyVisitTarget;

  factory Target.fromJson(Map<String, dynamic> json) => Target(
    targetSales: json["target_sale"]["SalesTarget"].toString(),
    achievedSalesTarget:json["target_sale"]["AchievedSalesTarget"].toString(),
    achievedDailySalesTarget:json["target_sale"]["achievement"]["day"] == null?"0":json["target_sale"]["achievement"]["day"].toString(),
    achievedWeeklySalesTarget:json["target_sale"]["achievement"]["week"] == null ? "0":json["target_sale"]["achievement"]["week"].toString(),
    achievedMonthlySalesTarget:json["target_sale"]["achievement"]["month"]==null?"0.0":json["target_sale"]["achievement"]["month"].toString(),

    targetLeads: json["target_lead"]["LeadsTarget"].toString(),
    achievedLeadsTarget:json["target_lead"]["AchievedLeadsTarget"].toString(),
    achievedLeadsDailyTarget:json["target_lead"]["achievement"]["day"] == null? "0":json["target_lead"]["achievement"]["day"].toString(),
    achievedLeadsWeeklyTarget:json["target_lead"]["achievement"]["week"] == null?"0":json["target_lead"]["achievement"]["week"].toString(),
    achievedLeadsMonthlyTarget:json["target_lead"]["achievement"]["month"] == null?"0":json["target_lead"]["achievement"]["month"].toString(),

    targetsOrder: json["targets_order"]["OrdersTarget"].toString(),
    achievedOrderTarget:json["targets_order"]["AchievedOrdersTarget"].toString(),
    achievedDailyOrderTarget:json["targets_order"]["achievement"]["day"] == null?"0":json["targets_order"]["achievement"]["day"].toString(),
    achievedWeeklyOrderTarget:json["targets_order"]["achievement"]["week"]==null?"0":json["targets_order"]["achievement"]["week"].toString(),
    achievedMonthlyOrderTarget:json["targets_order"]["achievement"]["month"] == null?"0":json["targets_order"]["achievement"]["month"].toString(),

    targetsVisit: json["targets_visit"]["VisitsTarget"].toString(),
    achievedVisitTarget: json["targets_visit"]["AchievedVisitsTarget"].toString(),
    achievedDailyVisitTarget:json["targets_visit"]["achievement"]["day"] == null?"0":json["targets_visit"]["achievement"]["day"].toString(),
    achievedWeeklyVisitTarget:json["targets_visit"]["achievement"]["week"] == null ?"0":json["targets_visit"]["achievement"]["week"].toString(),
    achievedMonthlyVisitTarget:json["targets_visit"]["achievement"]["month"] == null?"0":json["targets_visit"]["achievement"]["month"].toString(),
  );
}

//
// class Target {
//   Target({
//     this.targetSales,
//     this.targetLeads,
//     this.targetsOrder,
//     this.targetsVisit,
//   });
//
//   List<TargetSale>? targetSales;
//   List<TargetLead>? targetLeads;
//   List<TargetsOrder>? targetsOrder;
//   List<TargetsVisit>? targetsVisit;
//
//   factory Target.fromJson(Map<String, dynamic> json) => Target(
//     targetSales: List<TargetSale>.from(json["target_sales"].map((x) => TargetSale.fromJson(x))),
//     targetLeads: List<TargetLead>.from(json["target_leads"].map((x) => TargetLead.fromJson(x))),
//     targetsOrder: List<TargetsOrder>.from(json["targets_order"].map((x) => TargetsOrder.fromJson(x))),
//     targetsVisit: List<TargetsVisit>.from(json["targets_visit"].map((x) => TargetsVisit.fromJson(x))),
//   );
// }
//
// class TargetLead {
//   TargetLead({
//     this.id,
//     this.userCode,
//     this.leadsTarget,
//     this.achievedLeadsTarget,
//     this.deadline,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   int? id;
//   String? userCode;
//   String? leadsTarget;
//   String? achievedLeadsTarget;
//   DateTime? deadline;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//
//   factory TargetLead.fromJson(Map<String, dynamic> json) =>
//       TargetLead(
//         id: json["id"],
//         userCode: json["user_code"],
//         leadsTarget: json["LeadsTarget"],
//         achievedLeadsTarget: json["AchievedLeadsTarget"],
//         deadline: DateTime.parse(json["Deadline"]),
//         createdAt: DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//       );
// }
//
//
//
// class TargetSale {
//   TargetSale({
//     this.id,
//     this.userCode,
//     this.salesTarget,
//     this.achievedSalesTarget,
//     this.deadline,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   int? id;
//   String? userCode;
//   String? salesTarget;
//   String? achievedSalesTarget;
//   DateTime? deadline;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//
//   factory TargetSale.fromJson(Map<String, dynamic> json) => TargetSale(
//     id: json["id"],
//     userCode: json["user_code"],
//     salesTarget: json["SalesTarget"],
//     achievedSalesTarget: json["AchievedSalesTarget"],
//     deadline: DateTime.parse(json["Deadline"]),
//     createdAt: DateTime.parse(json["created_at"]),
//     updatedAt: DateTime.parse(json["updated_at"]),
//   );
//
//
// }
//
// class TargetsOrder {
//   TargetsOrder({
//     this.id,
//     this.userCode,
//     this.ordersTarget,
//     this.achievedOrdersTarget,
//     this.deadline,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   int? id;
//   String? userCode;
//   String? ordersTarget;
//   String? achievedOrdersTarget;
//   DateTime? deadline;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//
//   factory TargetsOrder.fromJson(Map<String, dynamic> json) => TargetsOrder(
//     id: json["id"],
//     userCode: json["user_code"],
//     ordersTarget: json["OrdersTarget"],
//     achievedOrdersTarget: json["AchievedOrdersTarget"],
//     deadline: DateTime.parse(json["Deadline"]),
//     createdAt: DateTime.parse(json["created_at"]),
//     updatedAt: DateTime.parse(json["updated_at"]),
//   );
//
//
// }
//
// class TargetsVisit {
//   TargetsVisit({
//     this.id,
//     this.userCode,
//     this.visitsTarget,
//     this.achievedVisitsTarget,
//     this.deadline,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   int? id;
//   String? userCode;
//   String? visitsTarget;
//   String? achievedVisitsTarget;
//   DateTime? deadline;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//
//   factory TargetsVisit.fromJson(Map<String, dynamic> json) => TargetsVisit(
//     id: json["id"],
//     userCode: json["user_code"],
//     visitsTarget: json["VisitsTarget"],
//     achievedVisitsTarget: json["AchievedVisitsTarget"],
//     deadline: DateTime.parse(json["Deadline"]),
//     createdAt: DateTime.parse(json["created_at"]),
//     updatedAt: DateTime.parse(json["updated_at"]),
//   );
// }
