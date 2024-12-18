// lib/services/api_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/withdrawal_response.dart';
import 'package:ecoscan/models/item.dart';

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

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true && data['withdrawalId'] != null) {
          return WithdrawalResponse(
            success: true,
            withdrawalId: data['withdrawalId'],
            totalValue:
                data['totalValue']?.toDouble(), // Add totalValue handling
          );
        }

        // If the required fields aren't present, throw an exception to trigger the catch block
        throw FormatException('Missing required fields in response');
      } catch (e) {
        print("Error parsing response: $e");
        return WithdrawalResponse(
          success: false,
          error: 'Invalid server response format: ${e.toString()}',
        );
      }
    } else {
      print("Withdrawal Failed with status: ${response.statusCode}");
      // Try to parse error message from response if available
      String errorMessage;
      try {
        final errorData = json.decode(response.body);
        errorMessage = errorData['error'] ?? 'Withdrawal submission failed';
      } catch (_) {
        errorMessage = 'Withdrawal submission failed. Please try again.';
      }

      return WithdrawalResponse(
        success: false,
        error: errorMessage,
      );
    }
  } on TimeoutException {
    print("Request timed out");
    return WithdrawalResponse(
      success: false,
      error: 'Request timed out. Please try again.',
    );
  } catch (e) {
    print("Network error: $e");
    return WithdrawalResponse(
      success: false,
      error: 'Network error: ${e.toString()}',
    );
  }
}

class ItemsResponse {
  final bool success;
  final List<Item>? items;
  final String? error;

  ItemsResponse({
    required this.success,
    this.items,
    this.error,
  });
}

Future<ItemsResponse> getItems() async {
  try {
    final response = await http.get(
      Uri.parse('https://w4163hhc-3000.asse.devtunnels.ms/items/getItems'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).timeout(Duration(seconds: 10));

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      try {
        final List<dynamic> data = json.decode(response.body);
        final List<Item> items =
            data.map((item) => Item.fromJson(item)).toList();

        return ItemsResponse(
          success: true,
          items: items,
        );
      } catch (e) {
        print("Error parsing response: $e");
        return ItemsResponse(
          success: false,
          error: 'Invalid server response format: ${e.toString()}',
        );
      }
    } else {
      print("Fetching items failed with status: ${response.statusCode}");
      // Try to parse error message from response if available
      String errorMessage;
      try {
        final errorData = json.decode(response.body);
        errorMessage = errorData['error'] ?? 'Failed to fetch items';
      } catch (_) {
        errorMessage = 'Failed to fetch items. Please try again.';
      }
      return ItemsResponse(
        success: false,
        error: errorMessage,
      );
    }
  } on TimeoutException {
    print("Request timed out");
    return ItemsResponse(
      success: false,
      error: 'Request timed out. Please try again.',
    );
  } catch (e) {
    print("Network error: $e");
    return ItemsResponse(
      success: false,
      error: 'Network error: ${e.toString()}',
    );
  }
}
