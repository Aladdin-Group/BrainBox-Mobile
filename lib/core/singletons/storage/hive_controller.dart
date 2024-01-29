import 'package:brain_box/core/singletons/storage/store_keys.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../../../feature/reminder/data/models/local_word.dart';
import '../../adapters/storage/word_adapter.dart';

class HiveController{
  HiveController._();
  static final Box<LocalWord> box = Hive.box<LocalWord>(key);

  static Future<void> init()async{
    final appDocumentDirectory =
    await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
    Hive.registerAdapter(WordHiveAdapter());
    await Hive.openBox<LocalWord>(StoreKeys.localWordsList);
  }

  static const key = StoreKeys.localWordsList;

  static Future<void> closeHiveBox() async {
    if (box.isOpen) {
      await box.close();
    }
  }

  static Future<void> saveListToHive(List<LocalWord> localWords) async {
    // await box.clear(); // Optional: Clear existing data

    for (final word in localWords) {
      await box.add(word);
    }
  }

  static int genericId(){
    return box.values.toList().length +1;
  }

  static Future<void> saveObject(LocalWord object) async {
    try {
      await box.add(object);
    } catch (e) {
    }
  }

  static Future<void> removeObjectFromHive(String objectId) async {
    try {
      final objectToDelete = box.values.firstWhere(
            (word) => word.id == objectId,
      );
      var index = box.values.toList().indexOf(objectToDelete);
      box.deleteAt(index);
    } catch (e) {
    }
  }

  static Future<List<LocalWord>> getListFromHive() async {
    // Convert HiveList to List
    return box.values.toList();
  }

}