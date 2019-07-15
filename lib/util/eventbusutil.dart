import 'package:event_bus/event_bus.dart';

class ClearAllEvent{
  bool flag;
  ClearAllEvent(this.flag);
}

class LoginStatus{
  bool flag;
  LoginStatus(this.flag);
}

enum Status{
  logged,
  logout,
}


EventBus eventBus = new EventBus();