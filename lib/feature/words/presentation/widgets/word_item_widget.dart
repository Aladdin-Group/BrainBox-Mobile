import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WordItemWidget extends StatelessWidget {
  const WordItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
      title: Row(
        children: [
          Text(
            'Small',
            style: GoogleFonts.kronaOne(),
          ),
          const SizedBox(width: 5,),
          const Text(
            '(smôl)',
            style: TextStyle(
                fontSize: 15
            ),
          )
        ],
      ),
      subtitle: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('subtitle'),
          Text('something little height')
        ],
      ),
      trailing: FittedBox(
        child: Row(
          children: [
            IconButton(onPressed: (){}, icon: const Icon(CupertinoIcons.speaker_2)),
            IconButton(onPressed: (){}, icon: const Icon(CupertinoIcons.bookmark)),
          ],
        ),
      ),
    );
  }
}
