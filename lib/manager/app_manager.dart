import 'package:event_bus/event_bus.dart';
import 'package:flutter_app/common/http/api.dart';

class AppManager {
  static const String ACCOUNT = "accountName";
  static EventBus eventBus = EventBus();

  static initApp() async {
    await Api.init();
  }
}
