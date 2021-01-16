import 'package:nus_study/Rules/ArchivedStudySession.dart';

class History {
  List<ArchivedStudySession> studySessions = List();

  void addToHistory(ArchivedStudySession ss) {
    studySessions.add(ss);
  }

  double getAverageRating() {
    double total = 0;
    for (ArchivedStudySession ass in studySessions) {
      total = total + ass.getRating();
    }
    if (studySessions.length == 0) {
      return total;
    } else {
      return total / studySessions.length;
    }
  }

  @override
  String toString() {
    String string = '';
    for (ArchivedStudySession s in studySessions) {
      string += "/n" + s.toString();
    }
    return "History:" + string;
  }
}
