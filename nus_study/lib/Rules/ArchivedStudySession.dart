import 'package:intl/intl.dart';
import 'Profile.dart';
import 'Venue.dart';
import 'Module.dart';

class ArchivedStudySession {
  Venue _venue;
  Module _module;
  String _title;
  String _description;
  List<Profile> _participants = List();
  String _creatorID;
  int _capacity;
  int _noOfParticipants;
  double _rating = 0;
  double _totalRating = 0;
  int _numberOfPeopleRated = 0;
  DateTime _dateTime;
  List<Profile> _participantsRatedBy = List();

  ArchivedStudySession(
      {Venue venue,
      Module module,
      String date,
      String time,
      String title,
      String description,
      int studySessionID,
      int capacity,
      String creatorID,
      List<Profile> participants,
      double rating = 0.0,
      DateTime dateTime}) {
    this._venue = venue;
    this._module = module;
    this._title = title;
    this._description = description;
    this._capacity = capacity;
    this._creatorID = creatorID;
    this._rating = rating;
    this._dateTime = dateTime;
    this._participants = participants;
    //If by the previous assignment, _participants is still null then the next line will be effected
    this._participants ?? List();
  }

  bool isActive() {
    return false;
  }

  @override
  String toString() {
    return "------ STUDY SESSION ------" +
        "\nStudy Session Title: " +
        _title +
        "\nCreator ID: " +
        _creatorID +
        "\nCapacity: " +
        "$_noOfParticipants/$_capacity" +
        "\Venue: " +
        _venue.toString() +
        "\nDate: " +
        getDate() +
        "\nModule: " +
        _module.toString() +
        "\nDescription: " +
        _description +
        " (Ended)";
  }

  void addParticipant(Profile participant) {
    _participants.add(participant);
  }

  void addParticipantRatedBy(Profile participant) {
    _participantsRatedBy.add(participant);
  }

  String getCreatorID() {
    return _creatorID;
  }

  Venue getVenue() {
    return _venue;
  }

  String getDescription() {
    return _description;
  }

  String getTitle() {
    return _title;
  }

  Module getModule() {
    return _module;
  }

  String getDate() {
    var dateFormatter = DateFormat('dd-MM-yyyy');
    return dateFormatter.format(getDateTime());
  }

  DateTime getDateTime() {
    return _dateTime;
  }

  int getCapacity() {
    return _capacity;
  }

  List<Profile> getParticipants() {
    return _participants;
  }

  double getRating() {
    return double.parse((_rating).toStringAsFixed(2));
  }

  void addToRating(double rating, Profile profile) {
    _participantsRatedBy.add(profile);
    _numberOfPeopleRated++;
    _totalRating += rating;
    _rating = _totalRating / _numberOfPeopleRated;
  }

  bool participantToRate(Profile profile) {
    return _participants.where((element) => element.getNickname()==profile.getNickname()).isNotEmpty &&
        _participantsRatedBy.where((element) => element.getNickname()==profile.getNickname()).isEmpty;
  }
}
