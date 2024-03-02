import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'new_leads.freezed.dart';
part 'new_leads.g.dart';

@freezed
abstract class NewLeads with _$NewLeads {
  @HiveType(typeId: 5, adapterName: 'NewLeadsClassAdapter')
  const factory NewLeads({
    @HiveField(0)
    required int ThisWeekLeads,
    @HiveField(1)
    required int ThisMonthLeads,
    @HiveField(2)
    required int ThisYearLeads,
    @HiveField(3)
    required String message,
    @HiveField(4)
    required bool success,
  }) = _NewLeads;
  factory NewLeads.fromJson(Map<String, dynamic> json) =>
      _$NewLeadsFromJson(json);
}
