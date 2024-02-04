import 'package:flutter_background_service/flutter_background_service.dart';

class BackgroundController {
  static Future stopService() async {
    final service = FlutterBackgroundService();
    var isRunning = await service.isRunning();
    if (isRunning) {
      service.invoke("stopService");
    }
  }

  static Future startService() async {
    print('hello');
    final service = FlutterBackgroundService();
    // service.invoke("setAsForeground");
    var isRunning = await service.isRunning();
    // if(!isRunning){
    print('hello1');
    service.invoke("setAsForeground");
    // service.invoke("setAsBackground");
    // todo uncomment this
    Future.delayed(const Duration(seconds: 5), () {
      FlutterBackgroundService().startService();
    });
  }
// }
}
