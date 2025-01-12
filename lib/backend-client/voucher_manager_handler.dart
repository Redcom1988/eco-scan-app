import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>?> fetchVouchers() async {
  try {
    final response = await http.get(
      Uri.parse(
          'https://w4163hhc-3000.asse.devtunnels.ms/vouchers/getVouchers'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      return responseData
          .map((voucher) => {
                'voucherId': voucher['voucherId'],
                'voucherCode': voucher['voucherCode'],
                'voucherPrice': voucher['voucherPrice'],
                'expiryDate': voucher['expiryDate'],
                'isActive': voucher['isActive'] == 1,
              })
          .toList();
    } else {
      print('Failed to fetch vouchers: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null;
    }
  } catch (e) {
    print('Error fetching vouchers: $e');
    return null;
  }
}

Future<bool> editVoucher({
  required String voucherId,
  required String voucherCode,
  required int voucherPrice,
  required String voucherDesc,
  required String expiryDate,
  required bool isActive,
}) async {
  try {
    final response = await http
        .post(
          Uri.parse(
              'https://w4163hhc-3000.asse.devtunnels.ms/vouchers/editVoucher'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'voucherId': voucherId,
            'voucherCode': voucherCode,
            'voucherPrice': voucherPrice,
            'voucherDesc': voucherDesc,
            'expiryDate': expiryDate,
            'isActive': isActive ? 1 : 0,
          }),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Failed to edit voucher: ${response.statusCode}');
      print('Response body: ${response.body}');
      return false;
    }
  } catch (e) {
    print('Error editing voucher: $e');
    return false;
  }
}

Future<bool> addVoucher({
  required String voucherCode,
  required int voucherPrice,
  required String voucherDesc,
  required String expiryDate,
  bool isActive = true,
}) async {
  try {
    final response = await http
        .post(
          Uri.parse(
              'https://w4163hhc-3000.asse.devtunnels.ms/vouchers/addVoucher'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'voucherCode': voucherCode,
            'voucherPrice': voucherPrice,
            'voucherDesc': voucherDesc,
            'expiryDate': expiryDate,
            'isActive': isActive,
          }),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Failed to add voucher: ${response.statusCode}');
      print('Response body: ${response.body}');
      return false;
    }
  } catch (e) {
    print('Error adding voucher: $e');
    return false;
  }
}
