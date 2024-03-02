// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_leads.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NewLeadsClassAdapter extends TypeAdapter<_$_NewLeads> {
  @override
  final int typeId = 5;

  @override
  _$_NewLeads read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$_NewLeads(
      ThisWeekLeads: fields[0] as int,
      ThisMonthLeads: fields[1] as int,
      ThisYearLeads: fields[2] as int,
      message: fields[3] as String,
      success: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, _$_NewLeads obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.ThisWeekLeads)
      ..writeByte(1)
      ..write(obj.ThisMonthLeads)
      ..writeByte(2)
      ..write(obj.ThisYearLeads)
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
      other is NewLeadsClassAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_NewLeads _$$_NewLeadsFromJson(Map<String, dynamic> json) => _$_NewLeads(
      ThisWeekLeads: json['ThisWeekLeads'] as int,
      ThisMonthLeads: json['ThisMonthLeads'] as int,
      ThisYearLeads: json['ThisYearLeads'] as int,
      message: json['message'] as String,
      success: json['success'] as bool,
    );

Map<String, dynamic> _$$_NewLeadsToJson(_$_NewLeads instance) =>
    <String, dynamic>{
      'ThisWeekLeads': instance.ThisWeekLeads,
      'ThisMonthLeads': instance.ThisMonthLeads,
      'ThisYearLeads': instance.ThisYearLeads,
      'message': instance.message,
      'success': instance.success,
    };
