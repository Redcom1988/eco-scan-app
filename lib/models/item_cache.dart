import 'package:ecoscan/backend-client/qrcode_machine_handler.dart';
import 'package:ecoscan/models/item.dart';

class ItemCache {
  static Map<String, Item> _items = {};

  static Future<void> initialize() async {
    final response = await getItems();
    if (response.success && response.items != null) {
      _items = {for (var item in response.items!) item.itemId.toString(): item};
    }
  }

  static String getItemName(String id) {
    // Convert string id to int since your Item class uses itemId as int
    try {
      final numId = int.parse(id);
      return _items[numId.toString()]?.itemName ?? 'Unknown Item (ID: $id)';
    } catch (e) {
      print('Error parsing item ID: $e');
      return 'Unknown Item (ID: $id)';
    }
  }

  static double getItemValue(String id) {
    try {
      final numId = int.parse(id);
      return _items[numId.toString()]?.unitValue ?? 0.0;
    } catch (e) {
      print('Error parsing item ID: $e');
      return 0.0;
    }
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
