import 'package:brain_box/feature/education/data/models/book_model.dart';
import 'package:brain_box/feature/education/presentation/manager/education_bloc.dart';
import 'package:brain_box/feature/education/presentation/pages/essential_words_page.dart';
import 'package:brain_box/feature/education/presentation/pages/select_units_page.dart';
import 'package:brain_box/feature/education/presentation/widgets/unit_item.dart';
import 'package:flutter/material.dart';

class UnitsPage extends StatefulWidget {
  final Essential book;

  const UnitsPage({super.key, required this.book});

  @override
  State<UnitsPage> createState() => _UnitsPageState();
}

class _UnitsPageState extends State<UnitsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Essential Units'),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: 30,
          itemBuilder: (context, index) => UnitItem(
                index: index + 1,
                onClick: (i) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => EssentialWordsPage(
                                essential: widget.book,
                                unit: i,
                              )));
                },
              )),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FilledButton(
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => SelectUnitPage(
                            book: widget.book,

                          )));
            },
            child: const Text('Start test')),
      ),
    );
  }
}
