class WithdrawalResponse {
  final bool success;
  final String? error;
  final int? withdrawalId;

  WithdrawalResponse({
    required this.success,
    this.error,
    this.withdrawalId,
  });
}
