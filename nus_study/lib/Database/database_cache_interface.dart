import 'package:nus_study/Database/NUSDatabase.dart';
import 'package:nus_study/Database/cache.dart';
import 'package:nus_study/Rules/Account.dart';
import 'package:nus_study/Rules/ActiveStudySession.dart';
import 'package:nus_study/Rules/ArchivedStudySession.dart';
import 'package:nus_study/Rules/Module.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nus_study/Rules/Profile.dart';
import 'package:nus_study/Rules/Venue.dart';

//TODO: Replace all methods with @deprecated tags with actual api call methods
class DataInterface {
  ///Account Related methods are below here.

  ///returns a success boolean
  static Future<bool> createUser(
      {String email, String password, Account account}) async {
    bool success = false;
    try {
      FirebaseAuth _auth = FirebaseAuth.instance;
      final createUserResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (createUserResult != null) {
        print("User created.");
        String userID = createUserResult.user.uid;
        await _createUserCollection(userID, account);
        print("User collection created");
        await _sendEmailVerification(user: createUserResult.user);
        print("Email Verification sent");
        success = true;
      }
      return success;
    }
    //TODO: deal with exceptions that come from this method(low priority)
    catch (e) {
      print("Error came from createUser\t" + e.toString());
      return success;
    }
  }

  ///Private method to create user collection using UID of new User
  static Future<void> _createUserCollection(
      String userID, Account account) async {
    try {
      Firestore _firestore = Firestore.instance;
      await _firestore.collection('users').document(userID).setData({
        'NUSNETID': account.getNUSNETID(),
        'biography': account.getBiography(),
        'email': account.getEmail(),
        'history': [],
        'modules': _getFormattedModules(account),
        'nickname': account.getNickName(),
        'studySessionsJoined': [],
        'year': account.getYear(),
      });
      return;
    }
    //TODO: deal with exceptions that come from this method(low priority)
    catch (e) {
      print("Error came from _createUserCollection\t" + e.toString());
    }
  }

  ///Private method for sending email verification
  static Future<void> _sendEmailVerification({FirebaseUser user}) async {
    await user.sendEmailVerification();
  }

  static Future<bool> nicknameExists({String nickname}) async {
    bool exists = false;
    Firestore _firestore = Firestore.instance;
    var result = await _firestore
        .collection('users')
        .where('nickname', isEqualTo: nickname)
        .getDocuments();
    if (result.documents.length != 0) {
      exists = true;
    }
    return exists;
  }

  static Future<bool> NUSNETIDExists({String NUSNETID}) async {
    bool exists = false;
    Firestore _firestore = Firestore.instance;
    var result = await _firestore
        .collection('users')
        .where('NUSNETID', isEqualTo: NUSNETID)
        .getDocuments();
    if (result.documents.length != 0) {
      exists = true;
    }
    return exists;
  }

  ///return boolean for whether the login was successful
  static Future<bool> loginUser({String email, String password}) async {
    bool success = false;
    try {
      FirebaseAuth _auth = FirebaseAuth.instance;
      final loginResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (loginResult != null) {
        if (loginResult.user.isEmailVerified) {
          print("User logged in");
          success = true;
        } else {
          print("User email not verified");
        }
      }
      return success;
    }
    //TODO: deal with exceptions that come from this method(low priority)
    catch (e) {
      print("Error came from loginUser\t" + e.toString());
      return success;
    }
  }

  static Future<void> signOut() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.signOut();
    print("User successfully logged out");
  }

  ///gets current user, returns null if fails
  static Future<FirebaseUser> _getLoggedInUser() async {
    try {
      FirebaseAuth _auth = FirebaseAuth.instance;
      final currentUser = await _auth.currentUser();
      return currentUser;
    }
    //TODO: deal with exceptions that come from this method(low priority)
    catch (e) {
      print("Error came from getLoggedInUser\t" + e.toString());
      return null;
    }
  }

  //TODO: Can be more compact but for understanding purposes has been written out with more assignments
  ///This method will get all of the account items including
  ///1. All profile details
  ///2. All study sessions and the relevant profile cards
  ///returns null if fails
  static Future<Account> getUserCollection() async {
    try {
      Firestore _firestore = Firestore.instance;
      final FirebaseUser loggedInUser = await _getLoggedInUser();
      print("I got the user inside getUserCollection");
      if (loggedInUser != null) {
        DocumentReference accountDetailsRef =
            _firestore.collection('users').document(loggedInUser.uid);
        var accountDetailsSnapshot = await accountDetailsRef.get();
        var accountDetails = accountDetailsSnapshot.data;
        double rating = 0;
        int counter = 0;
        for (DocumentReference historySSRef in accountDetails['history']) {
          var historySS = await historySSRef.get();
          counter++;
          rating =
              rating + (historySS['totalRating'] / historySS['noOfRatings']);
        }
        if (counter == 0) {
          rating = 0;
        } else {
          rating = rating / counter;
        }
        print("I got the accountDetails inside getUserCollection");
        Account account = new Account(
          NUSNETID: accountDetails['NUSNETID'],
          biography: accountDetails['biography'],
          email: accountDetails['email'],
          modules: _mapModulesIntoList(accountDetails['modules']),
          nickname: accountDetails['nickname'],
          year: accountDetails['year'],
          rating: rating,
        );
        print("I made the account object inside getUserCollection");
        for (DocumentReference docRef in accountDetails['history']) {
          var archivedStudySessionSnapshot = await docRef.get();
          Map<String, dynamic> archivedStudySessionDetails =
              archivedStudySessionSnapshot.data;
          ArchivedStudySession aSS =
              await _archivedStudySessionFromMap(archivedStudySessionDetails);
          account.addStudySessionToHistory(aSS);
        }
        print("Added the entire history of this person");
        for (DocumentReference docRef
            in accountDetails['studySessionsJoined']) {
          var activeStudySessionSnapshot = await docRef.get();
          Map<String, dynamic> activeStudySessionDetails =
              activeStudySessionSnapshot.data;
          if(!activeStudySessionDetails['isEnded']) {
            ActiveStudySession aSS =
            await _activeStudySessionFromMap(activeStudySessionDetails);
            account.joinStudySession(aSS);
          }
        }
        print("Got the user collection");
        return account;
      }
      return null;
    }
    //TODO: deal with exceptions that come from this method(low priority)
    catch (e) {
      print("Error came from getUserCollection\t" + e.toString());
      return null;
    }
  }

  ///Updates the user details
  static Future<bool> updateUserDetails() async {
    bool success = false;
    try {
      Firestore _firestore = Firestore.instance;
      FirebaseUser loggedInUser = await _getLoggedInUser();
      await _firestore
          .collection('users')
          .document(loggedInUser.uid)
          .updateData({
        'year': Cache.account.getYear(),
        'biography': Cache.account.getBiography(),
        'modules': _getFormattedModules(Cache.account),
      }).then((_) => print("Profile updated successfully!"));
      success = true;
      return success;
    }
    //TODO: deal with exceptions that come from this method(low priority)
    catch (e) {
      print("Error came from updateUserDetails\t" + e.toString());
      return success;
    }
  }

  ///Method to change password, returns success boolean, only requires newPass
  static Future<bool> changePassword({String newPassword}) async {
    bool success = false;
    try {
      FirebaseUser user = await _getLoggedInUser();
      if (user != null) {
        await user.updatePassword(newPassword);
        print("Password Changed!");
        success = true;
      }
      print("I happened inside of changePassword");
      return success;
    }
    //TODO: deal with exceptions that come from this method(low priority)
    catch (e) {
      print("Error came from changePassword\t" + e.toString());
      return success;
    }
  }

  ///allows for reset of Password for forgetful users
  static Future<bool> resetPassword({String email}) async {
    bool success = false;
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      success = true;
      return success;
    }
    //TODO: deal with exceptions that come from this method(low priority)
    catch (e) {
      print("Error came from resetPassword\t" + e.toString());
      return success;
    }
  }

  ///After this point will be methods relating to Active Study Sessions
  static Future<bool> createActiveStudySession(
      ActiveStudySession activeStudySession) async {
    bool success = false;
    try {
      Firestore _firestore = Firestore.instance;
      final FirebaseUser loggedInUser = await _getLoggedInUser();
      if (loggedInUser != null) {
        print("User is not null!!");
        String uniqueRefKey = activeStudySession.getCreatorID() +
            activeStudySession.getDateTime().toIso8601String();
        print("Created the uniqueRefKey");
        await _firestore
            .collection('activeStudySessions')
            .document(uniqueRefKey)
            .setData({
          'capacity': activeStudySession.getCapacity(),
          'creatorID': activeStudySession.getCreatorID(),
          'datetime': Timestamp.fromDate(activeStudySession.getDateTime()),
          'description': activeStudySession.getDescription(),
          'isEnded': false,
          'module': _moduleToMap(activeStudySession.getModule()),
          'noOfParticipants': activeStudySession.getParticipants().length,
          'participants': [
            _firestore.collection('users').document(loggedInUser.uid)
          ],
          'title': activeStudySession.getTitle(),
          'venue': _venueToMap(activeStudySession.getVenue()),
        }).then((_) => print('study Session created!'));
        print("new activeStudySession created on database");
        await _firestore
            .collection('users')
            .document(loggedInUser.uid)
            .updateData({
          'studySessionsJoined': FieldValue.arrayUnion([
            _firestore.collection('activeStudySessions').document(uniqueRefKey)
          ])
        }).then((_) => print(
                'Successfully updated users studySessionJoined references'));
        success = true;
      } else {
        print("_getLoggedInUser failed in createActiveStudySession!");
      }
      return success;
    }
    //TODO: deal with exceptions that come from this method(low priority)
    catch (e) {
      print("Error came from createActiveStudySession\t" + e.toString());
      return success;
    }
  }

  static Future<bool> getUpdatedJoinedSS() async {
    bool success = false;
    try {
      Firestore _firestore = Firestore.instance;
      final FirebaseUser loggedInUser = await _getLoggedInUser();
      print("I got the user inside getUserCollection");
      if (loggedInUser != null) {
        DocumentReference accountDetailsRef =
            _firestore.collection('users').document(loggedInUser.uid);
        var accountDetailsSnapshot = await accountDetailsRef.get();
        var accountDetails = accountDetailsSnapshot.data;
        print("I got the accountDetails inside getUserCollection");
        for (DocumentReference docRef
            in accountDetails['studySessionsJoined']) {
          var activeStudySessionSnapshot = await docRef.get();
          Map<String, dynamic> activeStudySessionDetails =
              activeStudySessionSnapshot.data;
          ActiveStudySession aSS =
              await _activeStudySessionFromMap(activeStudySessionDetails);
          List<ActiveStudySession> aSSList =
              Cache.account.getUserStudySessions();
          if (!aSSList.contains(aSS)) {
            Cache.account.joinStudySession(aSS);
          }
        }
        print("Updated the local cache with the new study sessions");
        success = true;
      }
      return success;
    }
    //TODO: deal with exceptions that come from this method(low priority)
    catch (e) {
      print("Error came from getUpdatedJoinedSS\t" + e.toString());
      return success;
    }
  }

  ///Used to get the list of activeStudySessions under a particular module
  static Future<List<ActiveStudySession>> getModuleActiveStudySessions(
      Module module) async {
    try {
      List<ActiveStudySession> aSSList = List();
      Firestore _firestore = Firestore.instance;
      String moduleCode = module.moduleCode;
      var result = await _firestore
          .collection('activeStudySessions')
          .where('module.moduleCode', isEqualTo: moduleCode)
          .where('isEnded', isEqualTo: false)
          .getDocuments();
      for (DocumentSnapshot aSSSnapshot in result.documents) {
        ActiveStudySession aSS =
            await _activeStudySessionFromMap(aSSSnapshot.data);
        aSSList.add(aSS);
      }
      print("Got the module active study sessions");
      return aSSList;
    }
    //TODO: deal with exceptions that come from this method(low priority)
    catch (e) {
      print("Error came from getModuleActiveStudySessions\t" + e.toString());
      return [];
    }
  }

  static Future<bool> joinActiveStudySession(
      {ActiveStudySession activeStudySession}) async {
    bool success = false;
    Firestore _firestore = Firestore.instance;
    String aSSKey = activeStudySession.getCreatorID() +
        activeStudySession.getDateTime().toIso8601String();
    try {
      FirebaseUser loggedInUser = await _getLoggedInUser();
      if (loggedInUser != null) {
        await _firestore
            .collection('users')
            .document(loggedInUser.uid)
            .updateData({
          'studySessionsJoined': FieldValue.arrayUnion(
              [_firestore.collection('activeStudySessions').document(aSSKey)])
        }).then((_) => print(
                'Successfully updated users studySessionJoined references'));
        await _firestore
            .collection('activeStudySessions')
            .document(aSSKey)
            .updateData({
          'participants': FieldValue.arrayUnion(
              [_firestore.collection('users').document(loggedInUser.uid)])
        }).then((_) => print(
                "Successfully updated Active Study Session participants with the user reference"));
        success = true;
      }
      return success;
    }
    //TODO: deal with exceptions that come from this method(low priority)
    catch (e) {
      print("Error came from joinActiveStudySession\t" + e.toString());
      return success;
    }
  }

  static Future<bool> leaveActiveStudySession(
      {ActiveStudySession activeStudySession}) async {
    bool success = false;
    Firestore _firestore = Firestore.instance;
    String aSSKey = activeStudySession.getCreatorID() +
        activeStudySession.getDateTime().toIso8601String();
    try {
      FirebaseUser loggedInUser = await _getLoggedInUser();
      if (loggedInUser != null) {
        await _firestore
            .collection('users')
            .document(loggedInUser.uid)
            .updateData({
          'studySessionsJoined': FieldValue.arrayRemove(
              [_firestore.collection('activeStudySessions').document(aSSKey)])
        }).then((_) => print(
                'Successfully updated users studySessionJoined references'));
        await _firestore
            .collection('activeStudySessions')
            .document(aSSKey)
            .updateData({
          'participants': FieldValue.arrayRemove(
              [_firestore.collection('users').document(loggedInUser.uid)])
        }).then((_) => print(
                "Successfully updated Active Study Session participants with the user reference"));
        success = true;
      }
      return success;
    }
    //TODO: deal with exceptions that come from this method(low priority)
    catch (e) {
      print("Error came from leaveActiveStudySession\t" + e.toString());
      return success;
    }
  }

  static Future<bool> endActiveStudySession(
      ActiveStudySession activeStudySession) async {
    bool success = false;
    try {
      Firestore _firestore = Firestore.instance;
      final FirebaseUser loggedInUser = await _getLoggedInUser();
      if (loggedInUser != null) {
        String uniqueRefKey = activeStudySession.getCreatorID() +
            activeStudySession.getDateTime().toIso8601String();
        await _firestore
            .collection('activeStudySessions')
            .document(uniqueRefKey)
            .updateData({
          'isEnded': true,
        }).then((_) => print("Active Study Session Ended!"));
        success = true;
      } else {
        print("_getLoggedInUser failed in endActiveStudySession!");
      }
      return success;
    }
    //TODO: deal with exceptions that come from this method(low priority)
    catch (e) {
      print("Error came from endActiveStudySession\t" + e.toString());
      return success;
    }
  }

  static Future<bool> createArchivedStudySession(
      ActiveStudySession activeStudySession) async {
    bool success = false;
    try {
      Firestore _firestore = Firestore.instance;
      final FirebaseUser loggedInUser = await _getLoggedInUser();
      List<DocumentReference> aSSParticipants =
          await _getParticipants(activeStudySession);
      if (loggedInUser != null && aSSParticipants.isNotEmpty) {
        print("User is not null!!");
        String uniqueRefKey = activeStudySession.getCreatorID() +
            activeStudySession.getDateTime().toIso8601String();
        print("Created the uniqueRefKey");
        await _firestore
            .collection('archivedStudySessions')
            .document(uniqueRefKey)
            .setData({
          'capacity': activeStudySession.getCapacity(),
          'creatorID': activeStudySession.getCreatorID(),
          'datetime': Timestamp.fromDate(activeStudySession.getDateTime()),
          'description': activeStudySession.getDescription(),
          'module': _moduleToMap(activeStudySession.getModule()),
          'noOfRatings': 0,
          'participants': aSSParticipants,
          'totalRating': 0,
          'title': activeStudySession.getTitle(),
          'venue': _venueToMap(activeStudySession.getVenue()),
        }).then((_) => print('Study Session Archived!'));
        print("new archivedStudySession created on database");
        for (DocumentReference participant in aSSParticipants) {
          await participant.updateData({
            'history': FieldValue.arrayUnion([
              _firestore
                  .collection('archivedStudySessions')
                  .document(uniqueRefKey)
            ])
          });
        }
        print("Updated all the participants history of the study Session");
        success = true;
      } else {
        print("_getLoggedInUser failed in createActiveStudySession!");
      }
      return success;
    }
    //TODO: deal with exceptions that come from this method(low priority)
    catch (e) {
      print("Error came from createArchivedStudySession\t" + e.toString());
      return success;
    }
  }

  static Future<List<DocumentReference>> _getParticipants(
      ActiveStudySession activeStudySession) async {
    try {
      Firestore _firestore = Firestore.instance;
      String uniqueRefKey = activeStudySession.getCreatorID() +
          activeStudySession.getDateTime().toIso8601String();
      var aSSMap = await _firestore
          .collection('activeStudySessions')
          .document(uniqueRefKey)
          .get();
      List<DocumentReference> participantsList = List();
      for (var participantRef in aSSMap['participants']) {
        DocumentReference person = participantRef;
        participantsList.add(person);
      }
      if (participantsList != null) {
        return participantsList;
      } else {
        return List();
      }
    }
    //TODO: deal with exceptions that come from this method(low priority)
    catch (e) {
      print("Error came from _getParticipants\t" + e.toString());
      return List();
    }
  }

  static Future<bool> rateStudySession(
      ArchivedStudySession archivedStudySession, double rating) async {
    bool success = false;
    try {
      Firestore _firestore = Firestore.instance;
      final FirebaseUser loggedInUser = await _getLoggedInUser();
      if (loggedInUser != null) {
        print("I got the user");
        String uniqueRefKey = archivedStudySession.getCreatorID() +
            archivedStudySession.getDateTime().toIso8601String();
        print("I made the unique ref key");
        await _firestore
            .collection('archivedStudySessions')
            .document(uniqueRefKey)
            .updateData({
          'noOfRatings': FieldValue.increment(1),
          'totalRating': FieldValue.increment(rating),
          'ratedBy': FieldValue.arrayUnion(
              [_firestore.collection('users').document(loggedInUser.uid)]),
        });
        success = true;
      } else {
        print("_getLoggedInUser failed in rateStudySession!");
      }
      return success;
    }
    //TODO: deal with exceptions that come from this method(low priority)
    catch (e) {
      print("Error came from rateStudySession\t" + e.toString());
      return success;
    }
  }

  ///List of Modules to be retrieved from Database method here, to be used
  ///in screens where full list of modules is required(Registration, EditProfile)
  static Future<List<Module>> getAllModules() async {
    if (Cache.allModules.isEmpty) {
      Firestore _firestore = Firestore.instance;
      List<Module> moduleList = List();
      try {
        await _firestore
            .collection('modules')
            .getDocuments()
            .then((querySnapshot) {
          querySnapshot.documents.forEach((documentSnapshot) {
            var mod = documentSnapshot.data;
            Module module = new Module(
                moduleTitle: mod['title'], moduleCode: mod['moduleCode']);
            moduleList.add(module);
          });
          print("got all the modules in the database");
        });
        moduleList.sort((a, b) => a.moduleCode.compareTo(b.moduleCode));
        return moduleList;
      }
      //TODO: deal with exceptions that come from this method(low priority)
      catch (e) {
        print("Error came from getAllModules\t" + e.toString());
      }
    } else {
      return Cache.allModules;
    }
  }

  ///Methods to convert Modules, Venues, ArchivedStudySessions from/to the Database format
  ///Private method for _createUserCollection, converts the the modules into
  ///the format required for the firestore
  static List<Map<String, String>> _getFormattedModules(Account account) {
    List<Map<String, String>> modulesConverted = List();
    List<Module> moduleList = account.getModules();
    for (Module m in moduleList) {
      modulesConverted.add(_moduleToMap(m));
    }
    return modulesConverted;
  }

  ///Private method to convert the Map modules format in the database into a
  ///List of Module objects that can be passed around easily for the app
  static List<Module> _mapModulesIntoList(List<dynamic> mapModules) {
    List<Module> converted = List();
    for (var mapMod in mapModules) {
      converted.add(_moduleFromMap(mapMod));
    }
    return converted;
  }

  static Map<String, String> _moduleToMap(Module module) {
    return {
      'moduleCode': module.moduleCode,
      'moduleTitle': module.moduleTitle,
    };
  }

  static Module _moduleFromMap(var moduleMap) {
    return new Module(
        moduleCode: moduleMap['moduleCode'],
        moduleTitle: moduleMap['moduleTitle']);
  }

  static Map<String, String> _venueToMap(Venue venue) {
    return {'name': venue.getName()};
  }

  static Venue _venueFromMap(Map<String, dynamic> venueMap) {
    return new Venue(name: venueMap['name']);
  }

  static Future<ArchivedStudySession> _archivedStudySessionFromMap(
      Map<String, dynamic> archivedSSMap) async {
    print("I reached inside _archivedStudySessionFromMap");
    double rating = (archivedSSMap['totalRating'] / archivedSSMap['noOfRatings']).toDouble();
//    print(rating.toString());
    //Rating is correct
    print("I reached after aSS object was created");
    try {
      List<Profile> participantsList = List();
      for (DocumentReference docRef in archivedSSMap['participants']) {
        double rating = 0;
        int counter = 0;
        var document = await docRef.get();
        var participantMap = document.data;
        print(participantMap['nickname']);
        for (DocumentReference historySSRef in participantMap['history']) {
          var historySS = await historySSRef.get();
//          print((historySS['totalRating'] / historySS['noOfRatings']).toString());
          //Rating is correct
          counter++;
          rating =
              rating + (historySS['totalRating'] / historySS['noOfRatings']);
        }
        if (counter == 0) {
          rating = 0;
        } else {
          rating = rating / counter;
        }
        Account profileDetailsOnly = new Account(
          biography: participantMap['biography'],
          nickname: participantMap['nickname'],
          year: participantMap['year'],
          rating: rating,
        );
//        print(profileDetailsOnly.getProfile().toString());
        //Profile object is Ok, code doesnt throw error until here
        participantsList.add(profileDetailsOnly.getProfile());
        print("I reached after addParticipant was called");
      }
      ArchivedStudySession aSS = new ArchivedStudySession(
        title: archivedSSMap['title'],
        module: _moduleFromMap(archivedSSMap['module']),
        venue: _venueFromMap(archivedSSMap['venue']),
        rating: rating,
        dateTime: archivedSSMap['datetime'].toDate(),
        participants: participantsList,
        creatorID: archivedSSMap['creatorID'],
      );
      for (DocumentReference docRef in archivedSSMap['ratedBy']) {
        double rating = 0;
        int counter = 0;
        var document = await docRef.get();
        var participantMap = document.data;
        for (DocumentReference historySSRef in participantMap['history']) {
          var historySS = await historySSRef.get();
          counter++;
          rating =
              rating + (historySS['totalRating'] / historySS['noOfRatings']);
        }
        if (counter == 0) {
          rating = 0;
        } else {
          rating = rating / counter;
        }
        Account profileDetailsOnly = new Account(
          biography: participantMap['biography'],
          nickname: participantMap['nickname'],
          year: participantMap['year'],
          rating: rating,
        );
        aSS.addParticipantRatedBy(profileDetailsOnly.getProfile());
      }
      return aSS;
    }
    //TODO: deal with exceptions that come from this method(low priority)
    catch (e) {
      print("Error came from _archivedStudySessionFromMap\t" + e.toString());
      return null;
    }
  }

  static Future<ActiveStudySession> _activeStudySessionFromMap(
      Map<String, dynamic> activeSSMap) async {
    try {
      ActiveStudySession aSS;
      print(activeSSMap['participants'].length.toString() +
          " This is the number of people in the study session");
      List<dynamic> participantsRef = activeSSMap['participants'];
      for (int i = 0; i < participantsRef.length; i++) {
        DocumentSnapshot snapshot = await participantsRef[i].get();
        var participantMap = snapshot.data;
        print(participantMap['nickname']);
        double rating = 0;
        int counter = 0;
        for (DocumentReference historySSRef in participantMap['history']) {
          var historySS = await historySSRef.get();
          counter++;
          rating =
              rating + (historySS['totalRating'] / historySS['noOfRatings']);
        }
        if (counter == 0) {
          rating = 0;
        } else {
          rating = rating / counter;
        }
        Account profileDetailsOnly = new Account(
            biography: participantMap['biography'],
            nickname: participantMap['nickname'],
            year: participantMap['year'],
          rating: rating,
        );
        for (DocumentReference archivedStudySessionRef
            in participantMap['history']) {
          DocumentSnapshot aSSSnapshot = await archivedStudySessionRef.get();
          var aSSMap = aSSSnapshot.data;
          ArchivedStudySession archivedStudySession =
              await _archivedStudySessionFromMap(aSSMap);
          profileDetailsOnly.addStudySessionToHistory(archivedStudySession);
        }
        if (i == 0) {
          print(activeSSMap['datetime'].toString());
          aSS = new ActiveStudySession(
            capacity: activeSSMap['capacity'],
            creatorID: activeSSMap['creatorID'],
            dateTime: activeSSMap['datetime'].toDate(),
            description: activeSSMap['description'],
            module: _moduleFromMap(activeSSMap['module']),
            venue: _venueFromMap(activeSSMap['venue']),
            title: activeSSMap['title'],
            creator: profileDetailsOnly.getProfile(),
            isEnded: activeSSMap['isEnded'],
          );
        } else {
          aSS.addParticipant(profileDetailsOnly.getProfile());
        }
      }
      print(aSS.toString());
      return aSS;
    }
    //TODO: deal with exceptions that come from this method(low priority)
    catch (e) {
      print("Error came from _activeStudySessionFromMap\t" + e.toString());
      return null;
    }
  }

  ///Cache methods start here. Technically for our project, we should separate this for
  ///better clarity but for our timeframe, all these methods are gonna remain here.

  static void getUpdatedVenues() {
    //TODO: Make ApiCall here to get all the venues
    Cache.venues = NUSDatabase.venues;
  }

  static void addAccount(Account account) {
    //TODO: Make ApiCall here to add Account to Database
    NUSDatabase.addAccount(account);
  }

  @deprecated
  static bool verifyCredentials(String userName, String password) {
    //TODO: Make ApiCall here to verify credentials and return true iff there is an account and the password is correct
    //TODO: Probably need to split this into 2 separate methods
    for (Account acc in NUSDatabase.accounts) {
      if (acc.getNickName() == userName && acc.getPassword() == password) {
        return true;
      }
    }
    return false;
  }

  static bool usernameExists(String username) {
    //TODO: Make Api Call to check all Accounts to see if there is an account with this username
    bool answer = false;
    for (Account acc in NUSDatabase.accounts)
      if (username == acc.getNickName()) answer = true;
    return answer;
  }

  static bool studentNumberExists(String studentNumber) {
    //TODO: Make Api Call to check all Accounts to see if there is an account with this studentNumber
    bool answer = false;
    for (Account acc in NUSDatabase.accounts)
      if (studentNumber == acc.getNUSNETID()) answer = true;
    return answer;
  }

  static void getAccount(String username) {
    //TODO: Make ApiCall here to get all the details of the account as it stands
    for (Account acc in NUSDatabase.accounts) {
      if (acc.getNickName() == username) {
        Cache.account = acc;
      }
    }
  }

  static void joinSession(ActiveStudySession studySession) {
    //TODO: Make Api Call here that adds Account into the study session
    Cache.account.joinStudySession(studySession);
    updateAccount(Cache.account);
  }

  static void leaveSession(ActiveStudySession studySession) {
    //TODO: Make Api Call here that removes Account from study session
    Cache.account.leaveStudySession(studySession);
    updateAccount(Cache.account);
  }

  static void getModuleStudySessions(Module module) {
    //TODO: Hopefully there is a way to organise all active study sessions based on the modules so we just need to make that call
    Cache.moduleStudySessions = NUSDatabase.getModuleStudySessions(module);
  }

  static void addStudySession(ActiveStudySession studySession) {
    //TODO: Make Api Call here that adds the study Session that was just created
    NUSDatabase.studySessions.add(studySession);
  }

  static void updateAccount(Account account) {
    /*TODO: Make Api call that updates account information after specific actions
      1. study session is created
      2. Account data is edited i.e. profile is edited
     */
    for (Account acc in NUSDatabase.accounts) {
      if (acc.getNickName() == account.getNickName()) {
        acc = account;
      }
    }
  }
}
