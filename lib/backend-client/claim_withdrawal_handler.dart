import 'dart:async';
import 'dart:convert';
import 'package:ecoscan/models/withdrawal_record.dart';
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

Future<int> getId(String username) async {
  try {
    print('Fetching ID for username: $username');

    final uri = Uri.parse(
        'https://w4163hhc-3000.asse.devtunnels.ms/users/getId?username=$username');
    print('Request URL: $uri');

    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).timeout(Duration(seconds: 10));

    print('Response status code: ${response.statusCode}');
    print('Raw response body: ${response.body}');

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print('Parsed response data: $responseData');

      if (responseData['success'] == true) {
        final id = responseData['userid'];
        if (id != null) {
          print('Successfully got ID: $id');
          return id;
        }
        print('ID field is null in response');
        return -1;
      } else {
        print('Response indicated failure. Error: ${responseData['error']}');
        return -1;
      }
    } else {
      print('HTTP request failed with status: ${response.statusCode}');
      print('Error response body: ${response.body}');
      return -1;
    }
  } catch (e, stackTrace) {
    print('Exception in getId: $e');
    print('Stack trace: $stackTrace');
    return -1;
  }
}

Future<ClaimResponse> claimWithdrawal(int withdrawalId, int userId) async {
  try {
    final checkResponse = await http.get(
      Uri.parse(
          'https://w4163hhc-3000.asse.devtunnels.ms/withdrawals/$withdrawalId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).timeout(Duration(seconds: 10));

    print("Check response status: ${checkResponse.statusCode}");
    print("Check response body: ${checkResponse.body}");

    if (checkResponse.statusCode == 200) {
      final withdrawalData = json.decode(checkResponse.body)['data'];

      if (withdrawalData['userId'] != null) {
        return ClaimResponse(
          success: false,
          error: 'This withdrawal has already been claimed',
        );
      }
    } else if (checkResponse.statusCode == 404) {
      return ClaimResponse(
        success: false,
        error: 'Withdrawal not found',
      );
    }

    // If not claimed, proceed with claiming
    final response = await http
        .put(
          Uri.parse(
              'https://w4163hhc-3000.asse.devtunnels.ms/withdrawals/claim/$withdrawalId'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'userId': userId,
          }),
        )
        .timeout(Duration(seconds: 10));

    print("Claim response status: ${response.statusCode}");
    print("Claim response body: ${response.body}");

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> data = json.decode(response.body);
        return ClaimResponse(
          success: true,
          message: 'Withdrawal claimed successfully',
          claimedAmount: data['updatedValue']?.toDouble(),
          data: data,
        );
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

Future<List<WithdrawalRecord>> getWithdrawals(int userId) async {
  final Uri url =
      Uri.parse('https://w4163hhc-3000.asse.devtunnels.ms/withdrawals/$userId');

  try {
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => WithdrawalRecord.fromJson(json)).toList();
    } else {
      throw Exception(
          'Failed to load withdrawals. Status code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error fetching withdrawals: $e');
  }
}

List<WithdrawalRecord> parseWithdrawals(String responseBody) {
  final parsed = json.decode(responseBody);
  return (parsed as List)
      .map((json) => WithdrawalRecord.fromJson(json))
      .toList();
}
