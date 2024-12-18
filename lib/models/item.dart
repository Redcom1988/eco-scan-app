class Item {
  final int itemId;
  final String itemName;
  final double unitValue;

  Item({
    required this.itemId,
    required this.itemName,
    required this.unitValue,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      itemId: json['itemId'],
      itemName: json['itemName'],
      unitValue: json['unitValue'].toDouble(),
    );
  }
}
