// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NoteAdapter extends TypeAdapter<Note> {
  @override
  final int typeId = 1;

  @override
  Note read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Note(
      image: fields[0] as String?,
      caption: fields[1] as String,
      body: fields[2] as String,
      noteColor: fields[3] as int?,
      created: fields[4] as DateTime,
      favourite: fields[5] as bool?,
      archieve: fields[6] as bool?,
      notificationTime: fields[7] as DateTime?,
      backgroundImage: fields[8] as String?,
    )
      ..textColor = fields[9] as int?
      ..shareImagePath = fields[10] as String?;
  }

  @override
  void write(BinaryWriter writer, Note obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.image)
      ..writeByte(1)
      ..write(obj.caption)
      ..writeByte(2)
      ..write(obj.body)
      ..writeByte(3)
      ..write(obj.noteColor)
      ..writeByte(4)
      ..write(obj.created)
      ..writeByte(5)
      ..write(obj.favourite)
      ..writeByte(6)
      ..write(obj.archieve)
      ..writeByte(7)
      ..write(obj.notificationTime)
      ..writeByte(8)
      ..write(obj.backgroundImage)
      ..writeByte(9)
      ..write(obj.textColor)
      ..writeByte(10)
      ..write(obj.shareImagePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
