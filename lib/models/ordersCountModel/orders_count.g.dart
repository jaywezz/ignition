// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders_count.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrdersCountClassAdapter extends TypeAdapter<_$_OrdersCount> {
  @override
  final int typeId = 6;

  @override
  _$_OrdersCount read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$_OrdersCount(
      CustomerOrderCountThisWeek: fields[0] as int,
      CustomerOrderCountThisMonth: fields[1] as int,
      CustomersOrderCountThisYear: fields[2] as int,
      message: fields[3] as String,
      success: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, _$_OrdersCount obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.CustomerOrderCountThisWeek)
      ..writeByte(1)
      ..write(obj.CustomerOrderCountThisMonth)
      ..writeByte(2)
      ..write(obj.CustomersOrderCountThisYear)
      ..writeByte(3)
      ..write(obj.message)
      ..writeByte(4)
      ..write(obj.success);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrdersCountClassAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_OrdersCount _$$_OrdersCountFromJson(Map<String, dynamic> json) =>
    _$_OrdersCount(
      CustomerOrderCountThisWeek: json['CustomerOrderCountThisWeek'] as int,
      CustomerOrderCountThisMonth: json['CustomerOrderCountThisMonth'] as int,
      CustomersOrderCountThisYear: json['CustomersOrderCountThisYear'] as int,
      message: json['message'] as String,
      success: json['success'] as bool,
    );

Map<String, dynamic> _$$_OrdersCountToJson(_$_OrdersCount instance) =>
    <String, dynamic>{
      'CustomerOrderCountThisWeek': instance.CustomerOrderCountThisWeek,
      'CustomerOrderCountThisMonth': instance.CustomerOrderCountThisMonth,
      'CustomersOrderCountThisYear': instance.CustomersOrderCountThisYear,
      'message': instance.message,
      'success': instance.success,
    };
