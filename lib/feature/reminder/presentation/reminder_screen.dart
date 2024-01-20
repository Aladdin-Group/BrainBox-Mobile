import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:brain_box/core/singletons/storage/storage_repository.dart';
import 'package:brain_box/core/singletons/storage/store_keys.dart';
import 'package:brain_box/core/utils/background_controller.dart';
import 'package:brain_box/feature/reminder/data/models/rimnder_date.dart';
import 'package:brain_box/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:gap/gap.dart';
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
  Random random = Random();
  ValueNotifier<PermissionStatus> notificationPermissionStatus = ValueNotifier(PermissionStatus.limited);

  @override
  void initState() {
    reminderDate = ReminderDate.getValue(StorageRepository.getDouble(StoreKeys.reminderDate).toInt());
    getReminderSaved.value = StorageRepository.getBool(StoreKeys.service);
    customDateController.text = 10.toString();
    initWords();
    setState(() {});
    super.initState();
  }

  Future initWords() async {
    localWords = await HiveController.getListFromHive();
    setState(() {});
    notificationPermissionStatus.value = await Permission.notification.request();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ValueListenableBuilder(
              valueListenable: notificationPermissionStatus,
              builder: (param1, param2, param3) {
                return notificationPermissionStatus.value == PermissionStatus.granted
                    ? CustomScrollView(

                        slivers: [
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AutoSizeText(
                                LocaleKeys.notificationTime.tr(),
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0,bottom: 10),
                              child: DropdownMenu<ReminderDate>(
                                key: dropDownKey,
                                initialSelection: reminderDate ?? ReminderDate.every5Minutes,
                                enableSearch: false,
                                label: Text(LocaleKeys.selectPerMinute.tr()),
                                onSelected: (ReminderDate? date) async {
                                  BackgroundController.stopService()
                                      .then((value) => {BackgroundController.startService()});
                                  if (!mounted) return;
                                  if ('ReminderDate.custom' == date) {
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(LocaleKeys.pleaseEnterEveryMinute.tr()),
                                            content: TextField(
                                              autofocus: true,
                                              controller: customDateController,
                                              decoration: const InputDecoration(border: OutlineInputBorder()),
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
                                                child: Text(LocaleKeys.cancel.tr()),
                                              ),
                                              ElevatedButton(
                                                onPressed: () => Navigator.pop(context, customDateController.text),
                                                // passing true
                                                child: Text(LocaleKeys.yes.tr()),
                                              ),
                                            ],
                                          );
                                        }).then((value) => {
                                          if (value == null)
                                            {
                                              setState(() {
                                                reminderDate = ReminderDate.getValue(
                                                    StorageRepository.getDouble(StoreKeys.reminderDate).toInt());
                                              }),
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                  content: Text('Please try again !'.tr(args: [
                                                (StorageRepository.getDouble(StoreKeys.reminderDate).toInt().toString())
                                              ]))))
                                            }
                                          else
                                            {
                                              if (customDateController.text.trim().isNotEmpty)
                                                {
                                                  StorageRepository.putDouble(StoreKeys.customReminderDate,
                                                      double.parse(customDateController.text)),
                                                  StorageRepository.putDouble(
                                                      StoreKeys.reminderDate, date!.position.toDouble()),
                                                  setState(() {
                                                    reminderDate = date;
                                                  }),
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(content: Text(LocaleKeys.success.tr())))
                                                }
                                              else
                                                {
                                                  dropDownKey.currentState?.reset(),
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(content: Text(LocaleKeys.fieldIsEmpty.tr())))
                                                }
                                            }
                                        });
                                  } else {
                                    StorageRepository.putDouble(StoreKeys.reminderDate, date!.position.toDouble());
                                    setState(() {
                                      reminderDate = date;
                                    });
                                  }
                                },
                                dropdownMenuEntries:
                                    ReminderDate.values.map<DropdownMenuEntry<ReminderDate>>((ReminderDate date) {
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
                                        Expanded(
                                          child: AutoSizeText(
                                            LocaleKeys.getReminderFromSavedWords.tr(),
                                            style: const TextStyle(fontSize: 17),
                                          ),
                                        ),
                                        ValueListenableBuilder(
                                            valueListenable: getReminderSaved,
                                            builder: (p1, p2, p3) {
                                              return Switch(
                                                  value: p2,
                                                  onChanged: (value) {
                                                    if (value) {
                                                      BackgroundController.startService();
                                                    } else {
                                                      BackgroundController.stopService();
                                                    }
                                                    StorageRepository.putBool(key: StoreKeys.service, value: value);
                                                    StorageRepository.putBool(key: StoreKeys.getWordsFromSavedList, value: value);
                                                    getReminderSaved.value = value;
                                                  });
                                            })
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10),
                              child: Card(
                                child: IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(LocaleKeys.writeSomeWord.tr()),

                                            content: SizedBox(
                                              height: 150.0, // Adjust the height as needed
                                              child: Column(
                                                children: [
                                                  Container(
                                                    margin: const EdgeInsets.only(bottom: 10.0),
                                                    child: TextField(
                                                      controller: word,
                                                      decoration: InputDecoration(
                                                        labelText: LocaleKeys.word.tr(),
                                                        border: const OutlineInputBorder(),
                                                      ),
                                                    ),
                                                  ),
                                                  TextField(
                                                    controller: wordTranslate,
                                                    decoration: InputDecoration(
                                                      labelText: LocaleKeys.translate.tr(),
                                                      border: const OutlineInputBorder(),
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
                                                child: Text(LocaleKeys.cancel.tr()),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  // Add your save functionality here
                                                  final localWord = LocalWord(
                                                      notificationId: HiveController.genericId(),
                                                      id: random.nextInt(100).toString(),
                                                      word: word.text.trim(),
                                                      translate: wordTranslate.text.trim());
                                                  await HiveController.saveObject(localWord);
                                                  if (!mounted) return;
                                                  setState(() {
                                                    localWords.add(localWord);
                                                  });
                                                  word.clear();
                                                  wordTranslate.clear();
                                                  BackgroundController.stopService();
                                                  if (!mounted) return;
                                                  Navigator.pop(context);
                                                },
                                                child: Text(LocaleKeys.save.tr()),
                                              ),
                                            ],
                                          );
                                        },
                                      ).then((value) => {
                                            BackgroundController.startService(),
                                          });
                                    },
                                    icon: const Icon(Icons.add)),
                              ),
                            ),
                          ),
                          localWords.isNotEmpty
                              ? SliverList.builder(
                                  itemCount: localWords.length,
                                  itemBuilder: (p1, index) => Padding(
                                        padding: const EdgeInsets.only(left: 10.0, right: 10),
                                        child: Card(
                                          child: Row(
                                            children: [
                                              const Gap(10),
                                              Text('${localWords[index].word} - ${localWords[index].translate}'),
                                              const Expanded(child: SizedBox.shrink()),
                                              IconButton(
                                                  onPressed: () async {
                                                    HiveController.removeObjectFromHive(localWords[index].id!);
                                                    setState(() {
                                                      localWords
                                                          .removeWhere((element) => element.id == localWords[index].id);
                                                    });
                                                    final service = FlutterBackgroundService();
                                                    var isRunning = await service.isRunning();
                                                    if (isRunning) {
                                                      service.invoke("stopService");
                                                    }
                                                    Future.delayed(const Duration(seconds: 5), () {
                                                      FlutterBackgroundService().startService();
                                                    });
                                                  },
                                                  icon: const Icon(Icons.close)),
                                              const Gap(10),
                                            ],
                                          ),
                                        ),
                                      ))
                              : SliverFillRemaining(

                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        AutoSizeText(
                                          LocaleKeys.addSomeWordsForMemorize.tr(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10.0, right: 10),
                                          child: AutoSizeText(
                                            LocaleKeys.whenYouAddSomeWordAppWillSendReminderYou.tr(),
                                            style: const TextStyle(color: Colors.grey),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                        ],
                      )
                    : SizedBox(
                        width: double.maxFinite,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                              child: AutoSizeText(
                                LocaleKeys.notificationIsNotAllowed.tr(),
                                style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 10.0,
                                left: 10,
                                bottom: 15,
                              ),
                              child: AutoSizeText(
                                LocaleKeys.pressAllowNotificationButtonAndSelectNotificationsAndSwtichAllow.tr(),
                                style: const TextStyle(color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  openAppSettings();
                                },
                                child: Text(LocaleKeys.allowNotification.tr()))
                          ],
                        ),
                      );
              }),
        ),
      ),
    );
  }
}
