// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 0;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      name: fields[0] as String,
      done: fields[1] as bool,
      description: fields[2] as String?,
      taskColor: fields[3] as int?,
      remainder: fields[5] as int?,
      decendents: (fields[6] as List?)?.cast<Task>(),
      isGroupTask: fields[7] as bool?,
      attachNotes: (fields[9] as List?)?.cast<int>(),
    )..created = fields[4] as int?;
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.done)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.taskColor)
      ..writeByte(4)
      ..write(obj.created)
      ..writeByte(5)
      ..write(obj.remainder)
      ..writeByte(6)
      ..write(obj.decendents)
      ..writeByte(7)
      ..write(obj.isGroupTask)
      ..writeByte(9)
      ..write(obj.attachNotes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
