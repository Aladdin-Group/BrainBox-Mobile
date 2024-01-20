import 'package:brain_box/feature/education/presentation/pages/unit_test_page.dart';
import 'package:brain_box/feature/education/presentation/widgets/selectble_unit_item.dart';
import 'package:brain_box/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../data/models/book_model.dart';
import '../manager/education_bloc.dart';
import '../widgets/unit_item.dart';

class SelectUnitPage extends StatefulWidget {
  final Essential book;

  const SelectUnitPage({super.key, required this.book});

  @override
  State<SelectUnitPage> createState() => _SelectUnitPageState();
}

class _SelectUnitPageState extends State<SelectUnitPage> {
  List<bool> selectedItems = List.generate(30, (index) => false);

  List<int> get onlySelectedItems {
    List<int> result = [];
    for (int i = 0; i < selectedItems.length; i++) {
      if (selectedItems[i]) {
        result.add(i + 1);
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Unit test')),
      body: ListView.builder(
        itemCount: 30,
        itemBuilder: (context, index) => SelectableUnitItem(
          index: index + 1,
          onClick: (i) {
            setState(() {
              selectedItems[index] = !selectedItems[index];
            });
          },
          isSelected: selectedItems[index],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
            onPressed: () {
              if (onlySelectedItems.isEmpty) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title:  Text(LocaleKeys.error.tr()),
                    content:  Text(LocaleKeys.pleaseSelectAtLeastOneUnit.tr()),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Ok'),
                      ),

                    ]
                  )
                );
                return;
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (builder) => UnitTestPage(
                    book: widget.book,
                    selectedUnits: onlySelectedItems,
                  ),
                ),
              );
            },
            child: const Text('Start test')),
      ),
    );
  }
}
