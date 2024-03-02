// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomerDataModelAdapter extends TypeAdapter<CustomerDataModel> {
  @override
  final int typeId = 0;

  @override
  CustomerDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomerDataModel(
      id: fields[0] as int?,
      customerName: fields[1] as String?,
      account: fields[2] as String?,
      manufacturerNumber: fields[3] as String?,
      vatNumber: fields[4] as String?,
      approval: fields[5] as String?,
      deliveryTime: fields[6] as String?,
      address: fields[7] as String?,
      city: fields[8] as String?,
      province: fields[9] as String?,
      postalCode: fields[10] as String?,
      country: fields[11] as String?,
      latitude: fields[12] as String?,
      longitude: fields[13] as String?,
      contactPerson: fields[14] as String?,
      telephone: fields[15] as String?,
      customerGroup: fields[16] as String?,
      customerSecondaryGroup: fields[17] as String?,
      priceGroup: fields[18] as String?,
      route: fields[19] as String?,
      branch: fields[20] as String?,
      status: fields[21] as String?,
      email: fields[22] as String?,
      phoneNumber: fields[23] as String?,
      businessCode: fields[24] as String?,
      createdBy: fields[25] as String?,
      updatedBy: fields[26] as String?,
      createdAt: fields[27] as String?,
      updatedAt: fields[28] as String?,
      image: fields[29] as String?,
      creditorStatus: fields[30] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CustomerDataModel obj) {
    writer
      ..writeByte(31)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.customerName)
      ..writeByte(2)
      ..write(obj.account)
      ..writeByte(3)
      ..write(obj.manufacturerNumber)
      ..writeByte(4)
      ..write(obj.vatNumber)
      ..writeByte(5)
      ..write(obj.approval)
      ..writeByte(6)
      ..write(obj.deliveryTime)
      ..writeByte(7)
      ..write(obj.address)
      ..writeByte(8)
      ..write(obj.city)
      ..writeByte(9)
      ..write(obj.province)
      ..writeByte(10)
      ..write(obj.postalCode)
      ..writeByte(11)
      ..write(obj.country)
      ..writeByte(12)
      ..write(obj.latitude)
      ..writeByte(13)
      ..write(obj.longitude)
      ..writeByte(14)
      ..write(obj.contactPerson)
      ..writeByte(15)
      ..write(obj.telephone)
      ..writeByte(16)
      ..write(obj.customerGroup)
      ..writeByte(17)
      ..write(obj.customerSecondaryGroup)
      ..writeByte(18)
      ..write(obj.priceGroup)
      ..writeByte(19)
      ..write(obj.route)
      ..writeByte(20)
      ..write(obj.branch)
      ..writeByte(21)
      ..write(obj.status)
      ..writeByte(22)
      ..write(obj.email)
      ..writeByte(23)
      ..write(obj.phoneNumber)
      ..writeByte(24)
      ..write(obj.businessCode)
      ..writeByte(25)
      ..write(obj.createdBy)
      ..writeByte(26)
      ..write(obj.updatedBy)
      ..writeByte(27)
      ..write(obj.createdAt)
      ..writeByte(28)
      ..write(obj.updatedAt)
      ..writeByte(29)
      ..write(obj.image)
      ..writeByte(30)
      ..write(obj.creditorStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
