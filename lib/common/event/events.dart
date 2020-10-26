class LoginEvent {
  String userName;

  LoginEvent(this.userName);
}

class LogoutEvent {}

class CollectEvent {
  int id;
  bool isCollect;

  CollectEvent(this.id, this.isCollect);
}
