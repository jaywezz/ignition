import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'orders_count.freezed.dart';
part 'orders_count.g.dart';

@freezed
abstract class OrdersCount with _$OrdersCount {
  @HiveType(typeId: 6, adapterName: 'OrdersCountClassAdapter')
  const factory OrdersCount({
    @HiveField(0)
    required int CustomerOrderCountThisWeek,
    @HiveField(1)
    required int CustomerOrderCountThisMonth,
    @HiveField(2)
    required int CustomersOrderCountThisYear,
    @HiveField(3)
    required String message,
    @HiveField(4)
    required bool success,
  }) = _OrdersCount;
  factory OrdersCount.fromJson(Map<String, dynamic> json) =>
      _$OrdersCountFromJson(json);
}
