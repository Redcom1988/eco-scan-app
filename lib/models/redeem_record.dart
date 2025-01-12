class RedeemRecord {
  final DateTime redeemDate;
  final double voucherPrice;
  final String voucherCode;

  RedeemRecord({
    required this.redeemDate,
    required this.voucherPrice,
    required this.voucherCode,
  });

  factory RedeemRecord.fromJson(Map<String, dynamic> json) {
    return RedeemRecord(
      redeemDate: json['redeemDate'] != null
          ? DateTime.parse(json['redeemDate'])
          : DateTime.now(),
      voucherPrice: (json['voucherPrice'] ?? 0).toDouble(),
      voucherCode: json['voucherCode'] ?? '',
    );
  }
}
