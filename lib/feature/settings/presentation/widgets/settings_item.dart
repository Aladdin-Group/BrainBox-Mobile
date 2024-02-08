import 'package:brain_box/core/assets/constants/colors.dart';
import 'package:flutter/material.dart';

class SettingsItem extends StatelessWidget {
  final String title;
  final Widget? screen;
  final IconData icon;
  final bool? isFirst;
  final bool? isLast;
  final Widget? action;
  final VoidCallback? click;
  const SettingsItem({super.key,required this.title,this.screen,this.action,this.click,this.isLast,this.isFirst,required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(screen!=null){
          Navigator.push(context, MaterialPageRoute(builder: (param)=> screen!));
        }
        if(click!=null){
          click!();
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0,right: 10,),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: ((isFirst!=null)==true) ? const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20)
            )  : ((isLast!=null)==true) ? const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)
            ) : BorderRadius.circular(0)
          ),
          height: 65,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        icon,
                        size: 30,
                        color: AppColors.main,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(
                          title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    const Expanded(child: SizedBox.shrink()),
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: action??const SizedBox(),
                    ),
                  ],
                ),
               ((isLast==null)==true) ? Divider(color: Colors.grey[200],) : const SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }
}
