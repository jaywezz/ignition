// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'survey_questions_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SurveyQuestionsModelAdapter extends TypeAdapter<SurveyQuestionsModel> {
  @override
  final int typeId = 12;

  @override
  SurveyQuestionsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SurveyQuestionsModel(
      id: fields[0] as int?,
      surveyCode: fields[1] as String?,
      questionCode: fields[3] as String?,
      type: fields[4] as String?,
      question: fields[5] as String?,
      options: fields[6] as Options?,
      answer: fields[7] as String?,
      image: fields[8] as dynamic,
      position: fields[9] as int?,
      points: fields[10] as dynamic,
      time: fields[11] as dynamic,
      createdBy: fields[12] as int?,
      updatedBy: fields[13] as dynamic,
      createdAt: fields[14] as DateTime?,
      updatedAt: fields[15] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, SurveyQuestionsModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.surveyCode)
      ..writeByte(3)
      ..write(obj.questionCode)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.question)
      ..writeByte(6)
      ..write(obj.options)
      ..writeByte(7)
      ..write(obj.answer)
      ..writeByte(8)
      ..write(obj.image)
      ..writeByte(9)
      ..write(obj.position)
      ..writeByte(10)
      ..write(obj.points)
      ..writeByte(11)
      ..write(obj.time)
      ..writeByte(12)
      ..write(obj.createdBy)
      ..writeByte(13)
      ..write(obj.updatedBy)
      ..writeByte(14)
      ..write(obj.createdAt)
      ..writeByte(15)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SurveyQuestionsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
