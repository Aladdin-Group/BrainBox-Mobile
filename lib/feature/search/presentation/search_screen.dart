import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  late SearchController searchController;

  @override
  void initState() {
    searchController = SearchController();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SearchAnchor(
          searchController: searchController,
          builder: (context, controller) => SearchBar(
            controller: searchController,
            leading: const Icon(Icons.search),
            onTap: () {
              controller.openView();
            },
            onChanged: (_) {
              controller.openView();
            },
          ),
          suggestionsBuilder: (context, controller) => [],
        ),
    );
  }
}
