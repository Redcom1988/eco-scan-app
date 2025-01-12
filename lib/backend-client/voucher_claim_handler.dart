import 'package:ecoscan/models/owned_voucher.dart';
import 'package:ecoscan/models/redeem_record.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Get all vouchers function
Future<List<Map<String, dynamic>>> getVouchers() async {
  try {
    print('Fetching all vouchers');

    final uri = Uri.parse(
        'https://w4163hhc-3000.asse.devtunnels.ms/vouchers/getVouchers');
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
      final List<dynamic> responseData = jsonDecode(response.body);
      print('Parsed response data: $responseData');

      return responseData.cast<Map<String, dynamic>>();
    } else {
      print('HTTP request failed with status: ${response.statusCode}');
      print('Error response body: ${response.body}');
      return [];
    }
  } catch (e, stackTrace) {
    print('Exception in getVouchers: $e');
    print('Stack trace: $stackTrace');
    return [];
  }
}

// Get all active vouchers function
Future<List<Map<String, dynamic>>> getActiveVouchers() async {
  try {
    print('Fetching all vouchers');

    final uri = Uri.parse(
        'https://w4163hhc-3000.asse.devtunnels.ms/vouchers/getActiveVouchers');
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
      final List<dynamic> responseData = jsonDecode(response.body);
      print('Parsed response data: $responseData');

      return responseData.cast<Map<String, dynamic>>();
    } else {
      print('HTTP request failed with status: ${response.statusCode}');
      print('Error response body: ${response.body}');
      return [];
    }
  } catch (e, stackTrace) {
    print('Exception in getVouchers: $e');
    print('Stack trace: $stackTrace');
    return [];
  }
}

// Claim voucher function
Future<Map<String, dynamic>> claimVoucher({
  required String userId,
  required String voucherId,
}) async {
  try {
    print('Claiming voucher - UserId: $userId, VoucherId: $voucherId');

    final uri = Uri.parse(
        'https://w4163hhc-3000.asse.devtunnels.ms/vouchers/claimVoucher');
    print('Request URL: $uri');

    final response = await http
        .post(
          uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'userId': userId,
            'voucherId': voucherId,
          }),
        )
        .timeout(Duration(seconds: 10));

    print('Response status code: ${response.statusCode}');
    print('Raw response body: ${response.body}');

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print('Parsed response data: $responseData');

      if (responseData['success'] == true) {
        print('Successfully claimed voucher');
        return responseData;
      } else {
        print('Response indicated failure. Error: ${responseData['error']}');
        return {
          'success': false,
          'error': responseData['error'] ?? 'Unknown error occurred'
        };
      }
    } else {
      print('HTTP request failed with status: ${response.statusCode}');
      print('Error response body: ${response.body}');
      return {
        'success': false,
        'error': 'Request failed with status: ${response.statusCode}'
      };
    }
  } catch (e, stackTrace) {
    print('Exception in claimVoucher: $e');
    print('Stack trace: $stackTrace');
    return {'success': false, 'error': 'Exception occurred: $e'};
  }
}

// Get all owned vouchers function
Future<List<OwnedVoucher>> getOwnedVouchers({required String userId}) async {
  try {
    print('Fetching all owned vouchers for user: $userId');

    final uri = Uri.parse(
        'https://w4163hhc-3000.asse.devtunnels.ms/vouchers/getOwnedVouchers/$userId');

    print('Request URL: $uri');

    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).timeout(const Duration(seconds: 10));

    print('Response status code: ${response.statusCode}');
    print('Raw response body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      print('Parsed response data: $responseData');

      final vouchers = responseData.map((data) {
        try {
          final voucher = OwnedVoucher.fromJson(data);
          print('Successfully parsed voucher: ${voucher.voucherId}');
          return voucher;
        } catch (e) {
          print('Error parsing individual voucher: $e');
          print('Problematic data: $data');
          rethrow;
        }
      }).toList();

      print('Successfully parsed ${vouchers.length} vouchers');
      return vouchers;
    } else {
      print('HTTP request failed with status: ${response.statusCode}');
      print('Error response body: ${response.body}');
      return [];
    }
  } catch (e, stackTrace) {
    print('Exception in getOwnedVouchers: $e');
    print('Stack trace: $stackTrace');
    return [];
  }
}

Future<List<RedeemRecord>> getRedeemRecords({required int userId}) async {
  try {
    print('Fetching redeem records for user: $userId');

    final uri = Uri.parse(
        'https://w4163hhc-3000.asse.devtunnels.ms/vouchers/getRedeemRecords/$userId');

    print('Request URL: $uri');

    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).timeout(const Duration(seconds: 10));

    print('Response status code: ${response.statusCode}');
    print('Raw response body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      print('Parsed response data: $responseData');

      final records = responseData.map((data) {
        try {
          final record = RedeemRecord.fromJson(data);
          print(
              'Successfully parsed redeem record with price: ${record.voucherPrice}');
          return record;
        } catch (e) {
          print('Error parsing individual redeem record: $e');
          print('Problematic data: $data');
          rethrow;
        }
      }).toList();

      print('Successfully parsed ${records.length} redeem records');
      return records;
    } else {
      print('HTTP request failed with status: ${response.statusCode}');
      print('Error response body: ${response.body}');
      return [];
    }
  } catch (e, stackTrace) {
    print('Exception in getRedeemRecords: $e');
    print('Stack trace: $stackTrace');
    return [];
  }
}
