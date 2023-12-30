import 'package:flutter/material.dart';

class SettingsItem extends StatelessWidget {
  String title;
  Widget? screen;
  Widget? action;
  VoidCallback? click;
  SettingsItem({super.key,required this.title,this.screen,this.action,this.click});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 60,
        child: GestureDetector(
          onTap: (){
            if(screen!=null){
              Navigator.push(context, MaterialPageRoute(builder: (param)=> screen!));
            }
            click!();
          },
          child: Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                        title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: action??const SizedBox(),
                  ),
                ],
              ),
          ),
        ),
      ),
    );
  }
}
