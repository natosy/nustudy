import 'Module.dart';
import 'Venue.dart';
import 'Profile.dart';
import 'ActiveStudySession.dart';
import 'ArchivedStudySession.dart';

class Account {
  List<Module> modules;
  Profile profile;
  String password;
  String NUSNETID;
  String email;
  List<ActiveStudySession> _userStudySessions = [];

  Account(
      {this.modules,
      this.password,
      this.NUSNETID,
      this.email,
      String nickname,
      String biography,
      int year,
      double rating}) {
    this.modules = modules ?? List();
    this.password = password;
    this.NUSNETID = NUSNETID;
    this.profile =
        Profile(biography: biography, nickname: nickname, year: year, rating: rating);
  }

  static Account create(
      {List<Module> modules,
      String password,
      String NUSNETID,
      String email,
      String nickname,
      String biography,
      int year}) {
    Account account = Account(
      modules: modules,
      password: password,
      NUSNETID: NUSNETID,
      email: email,
      nickname: nickname,
      biography: biography,
      year: year,
    );
    return account;
  }

//    int getAccountID() {
//        return accountID;
//    }

  String getNUSNETID() {
    return NUSNETID;
  }

  String getNickName() {
    return profile.getNickname();
  }

  String getBiography() {
    return profile.getBiography();
  }

  double getRating() {
    return profile.getRating();
  }

  int getYear() {
    return profile.getYear();
  }

  String getEmail() {
    return email;
  }

  List<Module> getModules() {
    return modules;
  }

  Profile getProfile() {
    return profile;
  }

  @deprecated
  String getPassword() {
    return password;
  }

  ActiveStudySession createStudySession(Venue venue, Module module,
      String title, String description, int capacity, DateTime dateTime) {
    ActiveStudySession ss = ActiveStudySession(
        venue: venue,
        module: module,
        title: title,
        description: description,
        capacity: capacity,
        creatorID: NUSNETID,
        creator: this.profile,
        dateTime: dateTime);
    _userStudySessions.add(ss);
    return ss;
  }

//  void addAccountModule(String string) {
//    modules.add(Database.findModule(string));
//    print("Successfully added module " + string + " to account: " + getNickName() + "\n");
//  }

  void removeAccountModule(String string) {
    int initialLength = modules.length;
    modules.removeWhere((mod) => string == mod.moduleCode);
    int finalLength = modules.length;
    if (finalLength != initialLength) {
      print("Successfully removed module from account " +
          getNickName() +
          ": " +
          string);
    } else {
      print("No such module " +
          string +
          " is taken by student, and cannot be removed.");
    }
  }

  void viewAccountModules() {
    print(
        "---------------\n" + getNickName() + "'s Modules: \n---------------");
    for (Module m in modules) print(m.toString() + "\n ---");
  }

  void joinStudySession(ActiveStudySession ss) {
    _userStudySessions.add(ss);
  }

  void leaveStudySession(ActiveStudySession ss) {
    _userStudySessions.remove(ss);
  }

  void removeStudySession(ActiveStudySession ss) {
    _userStudySessions.remove(ss);
  }

  void addStudySessionToHistory(ArchivedStudySession ss) {
    profile.addToHistory(ss);
  }

  void editNickname(String nickname) {
    profile.updateNickname(nickname);
  }

  void editBiography(String biography) {
    profile.updateBiography(biography);
  }

  List<ActiveStudySession> getUserStudySessions() {
    return _userStudySessions;
  }

  @override
  String toString() {
    String modsTaken = "";
    for (Module m in modules) {
      modsTaken += m.toString();
      modsTaken += "\n\n";
    }
    //TODO: Need to format rating to be in .02f format
    return "------------------------------" +
        "\n\nNickname: ${this.getNickName()}" +
        "\nNUSNET ID: ${this.NUSNETID}" +
        "\nYear: ${getYear()}" +
        "\nRating: ${this.profile.getRating()}" +
        "\nBiography: ${this.profile.getBiography()}" +
        "\n\nModules taken:" +
        "\n$modsTaken" +
        "\n------------------------------\n";
  }
}
