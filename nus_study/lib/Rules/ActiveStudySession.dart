import 'package:intl/intl.dart';
import 'package:nus_study/Rules/Profile.dart';
import 'Venue.dart';
import 'Module.dart';
import 'ArchivedStudySession.dart';

class ActiveStudySession {
  Venue _venue;
  Module _module;
  String _title;
  String _description;
  List<Profile> _participants = new List();
  String _creatorID;
  int _capacity;
  int _noOfParticipants = 0;
  DateTime _dateTime;
  bool isEnded = false;

  ActiveStudySession(
      {Venue venue,
      Module module,
      String title,
      String description,
      int capacity,
      String creatorID,
      Profile creator,
      DateTime dateTime, bool isEnded}) {
    this._venue = venue;
    this._module = module;
    this._title = title;
    this._description = description;
    this._capacity = capacity;
    this._creatorID = creatorID;
    this._dateTime = dateTime;
    this._noOfParticipants++;
    this.addParticipant(creator);
    if(isEnded!=null) {
      this.isEnded = isEnded;
    }
  }

  void addParticipant(Profile participantProfile) {
    if (_noOfParticipants <= _capacity) {
      _participants.add(participantProfile);
      _noOfParticipants++;
    }
  }

  void removeParticipant(Profile participantID) {
    //_participants[0] will always be creators profile
    if (participantID.getNickname() == _participants[0].getNickname()) {
      print(
          "Unable to remove user from Study Session as user is the creator.\n");
    } else {
      _participants.removeWhere((profiles)=>profiles.getNickname()==participantID.getNickname());
      _noOfParticipants--;
    }
  }

  ArchivedStudySession createArchivedStudySession() {
    isEnded = true;
    return ArchivedStudySession(
      venue: _venue,
      module: _module,
      title: _title,
      description: _description,
      capacity: _capacity,
      creatorID: _creatorID,
      participants: _participants,
      dateTime: _dateTime,
    );
  }

  bool isEditableByAccount(String NUSNETID) {
    return getCreatorID() == NUSNETID;
  }

  @override
  String toString() {
    return "------ STUDY SESSION ------" +
        "\nStudy Session Title: " +
        _title +
        "\nCreator ID: " +
        _creatorID +
//                "\nCreator Nickname: " + creatorNickName +
        "\nCapacity: " +
        "$_noOfParticipants/$_capacity" +
        "\nLocation: " +
        _venue.toString() +
        "\nDate: " +
        getDate() +
        "\nTime: " +
        getTime() +
        "\nModule: " +
        _module.toString() +
        "\nDescription: " +
        _description +
        "\n(Active)\n ------ END ------";
  }

  String getCreatorID() {
    return _creatorID;
  }

  Venue getVenue() {
    return _venue;
  }


  int getCapacity() {
    return _capacity;
  }

  String getDescription() {
    return _description;
  }

  String getTitle() {
    return _title;
  }

  String getTime() {
    var timeFormatter = new DateFormat('Hm');
    return timeFormatter.format(getDateTime());
  }

  Module getModule() {
    return _module;
  }

  String getDate() {
    var dateFormatter = new DateFormat('dd-MM-yyyy');
    return dateFormatter.format(getDateTime());
  }

  DateTime getDateTime() {
    return _dateTime;
  }

  List<Profile> getParticipants() {
    return _participants;
  }
}
