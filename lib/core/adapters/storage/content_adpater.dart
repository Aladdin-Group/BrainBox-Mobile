import 'package:hive/hive.dart';

import '../../../feature/words/data/models/words_response.dart';

class ContentHiveAdapter extends TypeAdapter<Content> {
  @override
  Content read(BinaryReader reader) {
    var fieldsCount = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < fieldsCount; i++) reader.readByte(): reader.read(),
    };

    return Content(
      id: fields[0] as String?,
      value: fields[1] as String?,
      count: fields[2] as int?,
      pronunciation: fields[3] as String?,
      translationEn: fields[4] as String?,
      translationRu: fields[5] as String?,
      isSaved: fields[6] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, Content obj) {
    writer.writeByte(7); // Number of fields in the Content class

    writer.writeByte(0);
    writer.write(obj.id);

    writer.writeByte(1);
    writer.write(obj.value);

    writer.writeByte(2);
    writer.write(obj.count);

    writer.writeByte(3);
    writer.write(obj.pronunciation);

    writer.writeByte(4);
    writer.write(obj.translationEn);

    writer.writeByte(5);
    writer.write(obj.translationRu);

    writer.writeByte(6);
    writer.write(obj.isSaved);
  }

  @override
  int get typeId => 2; // Ensure this is unique
}
