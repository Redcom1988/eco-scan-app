import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ClaimResponse {
  final bool success;
  final String? message;
  final double? claimedAmount;
  final double? newBalance;
  final String? error;
  final Map<String, dynamic>? data;

  ClaimResponse({
    required this.success,
    this.message,
    this.claimedAmount,
    this.newBalance,
    this.error,
    this.data,
  });
}

Future<ClaimResponse> claimWithdrawal(int withdrawalId, int userId) async {
  try {
    final response = await http
        .put(
          Uri.parse(
              'https://w4163hhc-3000.asse.devtunnels.ms/withdrawals/claim/$withdrawalId'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'userId': userId,
            'claimedAt': DateTime.now().toUtc().toIso8601String(),
            'claimedBy': 'Redcom1988', // Current user's login
          }),
        )
        .timeout(Duration(seconds: 10));

    print("Claim response status: ${response.statusCode}");
    print("Claim response body: ${response.body}");

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success'] == true) {
          return ClaimResponse(
            success: true,
            message: data['message'] ?? 'Withdrawal claimed successfully',
            claimedAmount: data['data']?['claimedAmount']?.toDouble(),
            newBalance: data['data']?['newBalance']?.toDouble(),
            data: data['data'],
          );
        }

        throw FormatException('Server indicated failure: ${data['message']}');
      } catch (e) {
        print("Error parsing claim response: $e");
        return ClaimResponse(
          success: false,
          error: 'Invalid server response format: ${e.toString()}',
        );
      }
    } else {
      print("Claim Failed with status: ${response.statusCode}");
      String errorMessage;
      try {
        final errorData = json.decode(response.body);
        errorMessage = errorData['error'] ?? 'Claim submission failed';
      } catch (_) {
        errorMessage = 'Claim submission failed. Please try again.';
      }

      return ClaimResponse(
        success: false,
        error: errorMessage,
      );
    }
  } on TimeoutException {
    print("Claim request timed out");
    return ClaimResponse(
      success: false,
      error: 'Request timed out. Please try again.',
    );
  } catch (e) {
    print("Network error during claim: $e");
    return ClaimResponse(
      success: false,
      error: 'Network error: ${e.toString()}',
    );
  }
}

void onQRScanned(int withdrawalId, int userId) async {
  final result = await claimWithdrawal(withdrawalId, userId);

  if (result.success) {
    print('Successfully claimed: ${result.claimedAmount}');
    print('New balance: ${result.newBalance}');
  } else {
    print('Claim failed: ${result.error}');
  }
}
