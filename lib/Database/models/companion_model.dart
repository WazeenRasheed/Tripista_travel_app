class CompanionModel {
  int? id;
  String name;
  String number;
  int? tripID;

  CompanionModel(
      {this.id,
      required this.name,
      required this.number,
      required this.tripID});

  static CompanionModel fromJson(map) {
    return CompanionModel(
        id: map['id'],
        name: map['name'],
        number: map['number'],
        tripID: map['tripID']);
  }

  Map<String, dynamic> toMap(CompanionModel companion) {
    return {
      'name': companion.name,
      'number': companion.number,
      'tripID': companion.tripID,
    };
  }
}
