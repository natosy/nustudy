import 'ArchivedStudySession.dart';
import 'History.dart';

class Profile {
  History history = new History();
  String biography;
  String nickname;
  int year;
  double rating = 0;

  Profile({this.biography="", this.nickname, this.year, this.rating=0});

  double getRating() {
    print(rating);
    return double.parse(rating.toStringAsFixed(2));
  }

  History getHistory() {
    return history;
  }

  String getNickname() {
    return nickname;
  }

  String getBiography() {
    return biography;
  }

  int getYear() {
    return year;
  }

  void updateNickname(String nickname) {
    this.nickname = nickname;
  }

  void updateBiography(String biography) {
    this.biography = biography;
  }

  void addToHistory(ArchivedStudySession ss) {
    history.addToHistory(ss);
  }

  @override
  String toString() {
    return 'Nickname is $nickname, Biography is $biography, from Year ${year.toString()}';
  }
}
