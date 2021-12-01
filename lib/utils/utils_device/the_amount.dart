
class TheAmount {
  TheAmount({
    required this.amount,
  });




  TheAmount.fromJson(Map<String, Object?> json)
      : this(
    amount: json['amount']! as dynamic,
  );



  final dynamic amount;




  Map<String, Object?> toJson() {
    return {
      'amount': amount,
    };
  }
}