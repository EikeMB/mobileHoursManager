class AppUser{
  final String uid;

  AppUser(this.uid);
}


class UserData{
  final String uid;
  final String username;
  final List<String> orgs;
  final double hours;

  UserData(this.uid, this.username, this.orgs, this.hours);
}