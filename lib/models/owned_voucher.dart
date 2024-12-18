class OwnedVoucher {
  final int redeemId;
  final int voucherId;
  final String? voucherCode;
  final double? voucherValue;
  final DateTime? expiryDate;
  final DateTime redeemDate;
  final bool used;

  OwnedVoucher({
    required this.redeemId,
    required this.voucherId,
    this.voucherCode,
    this.voucherValue,
    this.expiryDate,
    required this.redeemDate,
    required this.used,
  });

  factory OwnedVoucher.fromJson(Map<String, dynamic> json) {
    try {
      return OwnedVoucher(
        redeemId: json['redeemId'] as int,
        voucherId: json['voucherId'] as int,
        voucherCode: json['voucherCode'] as String?,
        // Convert integer to double since the JSON has integer values
        voucherValue: (json['voucherValue'] as num?)?.toDouble(),
        expiryDate: json['expiryDate'] != null
            ? DateTime.parse(json['expiryDate'] as String)
            : null,
        redeemDate: DateTime.parse(json['redeemDate'] as String),
        used: json['used'] == 1 || json['used'] == true,
      );
    } catch (e) {
      print('Error parsing JSON to OwnedVoucher: $e');
      print('Problematic JSON: $json');
      rethrow;
    }
  }
}
