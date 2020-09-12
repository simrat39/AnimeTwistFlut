// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LastWatchedModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LastWatchedModelAdapter extends TypeAdapter<LastWatchedModel> {
  @override
  final int typeId = 3;

  @override
  LastWatchedModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LastWatchedModel(
      fields[0] as TwistModel,
      fields[1] as KitsuModel,
      fields[2] as EpisodeModel,
    );
  }

  @override
  void write(BinaryWriter writer, LastWatchedModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.twistModel)
      ..writeByte(1)
      ..write(obj.kitsuModel)
      ..writeByte(2)
      ..write(obj.episodeModel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LastWatchedModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
