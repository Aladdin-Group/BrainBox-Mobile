import 'package:flutter_background_service/flutter_background_service.dart';

class BackgroundController{

  static Future stopService()async{
    final service = FlutterBackgroundService();
    var isRunning = await service.isRunning();
    if (isRunning) {
      service.invoke("stopService");
    }
  }

  static Future startService()async{
    final service = FlutterBackgroundService();
    var isRunning = await service.isRunning();
    if(!isRunning){
      Future.delayed(const Duration(seconds: 5),(){
        FlutterBackgroundService().startService();
      });
    }
  }
}