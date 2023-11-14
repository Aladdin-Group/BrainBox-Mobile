import 'package:brain_box/core/constants/icons.dart';
import 'package:flutter/material.dart';

class TestResultPage extends StatefulWidget {
  const TestResultPage({Key? key}) : super(key: key);

  @override
  State<TestResultPage> createState() => _TestResultPageState();
}

class _TestResultPageState extends State<TestResultPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height / 2,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text('Available seats'),
                background: Stack(
                  children: [
                    Center(
                      child: SizedBox(
                          height: 150,
                          width: 150,
                          child: Image.asset(AppIcons.correct),
                      ),
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.add_circle),
                  tooltip: 'Add new entry',
                  onPressed: () { /* ... */ },
                ),
              ]
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate(childCount: 20,(context, index) => const ListTile(title: Text('Small'),))
          )
        ],
      ),
    );
  }
}