class OwnedVoucher {
  final int redeemId;
  final int voucherId;
  final String? voucherCode;
  final double? voucherPrice;
  final String? voucherDesc;
  final DateTime? expiryDate;
  final DateTime redeemDate;
  final bool used;

  OwnedVoucher({
    required this.redeemId,
    required this.voucherId,
    this.voucherCode,
    this.voucherPrice,
    this.voucherDesc,
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
        voucherPrice: (json['voucherPrice'] as num?)?.toDouble(),
        voucherDesc: json['voucherDesc'] as String?,
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
