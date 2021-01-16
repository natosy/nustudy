import '../Rules/ArchivedStudySession.dart';
import '../Rules/Account.dart';
import '../Rules/Module.dart';
import '../Rules/ActiveStudySession.dart';
import '../Rules/Venue.dart';

class NUSDatabase {
  static List<Account> accounts = [];
  static List<ActiveStudySession> studySessions = [
    ActiveStudySession(
      venue: Venue(name: 'Home'),
      module: Module(
          moduleTitle: 'Data Structures and Algorithm Analysis',
          moduleCode: 'CS2040S'),
      title: 'Exam Revision',
      description: 'gotta chiong some shit',
      capacity: 5,
      creatorID: '12345678',
      dateTime: DateTime.utc(2020,)
    ),
    ActiveStudySession(
      venue: Venue(name: 'Home'),
      module: Module(
          moduleTitle: 'Data Structures and Algorithm Analysis',
          moduleCode: 'CS2040S'),
      title: 'Exam Revision',
      description: 'gotta chiong some shit',
      capacity: 5,
      creatorID: '12345678',
      dateTime: DateTime.utc(2020,)
    ),
    ActiveStudySession(
      venue: Venue(name: 'Home'),
      module: Module(
          moduleTitle: 'Data Structures and Algorithm Analysis',
          moduleCode: 'CS2040S'),
      title: 'Exam Revision',
      description: 'gotta chiong some shit',
      capacity: 5,
      creatorID: '12345678',
        dateTime: DateTime.utc(2020,)
    ),
    ActiveStudySession(
      venue: Venue(name: 'Home'),
      module: Module(
          moduleTitle: 'Data Structures and Algorithm Analysis',
          moduleCode: 'CS2040S'),
      title: 'Exam Revision',
      description: 'gotta chiong some shit',
      capacity: 5,
      creatorID: '12345678',
        dateTime: DateTime.utc(2020,)
    ),
    ActiveStudySession(
      venue: Venue(name: 'Home'),
      module: Module(
          moduleTitle: 'Data Structures and Algorithm Analysis',
          moduleCode: 'CS2040S'),
      title: 'Exam Revision',
      description: 'gotta chiong some shit',
      capacity: 5,
      creatorID: '12345678',
        dateTime: DateTime.utc(2020,)
    ),
  ];
  static List<Module> modules = [
    Module(
      moduleCode: 'CS2040',
      moduleTitle: 'Data Structures And Algorithms',
    ),
    Module(
      moduleCode: 'CS2030',
      moduleTitle: 'Programming Methodology II',
    ),
    Module(
      moduleCode: 'CS1101S',
      moduleTitle: 'Programming Methodology I',
    ),
    Module(
      moduleCode: 'MA1521',
      moduleTitle: 'Calculus for Computing',
    ),
    Module(
      moduleCode: 'MA1101R',
      moduleTitle: 'Linear Algebra I',
    ),
  ];
  static List<Venue> venues = [
    Venue.create('YIH Tokyo Paris Room'),
    Venue.create('Seminar Room 27'),
    Venue.create('Central Library'),
    Venue.create('Science Library'),
    Venue.create('More locations to be added...'),
  ];
  static List<ArchivedStudySession> archivedStudySessions = new List();

  static List<ActiveStudySession> getModuleStudySessions(Module module) {
    List<ActiveStudySession> moduleSpecificSS = new List();
    for (ActiveStudySession studySession in studySessions) {
      if (studySession.getModule().moduleCode == module.moduleCode) {
        moduleSpecificSS.add(studySession);
      }
    }
    return moduleSpecificSS;
  }

  // admin method
  static void addModule(Module module) {
    modules.add(module);
  }

  // admin method
  static void removeModule(Module module) {
    modules.remove(module);
  }

  static void addAccount(Account acc) {
    accounts.add(acc);
  }
}
