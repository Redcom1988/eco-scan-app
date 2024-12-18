import 'package:ecoscan/backend-client/qrcode_machine_handler.dart';
import 'package:ecoscan/models/item.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class WithdrawalScreen extends StatefulWidget {
  @override
  WithdrawalScreenState createState() => WithdrawalScreenState();
}

// Create a class to hold the item data
class ItemData {
  final ItemRow row;
  final GlobalKey<ItemRowState> key;

  ItemData(this.row, this.key);
}

class ItemRow extends StatefulWidget {
  final Function(ItemRow) onDelete;
  final List<Item> availableItems;
  final GlobalKey<ItemRowState> itemKey;

  ItemRow({
    required this.onDelete,
    required this.availableItems,
    required this.itemKey,
  }) : super(key: itemKey);

  @override
  ItemRowState createState() => ItemRowState();
}

class ItemRowState extends State<ItemRow> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
  Item? selectedItem;

  // Add getters to access the current values
  String? get itemId => selectedItem?.itemId.toString();
  String get quantity => qtyController.text;
  bool isValid() => selectedItem != null && quantity.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DropdownButton<Item>(
            hint: Text('Select Item'),
            value: selectedItem,
            onChanged: (Item? newValue) {
              setState(() {
                selectedItem = newValue;
                idController.text = newValue?.itemId.toString() ?? '';
              });
            },
            items: widget.availableItems.map((Item item) {
              return DropdownMenuItem<Item>(
                value: item,
                child: Text(item.itemName),
              );
            }).toList(),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: TextField(
            controller: qtyController,
            decoration: InputDecoration(
              labelText: 'Quantity',
              errorText: quantity.isEmpty ? 'Required' : null,
            ),
            keyboardType: TextInputType.number,
          ),
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            widget.onDelete(widget);
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    idController.dispose();
    qtyController.dispose();
    super.dispose();
  }
}

class WithdrawalScreenState extends State<WithdrawalScreen> {
  List<ItemData> items = [];
  int? withdrawalId;
  bool showQR = false;
  List<Item>? availableItems;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  Future<void> loadItems() async {
    setState(() {
      isLoading = true;
    });

    final response = await getItems();

    setState(() {
      if (response.success) {
        availableItems = response.items;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.error ?? 'Failed to load items')),
        );
      }
      isLoading = false;
    });

    if (availableItems != null && availableItems!.isNotEmpty) {
      addNewItem();
    }
  }

  void addNewItem() {
    if (availableItems == null || availableItems!.isEmpty) return;

    setState(() {
      final key = GlobalKey<ItemRowState>();
      final row = ItemRow(
        onDelete: (ItemRow item) {
          setState(() {
            items.removeWhere((itemData) => itemData.row == item);
          });
        },
        availableItems: availableItems ?? [],
        itemKey: key,
      );
      items.add(ItemData(row, key));
    });
  }

  bool validateForm() {
    bool isValid = true;
    for (var itemData in items) {
      if (!itemData.key.currentState!.isValid()) {
        isValid = false;
        break;
      }
    }
    return isValid;
  }

  Future<void> submitForm() async {
    if (items.isEmpty) return;

    if (!validateForm()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all required fields correctly'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final withdrawalData = {
      'contents': {
        'items': items
            .map((itemData) => {
                  'id': itemData.key.currentState!.itemId,
                  'qty': itemData.key.currentState!.quantity,
                })
            .toList(),
        'timestamp': DateTime.now().toUtc().toString(),
      }
    };

    try {
      final response = await postWithdrawal(withdrawalData);

      if (response.success && response.withdrawalId != null) {
        setState(() {
          withdrawalId = response.withdrawalId;
          showQR = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Withdrawal submitted successfully. ID: ${response.withdrawalId}'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.error ?? 'Failed to submit withdrawal'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error submitting withdrawal: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Rest of the build method remains the same, but update the ListView.builder:
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Machine'),
        leading: showQR
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    showQR = false;
                    withdrawalId = null;
                    items.clear();
                    addNewItem();
                  });
                },
              )
            : null,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : showQR
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 250,
                        height: 250,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 3,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: QrImageView(
                          data: withdrawalId.toString(),
                          version: QrVersions.auto,
                          size: 200.0,
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Withdrawal QR Code',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'ID: $withdrawalId',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 32),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            showQR = false;
                            withdrawalId = null;
                            items.clear();
                            addNewItem();
                          });
                        },
                        icon: Icon(Icons.add),
                        label: Text('Create New Withdrawal'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      if (availableItems?.isEmpty ?? true)
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'No items available',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            return items[index].row;
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: availableItems?.isEmpty ?? true
                                ? null
                                : addNewItem,
                            icon: Icon(Icons.add),
                            label: Text('Add Item'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: items.isEmpty ? null : submitForm,
                            icon: Icon(Icons.send),
                            label: Text('Submit'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }

  @override
  void dispose() {
    // Clean up is handled in ItemRowState
    super.dispose();
  }
}

void main() {
  runApp(MaterialApp(
    home: WithdrawalScreen(),
  ));
}
