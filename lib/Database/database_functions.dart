// ignore_for_file: unnecessary_null_comparison, invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'models/companion_model.dart';
import 'models/expense_model.dart';
import 'models/trip_model.dart';
import 'models/user_model.dart';

ValueNotifier<int> totalExpenses = ValueNotifier(0);
ValueNotifier<int> balanceNotifire = ValueNotifier(0);
ValueNotifier<List<Expenses>> expenseNotifier =
    ValueNotifier<List<Expenses>>([]);

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper();
  ValueNotifier<List<UserModal>> userListNotifier = ValueNotifier([]);
  ValueNotifier<List<TripModal>> tripListNotifier = ValueNotifier([]);
  late Database _db;

  initDatabase() async {
    _db = await openDatabase(
      'user.db', //database file name
      version: 1,
      onCreate: (db, int version) async {
        db.execute('''CREATE TABLE user (
            id INTEGER PRIMARY KEY,
            name TEXT,
            mail TEXT,
            password TEXT,
            image TEXT,
            isLogin INTEGER)''');

        db.execute('''CREATE TABLE trip (
            id INTEGER PRIMARY KEY,
            tripName TEXT,
            destination TEXT,
            budget TEXT,
            startingDate TEXT,
            endingDate TEXT,
            transport TEXT,
            travelPurpose TEXT,
            coverPic TEXT,
            notes TEXT,
            userID INTEGER,
            FOREIGN KEY(userID) REFERENCES user (id) ON DELETE CASCADE)''');

        db.execute('''CREATE TABLE companions (
              id INTEGER PRIMARY KEY,
              name TEXT, 
              number TEXT, 
              tripID INTEGER,
              FOREIGN KEY(tripID) REFERENCES trip (id) ON DELETE CASCADE)''');

        db.execute(''' CREATE TABLE expense (
           id INTEGER PRIMARY KEY ,
           tripID INTEGER ,
           totalexpense INTEGER ,
           balance INTEGER,
           food INTEGER ,
           transport INTEGER ,
           hotel INTEGER ,
           other INTEGER,
           FOREIGN KEY(tripID) REFERENCES trip (id) ON DELETE CASCADE)''');

        db.execute('''CREATE TABLE tripImages(
        id INTEGER PRIMARY KEY,
        tripID INTEGER,
        images TEXT,
        FOREIGN KEY(tripID) REFERENCES trip (id) ON DELETE CASCADE)''');
      },
      onConfigure: (Database db) async {
        await db.execute('PRAGMA foreign_keys = ON;');
      },
    );
  }

//..................................USER FUNCTIONS.......................................
//.......................................................................................

  Future<int> addUser(UserModal value) async {
    int id = await _db.rawInsert(
        'INSERT INTO user (name,mail,password,image,isLogin) VALUES (?,?,?,?,?)',
        [value.name, value.mail, value.password, value.image, 1]);
    value.id = id;
    getUser();
    return id;
  }

  getUser() async {
    userListNotifier.value.clear();
    final values = await _db.rawQuery('SELECT * FROM user'); //(* = columns)
    print(values);
  }

//validate User when login....................................
  validateUser(String username, String password) async {
    final List<Map<String, dynamic>> users = await _db.query(
      'user',
      where: 'name = ? AND password = ?',
      whereArgs: [username, password],
    );
    print(users);

    if (users.isNotEmpty) {
      int id = users.first['id'];
      await _db.update('user', {'isLogin': 1},
          where: 'id = ?', whereArgs: [id]);
      // User with matching username and password found
      return UserModal.fromJson(users.first);
    } else {
      return null;
    }
  }

//checking name when signin if name already exists.....................
  Future<bool> checkIfNameExists(String name) async {
    final List users = await _db.query(
      'user',
      where: 'name = ?',
      whereArgs: [name],
    );
    return users.isNotEmpty;
  }

//when user login make isLogin=1..........................................
  getLoggedUser() async {
    final user = await _db.query('user', where: 'isLogin=1', limit: 1);
    if (user.length == 0) {
      return null;
    } else {
      return UserModal.fromJson(user.first);
    }
  }

//when user signou make isLogin=0................................................
  signoutUser() async {
    final List<Map<String, dynamic>> user =
        await _db.query('user', where: 'isLogin = ?', whereArgs: [1], limit: 1);
    if (user.isNotEmpty) {
      int id = user.first['id'];
      _db.update('user', {'isLogin': 0}, where: 'id = ?', whereArgs: [id]);
    }
  }

  // ..................................TRIP functions.....................................
  //.....................................................................................

//add trip
  addTrip(TripModal value, List<Map<String, dynamic>> data) async {
    int id = await _db.rawInsert(
        'INSERT INTO trip (tripName,destination,budget,startingDate,endingDate,transport,travelPurpose,coverPic,notes,userID) VALUES (?,?,?,?,?,?,?,?,?,?)',
        [
          value.tripName,
          value.destination,
          value.budget,
          value.startingDate,
          value.endingDate,
          value.transport,
          value.travelPurpose,
          value.coverPic,
          value.notes,
          value.userID
        ]);

    for (var i = 0; i < data.length; i++) {
      data != null ? data[i]['tripID'] = id.toString() : null;
      addCompanions(data[i]);
      print(data[i]);
    }
    getAllTrip();

    final expense = Expenses(
        balance: value.budget,
        food: 0,
        transport: 0,
        hotel: 0,
        other: 0,
        tripID: id,
        totalexpense: 0);
    initExpense(expense);
  }

// get trips
  Future<List<TripModal>> getAllTrip() async {
    try {
      final List<Map<String, dynamic>> tripMaps = await _db.query('trip');
      final List<TripModal> trips =
          tripMaps.map((map) => TripModal.fromJson(map)).toList();
      return trips;
    } catch (e) {
      print('Error fetching trips: $e');
      return [];
    }
  }

//ongoing trip..........................................................
  Future<TripModal?> getOnGoingTrip(int userId) async {
    TripModal? obj;

    // DateTime currentDate = DateTime.now();
    String convertedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    var trips = await _db.query('trip',
        where: 'userID=? AND startingDate<=? AND endingDate>=?',
        whereArgs: [userId, convertedDate, convertedDate]);

    for (var map in trips) {
      if (map['startingDate'] != null) {
        obj = await TripModal.fromJson(map);

        // Fetch companions for this trip and add them to obj
        var companions = await _db
            .query('companions', where: 'tripID = ?', whereArgs: [obj.id]);

        obj.companions = companions
            .map((companionMap) => CompanionModel.fromJson(companionMap))
            .toList();
      }
    }
    return obj;
  }

//upcoming trip................................................................
  Future<List<TripModal>> getUpcomingTrip(int userId) async {
    List<TripModal> tripsList = [];

    // DateTime currentDate = DateTime.now();
    String convertedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    List trips = await _db.query('trip',
        where: 'userID=? AND startingDate>?',
        whereArgs: [userId, convertedDate]);

    for (var map in trips) {
      if (map['startingDate'] != null) {
        TripModal trip = await TripModal.fromJson(map);

        // Fetch companions for this trip and add them to obj
        var companions = await _db
            .query('companions', where: 'tripID = ?', whereArgs: [trip.id]);

        trip.companions = companions
            .map((companionMap) => CompanionModel.fromJson(companionMap))
            .toList();
        tripsList.add(trip);
      }
    }
    return tripsList;
  }

//recent trip...................................................................
  Future<List<TripModal>> getRecentTrip(int userId) async {
    List<TripModal> tripsList = [];

    // DateTime currentDate = DateTime.now();
    String convertedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    List trips = await _db.query('trip',
        where: 'userID=? AND endingDate<?', whereArgs: [userId, convertedDate]);

    for (var map in trips) {
      if (map['endingDate'] != null) {
        TripModal trip = await TripModal.fromJson(map);

        // Fetch companions for this trip and add them to obj
        var companions = await _db
            .query('companions', where: 'tripID = ?', whereArgs: [trip.id]);

        trip.companions = companions
            .map((companionMap) => CompanionModel.fromJson(companionMap))
            .toList();
        tripsList.add(trip);
      }
    }
    return tripsList;
  }

  Future<TripModal?> getTripById(int tripId) async {
    final List<Map<String, dynamic>> trips = await _db.query(
      'trip',
      where: 'id = ?',
      whereArgs: [tripId],
    );

    if (trips.isNotEmpty) {
      return TripModal.fromJson(trips.first);
    } else {
      return null;
    }
  }

  //update trip.......................................................
  updateTrip(
    TripModal trip,
  ) async {
    await _db.update(
      'trip',
      trip.toJson(), // Convert the TripModal object to a map.
      where: 'id = ?',
      whereArgs: [trip.id],
    );

    // updating balance when budget change
    final expList = await getExpense(trip.id!);
    final exp = expList[0];
    final expense = Expenses(balance: trip.budget - exp.totalexpense!);
    updateExpense(trip.id!, expense);
  }

//delete trip.......................................................
  deleteTrip(int tripId) async {
    await _db.rawDelete('DELETE FROM trip WHERE id = ?', [tripId]);
  }

  // delete all trips
  deleteAllTrips(int userId) async {
    _db.delete('trip', where: 'userID = ?', whereArgs: [userId]);
  }

  // .............................COMPANIONS functions...........................
  //............................................................................

// add companions
  addCompanions(Map<String, dynamic> companion) async {
    _db.insert('companions', companion);
  }

// get all companions
  Future<List<CompanionModel>> getAllCompanions(int tripId) async {
    List<CompanionModel> compList = [];
    List<Map<String, dynamic>> map =
        await _db.query('companions', where: 'tripId = ?', whereArgs: [tripId]);
    compList.addAll(
      List.generate(
        map.length,
        (index) => CompanionModel(
          name: map[index]['name'],
          number: map[index]['number'],
          tripID: map[index]['tripID'],
          id: map[index]['id'],
        ),
      ),
    );
    return compList;
  }

  ////////// Adding Trip Note/////////
  addNote(TripModal trip, String note) async {
    await _db.update('trip', {'notes': note},
        where: 'id = ?', whereArgs: [trip.id]);
  }

  // .............................Expense functions...........................
  //..........................................................................

// Store expense in first time adding
  initExpense(Expenses expense) async {
    await _db.rawInsert(
        '''INSERT INTO expense (totalexpense,balance,food,transport,hotel,other,tripID) VALUES(?,?,?,?,?,?,?)''',
        [
          expense.totalexpense,
          expense.balance,
          expense.food,
          expense.transport,
          expense.hotel,
          expense.other,
          expense.tripID
        ]);
    balanceNotifire.value = expense.balance ?? 0;
    balanceNotifire.notifyListeners();
  }

// add Expenses
  addExpences(
      {required String expType,
      required int newExp,
      required int tripID,
      required int oldExp,
      required int balance,
      required int fieldExp}) async {
    final totalExp = oldExp + newExp;

    final totalBal = balance - newExp;
    await _db.update('expense',
        {expType: fieldExp, 'totalexpense': totalExp, 'balance': totalBal},
        where: 'tripID = ?', whereArgs: [tripID]);

    getExpense(tripID);
  }

  // get all the expenses
  Future<List<Expenses>> getExpense(int tripID) async {
    expenseNotifier.value.clear();
    totalExpenses.value = 0;
    balanceNotifire.value = 0;
    List<Map<String, dynamic>> map =
        await _db.query('expense', where: 'tripID = ?', whereArgs: [tripID]);
    expenseNotifier.value.addAll(List.generate(
      map.length,
      (index) => Expenses(
          tripID: map[index]['tripID'] as int,
          food: map[index]['food'] as int,
          hotel: map[index]['hotel'] as int,
          transport: map[index]['transport'] as int,
          other: map[index]['other'] as int,
          totalexpense: map[index]['totalexpense'] as int,
          balance: map[index]['balance'] as int),
    ));
    if (map.isNotEmpty) {
      totalExpenses.value = map[0]['totalexpense'] as int;
      totalExpenses.notifyListeners();
      balanceNotifire.value = map[0]['balance'] as int;
      balanceNotifire.notifyListeners();
    }
    expenseNotifier.notifyListeners();
    return expenseNotifier.value;
  }

  // update balance when edited Trips(expene)
  updateExpense(int tripID, Expenses exp) async {
    Map<String, dynamic> row = {'balance': exp.balance};

    final map = await _db
        .update('expense', row, where: 'tripID = ?', whereArgs: [tripID]);
    getExpense(tripID);
    return map;
  }

//.............................Image Functions...........................
//..........................................................................

// Add images
  Future<void> addImages(int tripId, String imagePath) async {
    await _db.insert('tripImages', {
      'tripID': tripId,
      'images': imagePath,
    });
  }

// Get image
  Future<List<String>> getAllImages(int tripId) async {
    final result = await _db.query(
      'tripImages',
      columns: ['images'],
      where: 'tripID = ?',
      whereArgs: [tripId],
    );
    print(result);

    return result.map((row) => row['images'] as String).toList();
  }

  // Delete images
  Future<void> deleteImage(int tripId, String imagePath) async {
    await _db.delete(
      'tripImages',
      where: 'tripID = ? AND images = ?',
      whereArgs: [tripId, imagePath],
    );
  }
  
  //update Profile Picture 
  Future<void> updateProfilePicture(int userId, String imagePath) async {
    await _db.update('user', {'image': imagePath},
        where: 'id = ?', whereArgs: [userId]);
  }

  Future<Map<String, dynamic>> getLogedProfile() async {
    List<Map<String, dynamic>> map =
        await _db.query('user', where: 'isLogin = 1');
    return map.first;
  }
}
