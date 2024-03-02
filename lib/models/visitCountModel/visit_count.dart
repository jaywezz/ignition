import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'visit_count.freezed.dart';
part 'visit_count.g.dart';

@freezed
abstract class VisitsCount with _$VisitsCount {
  @HiveType(typeId: 8, adapterName: 'VisitCountClassAdapter')
  const factory VisitsCount({
    @HiveField(0)
    required int TotalVisitsPerThisWeek,
    @HiveField(1)
    required int TotalVisitsPerThisMonth,
    @HiveField(2)
    required int TotalVisitsThisYear,
    @HiveField(3)
    required String message,
    @HiveField(4)
    required bool success,
  }) = _VisitsCount;
  factory VisitsCount.fromJson(Map<String, dynamic> json) =>
      _$VisitsCountFromJson(json);
}
