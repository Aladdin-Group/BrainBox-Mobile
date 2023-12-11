import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://i.pinimg.com/564x/48/44/61/484461f661cdc37401161203dbb9333a.jpg'
              ),
            ),
          )
        ],
      )
    );
  }
}
