import 'package:nus_study/Rules/Account.dart';
import 'package:nus_study/Rules/ActiveStudySession.dart';
import 'package:nus_study/Rules/Module.dart';
import 'package:nus_study/Rules/Venue.dart';

class Cache {
  static Account account;
  static List<ActiveStudySession> moduleStudySessions = [];
  static List<Venue> venues = [];
  static List<Module> allModules = [];
}
