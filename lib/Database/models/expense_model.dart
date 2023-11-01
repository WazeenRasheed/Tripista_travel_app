class Expenses {
  int? totalexpense;
  int? balance;
  int? food;
  int? transport;
  int? hotel;
  int? other;
  int? tripID;
  Expenses(
      {this.totalexpense,
      this.food,
      this.hotel,
      this.other,
      this.transport,
      this.balance,
      this.tripID});

  Map<String, dynamic> toMap(Expenses expense) {
    return {
      'totalexpense': expense.totalexpense,
      'tripId': expense.tripID,
      'food': expense.food,
      'transport': expense.transport,
      'hotel': expense.hotel,
      'other': expense.other,
      'balance': expense.balance,
    };
  }
}
