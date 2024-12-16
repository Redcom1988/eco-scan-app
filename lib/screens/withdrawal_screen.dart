import 'package:ecoscan/backend-client/qrcode_machine_handler.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class WithdrawalForm extends StatefulWidget {
  @override
  WithdrawalFormState createState() => WithdrawalFormState();
}

class WithdrawalFormState extends State<WithdrawalForm> {
  List<ItemRow> items = [];
  int? withdrawalId;
  bool showQR = false; // New flag to control view

  @override
  void initState() {
    super.initState();
    addNewItem();
  }

  void addNewItem() {
    setState(() {
      items.add(ItemRow(
        onDelete: (ItemRow item) {
          setState(() {
            items.remove(item);
          });
        },
      ));
    });
  }

  Future<void> submitForm() async {
    final withdrawalData = {
      'contents': {
        'items': items
            .map((item) => {
                  'id': item.idController.text,
                  'qty': item.qtyController.text,
                })
            .toList()
      }
    };

    try {
      final response = await postWithdrawal(withdrawalData);

      if (response.success && response.withdrawalId != null) {
        print('Withdrawal ID: ${response.withdrawalId}');

        setState(() {
          withdrawalId = response.withdrawalId;
          showQR = true; // Show QR view after successful submission
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Withdrawal submitted successfully. ID: ${response.withdrawalId}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(response.error ?? 'Failed to submit withdrawal')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting withdrawal: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Machine Simulator'),
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
      body: showQR
          ? Center(
              // QR Code View
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
                    'Printed QR Code',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
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
                    label: Text('Create New Deposit'),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            )
          : Padding(
              // Form View
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return items[index];
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: addNewItem,
                        icon: Icon(Icons.add),
                        label: Text('Add Item'),
                      ),
                      ElevatedButton.icon(
                        onPressed: items.isEmpty ? null : submitForm,
                        icon: Icon(Icons.send),
                        label: Text('Submit'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}

// ItemRow class remains unchanged
class ItemRow extends StatelessWidget {
  final TextEditingController idController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
  final Function(ItemRow) onDelete;

  ItemRow({required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: idController,
                decoration: InputDecoration(
                  labelText: 'Item ID',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              flex: 1,
              child: TextField(
                controller: qtyController,
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => onDelete(this),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: WithdrawalForm(),
  ));
}
