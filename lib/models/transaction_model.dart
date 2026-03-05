class TransactionModel {
  final int? id;
  final double amount;
  final String? promoCode;
  final String cardLastFour;
  final String timestamp;

  TransactionModel({
    this.id,
    required this.amount,
    this.promoCode,
    required this.cardLastFour,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'promoCode': promoCode,
      'cardLastFour': cardLastFour,
      'timestamp': timestamp,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      amount: map['amount'],
      promoCode: map['promoCode'],
      cardLastFour: map['cardLastFour'],
      timestamp: map['timestamp'],
    );
  }
}
