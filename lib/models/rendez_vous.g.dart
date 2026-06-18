// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rendez_vous.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RendezVousAdapter extends TypeAdapter<RendezVous> {
  @override
  final int typeId = 1;

  @override
  RendezVous read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RendezVous(
      id: fields[0] as String,
      patientId: fields[1] as String,
      medecin: fields[2] as String,
      date: fields[3] as DateTime,
      motif: fields[4] as String,
      statut: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RendezVous obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.patientId)
      ..writeByte(2)
      ..write(obj.medecin)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.motif)
      ..writeByte(5)
      ..write(obj.statut);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RendezVousAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
