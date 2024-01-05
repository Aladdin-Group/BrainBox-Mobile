import 'package:brain_box/feature/reminder/data/models/local_word.dart';
import 'package:hive/hive.dart';

class WordHiveAdapter extends TypeAdapter<LocalWord> {
  @override
  LocalWord read(BinaryReader reader) {
    var fieldsCount = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < fieldsCount; i++) reader.readByte(): reader.read(),
    };
    return LocalWord(
      id: fields[0] as String?,
      word: fields[1] as String?,
      translate: fields[2] as String?,
      notificationId: fields[3] as int?
    );
  }

  @override
  int get typeId => 0;

  @override
  void write(BinaryWriter writer, LocalWord obj) {
    writer.writeByte(4); // Number of fields in the User class

    writer.writeByte(0);
    writer.write(obj.id);


    writer.writeByte(1);
    writer.write(obj.word);


    writer.writeByte(2);
    writer.write(obj.translate);

    writer.writeByte(3);
    writer.write(obj.notificationId);
  }
}
