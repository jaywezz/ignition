// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_schedule_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserRouteModelAdapter extends TypeAdapter<UserRouteModel> {
  @override
  final int typeId = 19;

  @override
  UserRouteModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserRouteModel(
      name: fields[0] as String?,
      routeCode: fields[1] as String?,
      status: fields[2] as String?,
      startDate: fields[3] as DateTime?,
      endDate: fields[4] as DateTime?,
      customerName: fields[5] as String?,
      account: fields[6] as int?,
      routeType: fields[7] as String?,
      address: fields[8] as String?,
      email: fields[9] as String?,
      telephone: fields[10] as String?,
      latitude: fields[11] as String?,
      longitude: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserRouteModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.routeCode)
      ..writeByte(2)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.startDate)
      ..writeByte(4)
      ..write(obj.endDate)
      ..writeByte(5)
      ..write(obj.customerName)
      ..writeByte(6)
      ..write(obj.account)
      ..writeByte(7)
      ..write(obj.routeType)
      ..writeByte(8)
      ..write(obj.address)
      ..writeByte(9)
      ..write(obj.email)
      ..writeByte(10)
      ..write(obj.telephone)
      ..writeByte(11)
      ..write(obj.latitude)
      ..writeByte(12)
      ..write(obj.longitude);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserRouteModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
