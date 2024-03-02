import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'sales_count.freezed.dart';
part 'sales_count.g.dart';

@freezed
abstract class SalesCount with _$SalesCount {
  @HiveType(typeId: 7, adapterName: 'SalesCountClassAdapter')
  const factory SalesCount({
    @HiveField(0)
    int? TotalSales,
    @HiveField(1)
    String? message,
    @HiveField(2)
    bool? success,
  }) = _SalesCount;
  factory SalesCount.fromJson(Map<String, dynamic> json) =>
      _$SalesCountFromJson(json);
}
