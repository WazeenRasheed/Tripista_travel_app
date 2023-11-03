import 'package:intl/intl.dart';

import 'companion_model.dart';

class TripModal {
  int? id;
  String? coverPic;
  String tripName;
  String destination;
  int budget;
  String startingDate;
  String endingDate;
  late final String transport;
  String travelPurpose;
  String? notes;
  int? userID;
  List<CompanionModel> companions;

  TripModal({
    required this.tripName,
    required this.destination,
    required this.budget,
    required this.startingDate,
    required this.endingDate,
    required this.transport,
    required this.travelPurpose,
    this.coverPic,
    this.notes,
    this.id,
    required this.userID,
    this.companions = const [],
  });

  static TripModal fromJson(map) {
    int? budget = int.tryParse(map['budget']);
    final startDate = DateFormat('yyyy-MM-dd').parse(map['startingDate']);
    final startingDate = DateFormat.yMMMd().format(startDate);
    final endDate = DateFormat('yyyy-MM-dd').parse(map['endingDate']);
    final endingDate = DateFormat.yMMMd().format(endDate);
    return TripModal(
        id: map['id'],
        coverPic: map['coverPic'],
        tripName: map['tripName'],
        destination: map['destination'],
        budget: budget!,
        startingDate: startingDate,
        endingDate: endingDate,
        transport: map['transport'],
        travelPurpose: map['travelPurpose'],
        notes: map['notes'],
        userID: map['userID']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tripName': tripName,
      'destination': destination,
      'budget': budget,
      'startingDate': startingDate,
      'endingDate': endingDate,
      'transport': transport,
      'travelPurpose': travelPurpose,
      'coverPic': coverPic,
      'notes': notes,
      'userID': userID,
    };
  }
}
