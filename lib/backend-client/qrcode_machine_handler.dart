// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/withdrawal_response.dart';

Future<WithdrawalResponse> postWithdrawal(
    Map<String, dynamic> withdrawalData) async {
  try {
    final response = await http
        .post(
          Uri.parse('https://w4163hhc-3000.asse.devtunnels.ms/withdrawals/add'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(withdrawalData),
        )
        .timeout(Duration(seconds: 10));

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Withdrawal Success");
      return WithdrawalResponse(
        success: true,
      );
    } else {
      print("Withdrawal Failed");
      return WithdrawalResponse(
        success: false,
        error: 'Withdrawal submission failed. Please try again.',
      );
    }
  } catch (e) {
    return WithdrawalResponse(
      success: false,
      error: 'Network error. Please check your connection.',
    );
  }
}
