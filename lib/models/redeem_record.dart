class RedeemRecord {
  final DateTime redeemDate;
  final double voucherValue;
  final String voucherCode;

  RedeemRecord({
    required this.redeemDate,
    required this.voucherValue,
    required this.voucherCode,
  });

  factory RedeemRecord.fromJson(Map<String, dynamic> json) {
    return RedeemRecord(
      redeemDate: json['redeemDate'] != null 
          ? DateTime.parse(json['redeemDate']) 
          : DateTime.now(),
      voucherValue: (json['voucherValue'] ?? 0).toDouble(),
      voucherCode: json['voucherCode'] ?? '',
    );
  }
}
