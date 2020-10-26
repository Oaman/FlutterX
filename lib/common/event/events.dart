class LoginEvent {
  String userName;

  LoginEvent(this.userName);
}

class LogoutEvent {}

class CollectEvent {
  int id;
  bool collect;

  CollectEvent(this.id, this.collect);
}
