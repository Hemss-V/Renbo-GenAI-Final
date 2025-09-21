// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gratitude.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GratitudeAdapter extends TypeAdapter<Gratitude> {
  @override
  final int typeId = 1;

  @override
  Gratitude read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Gratitude(
      text: fields[0] as String,
      timestamp: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Gratitude obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.text)
      ..writeByte(1)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GratitudeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
