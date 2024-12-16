class WithdrawalResponse {
  final bool success;
  final String? error;
  final int? withdrawalId;
  final double? totalValue;

  WithdrawalResponse({
    required this.success,
    this.error,
    this.withdrawalId,
    this.totalValue,
  });
}
