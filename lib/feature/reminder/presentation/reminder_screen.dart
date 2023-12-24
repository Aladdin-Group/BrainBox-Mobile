import 'package:auto_size_text/auto_size_text.dart';
import 'package:brain_box/core/singletons/storage/storage_repository.dart';
import 'package:brain_box/core/singletons/storage/store_keys.dart';
import 'package:brain_box/feature/reminder/data/models/rimnder_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/singletons/storage/hive_controller.dart';
import '../data/models/local_word.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}


class _ReminderScreenState extends State<ReminderScreen> {

  final TextEditingController customDateController = TextEditingController();
  final TextEditingController word = TextEditingController();
  final TextEditingController wordTranslate = TextEditingController();
  late ReminderDate? reminderDate;
  ValueNotifier<bool> getReminderSaved = ValueNotifier(false);
  GlobalKey<FormState> dropDownKey = GlobalKey();
  List<LocalWord> localWords = [];
  List<String> localWordsString = [];
  PermissionStatus? notificationPermissionStatus;

  @override
  void initState() {
    reminderDate = ReminderDate.getValue(StorageRepository.getDouble(StoreKeys.reminderDate).toInt());
    getReminderSaved.value = StorageRepository.getBool(StoreKeys.appSound);
    customDateController.text = 10.toString();
    initWords();
    setState(() {});
    super.initState();
  }

  Future initWords() async{
    localWords = await HiveController.getListFromHive();
    setState(() {});
    notificationPermissionStatus = await Permission.notification.request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: notificationPermissionStatus == PermissionStatus.granted ? CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: AutoSizeText(
                    'Notification time',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: DropdownMenu<ReminderDate>(
                  key: dropDownKey,
                  initialSelection: reminderDate??ReminderDate.every5Minutes,
                  enableSearch: false,
                  label: const Text('Select per minute'),
                  onSelected: (ReminderDate? date) async{
                    final service = FlutterBackgroundService();
                    var isRunning = await service.isRunning();
                    if (isRunning) {
                      service.invoke("stopService");
                    }
                    Future.delayed(const Duration(seconds: 5),(){
                      FlutterBackgroundService().startService();
                    });
                    if(!mounted) return;
                    if('ReminderDate.custom'==date) {
                      showDialog(
                          barrierDismissible: false,
                          context: context, builder: (context) {
                        return AlertDialog(
                          title: const Text('Please enter every minute !'),
                          content: TextField(
                            autofocus: true,
                            controller: customDateController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder()
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            maxLength: 2,

                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context, null),
                              // passing false
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () =>
                                  Navigator.pop(context, customDateController.text),
                              // passing true
                              child: const Text('Yes'),
                            ),
                          ],
                        );
                      }
                      ).then((value) =>
                      {
                        if(value == null) {
                          setState(() {
                            reminderDate = ReminderDate.getValue(StorageRepository.getDouble(StoreKeys.reminderDate).toInt());
                          }),
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please try again ${StorageRepository.getDouble(StoreKeys.reminderDate).toInt().toString()} !')))
                        } else {
                          if(customDateController.text.trim().isNotEmpty){
                            StorageRepository.putDouble(StoreKeys.customReminderDate, double.parse(customDateController.text)),
                            StorageRepository.putDouble(
                                StoreKeys.reminderDate, date!.position.toDouble()),
                            setState(() {
                              reminderDate = date;
                            }),
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Success !')))
                          }else{
                            dropDownKey.currentState?.reset(),
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Field is empty !')))
                          }
                        }
                      });
                    }else{
                      StorageRepository.putDouble(
                          StoreKeys.reminderDate, date!.position.toDouble());
                      setState(() {
                        reminderDate = date;
                      });
                    }
                  },
                  dropdownMenuEntries: ReminderDate.values
                      .map<DropdownMenuEntry<ReminderDate>>(
                          (ReminderDate date) {
                        return DropdownMenuEntry<ReminderDate>(
                          value: date,
                          label: date.label,
                        );
                      }).toList(),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 80,
                  width: double.maxFinite,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const FittedBox(
                            child: AutoSizeText(
                                'Get reminder from saved words',
                              style: TextStyle(
                                fontSize: 17
                              ),
                            ),
                          ),
                          ValueListenableBuilder(
                            valueListenable: getReminderSaved,
                            builder: (p1,p2,p3) {
                              return Switch(
                                  value: p2,
                                  onChanged: (value){
                                    StorageRepository.putBool(key: StoreKeys.appSound, value: value);
                                      getReminderSaved.value = value;
                                  }
                              );
                            }
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0,right: 10,top: 10),
                child: Card(
                  child: IconButton(onPressed: (){
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Write some word'),
                          content: Container(
                            height: 150.0, // Adjust the height as needed
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 10.0),
                                  child: TextField(
                                    controller: word,
                                    decoration: InputDecoration(
                                      labelText: 'Word',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: TextField(
                                    controller: wordTranslate,
                                    decoration: InputDecoration(
                                      labelText: 'Translate',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () async{
                                // Add your save functionality here
                                final localWord = LocalWord(id: (localWords.length+1),word: word.text.trim(),translate: wordTranslate.text.trim());
                                await HiveController.saveObject(localWord);
                                if (!mounted) return;
                                setState(() {
                                  localWords.add(localWord);
                                });
                                word.clear();
                                wordTranslate.clear();
                                final service = FlutterBackgroundService();
                                var isRunning = await service.isRunning();
                                if (isRunning) {
                                  service.invoke("stopService");
                                }
                                if(!mounted) return;
                                Navigator.pop(context);
                              },
                              child: Text('Save'),
                            ),
                          ],
                        );
                      },
                    ).then((value) => {
                      Future.delayed(const Duration(seconds: 5),(){
                        FlutterBackgroundService().startService();
                      })
                    });
                  }, icon: const Icon(Icons.add)),
                ),
              ),
            ),
            localWords.isNotEmpty ? SliverList.builder(
              itemCount: localWords.length,
                itemBuilder: (p1,index)=> Padding(
                  padding: const EdgeInsets.only(left: 10.0,right: 10),
                  child: Card(
                    child: Row(
                      children: [
                        const SizedBox(width: 10,),
                        Text('${localWords[index].word} - ${localWords[index].translate}'),
                        const Expanded(child: SizedBox.shrink()),
                        IconButton(onPressed: ()async{
                          HiveController.removeObjectFromHive(localWords[index].id!);
                          setState(() {
                            localWords.removeWhere((element) => element.id == localWords[index].id);
                          });
                          final service = FlutterBackgroundService();
                          var isRunning = await service.isRunning();
                          if (isRunning) {
                            service.invoke("stopService");
                          }
                          Future.delayed(const Duration(seconds: 5),(){
                            FlutterBackgroundService().startService();
                          });
                        }, icon: const Icon(Icons.close)),
                        const SizedBox(width: 10,),
                      ],
                    ),
                  ),
                )
            ) :
            const SliverFillRemaining(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AutoSizeText(
                      '📜 Add some words for memorize!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0,right: 10),
                    child: AutoSizeText(
                      'When you add some word, app will send reminder you!',
                      style: TextStyle(
                        color: Colors.grey
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            )
          ],
        ) : SizedBox(
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AutoSizeText(
                  '😔 Notifiaction is not allowed !',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0,left: 10,bottom: 15,),
                child: AutoSizeText(
                    'Press \"Allow notificaiton\" button and select Notifications and swtich allow.',
                  style: TextStyle(
                    color: Colors.grey
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              ElevatedButton(onPressed: (){openAppSettings();}, child: const Text('Allow notification'))
            ],
          ),
        ),
      ),
    );
  }
}