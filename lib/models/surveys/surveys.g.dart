// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'surveys.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SurveyModelAdapter extends TypeAdapter<SurveyModel> {
  @override
  final int typeId = 11;

  @override
  SurveyModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SurveyModel(
      id: fields[0] as int?,
      businessCode: fields[1] as dynamic,
      code: fields[2] as String?,
      title: fields[3] as String?,
      description: fields[4] as String?,
      category: fields[5] as int?,
      status: fields[6] as String?,
      startDate: fields[7] as DateTime?,
      endDate: fields[8] as DateTime?,
      type: fields[9] as String?,
      visibility: fields[10] as String?,
      image: fields[11] as dynamic,
      correctAnswers: fields[12] as int?,
      wrongAnswers: fields[13] as int?,
      createdBy: fields[14] as int?,
      updatedBy: fields[15] as dynamic,
      createdAt: fields[16] as DateTime?,
      updatedAt: fields[17] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, SurveyModel obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.businessCode)
      ..writeByte(2)
      ..write(obj.code)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.category)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.startDate)
      ..writeByte(8)
      ..write(obj.endDate)
      ..writeByte(9)
      ..write(obj.type)
      ..writeByte(10)
      ..write(obj.visibility)
      ..writeByte(11)
      ..write(obj.image)
      ..writeByte(12)
      ..write(obj.correctAnswers)
      ..writeByte(13)
      ..write(obj.wrongAnswers)
      ..writeByte(14)
      ..write(obj.createdBy)
      ..writeByte(15)
      ..write(obj.updatedBy)
      ..writeByte(16)
      ..write(obj.createdAt)
      ..writeByte(17)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SurveyModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
