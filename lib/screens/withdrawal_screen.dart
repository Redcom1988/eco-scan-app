import 'package:ecoscan/backend-client/qrcode_machine_handler.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class WithdrawalForm extends StatefulWidget {
  @override
  WithdrawalFormState createState() => WithdrawalFormState();
}

class WithdrawalFormState extends State<WithdrawalForm> {
  List<ItemRow> items = [];

  @override
  void initState() {
    super.initState();
    // Start with one empty row
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
    // Create the data structure
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

    print('Sending data: ${jsonEncode(withdrawalData)}'); // Debug print

    try {
      final response = await postWithdrawal(withdrawalData);

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Withdrawal submitted successfully')),
        );
        // Clear the form
        setState(() {
          items.clear();
          addNewItem();
        });
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
        title: Text('Create Withdrawal'),
      ),
      body: Padding(
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
