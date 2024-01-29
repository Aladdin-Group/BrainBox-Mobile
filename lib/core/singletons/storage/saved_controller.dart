import 'package:brain_box/core/singletons/storage/store_keys.dart';
import 'package:brain_box/feature/words/data/models/words_response.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../feature/reminder/data/models/local_word.dart';
import '../../adapters/storage/content_adpater.dart';

class SavedController {
  // SavedController._();



  static const key = StoreKeys.savedWordsList;
  static final Box<Content> box = Hive.box<Content>(key);

  static Future<void> init() async {
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
    Hive.registerAdapter(ContentHiveAdapter());
    await Hive.openBox<LocalWord>(StoreKeys.savedWordsList);
  }

  static Future<void> closeHiveBox() async {
    if (box.isOpen) {
      await box.close();
    }
  }

  static Future<bool> isAvailableWord(Content word) async {
    var availability = false;

    box.values.toList().forEach((element) {
      if (element.id == word.id) {
        availability = true;
        return;
      }
    });

    return availability;
  }

  static Future<void> saveListToHive(List<Content> localWords) async {
    // await box.clear(); // Optional: Clear existing data

    for (final word in localWords) {
      await box.add(word);
    }
  }

  static Future<void> saveObject(Content object) async {
    try {
      await box.put(object.id, object);
    } catch (e) {
    }
  }

  static Future<void> removeObjectFromHive(String objectId) async {
    try {
      box.delete(objectId);
      // final objectToDelete = box.values.firstWhere(
      //   (word) => word.id == objectId,
      // );
      // var index = box.values.toList().indexOf(objectToDelete);
      // box.deleteAt(index);
    } catch (e) {
    }
  }

  static List<Content> getListFromHive() {
    // Convert HiveList to List
    return box.values.toList();
  }
}
