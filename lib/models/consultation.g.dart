// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consultation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConsultationAdapter extends TypeAdapter<Consultation> {
  @override
  final int typeId = 2;

  @override
  Consultation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Consultation(
      id: fields[0] as String,
      patientId: fields[1] as String,
      date: fields[2] as DateTime,
      diagnostic: fields[3] as String,
      notes: fields[4] as String,
      prescription: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Consultation obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.patientId)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.diagnostic)
      ..writeByte(4)
      ..write(obj.notes)
      ..writeByte(5)
      ..write(obj.prescription);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConsultationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
