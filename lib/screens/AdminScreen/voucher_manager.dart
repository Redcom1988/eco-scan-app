import 'package:ecoscan/backend-client/voucher_manager_handler.dart';
import 'package:flutter/material.dart';

class VoucherPage extends StatefulWidget {
  @override
  VoucherPageState createState() => VoucherPageState();
}

class VoucherPageState extends State<VoucherPage> {
  bool _isLoading = true;
  List<Map<String, dynamic>> vouchers = [];

  @override
  void initState() {
    super.initState();
    _loadVouchers();
  }

  Future<void> _loadVouchers() async {
    setState(() => _isLoading = true);
    final fetchedVouchers = await fetchVouchers();
    if (fetchedVouchers != null) {
      if (!mounted) return;
      setState(() {
        vouchers = fetchedVouchers;
        _isLoading = false;
      });
    } else {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load vouchers')),
      );
    }
  }

  void _addVoucher() {
    final TextEditingController _codeController = TextEditingController();
    final TextEditingController _priceController = TextEditingController();
    final TextEditingController _descController = TextEditingController();
    final TextEditingController _expiryController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tambah Voucher'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _codeController,
                decoration: const InputDecoration(labelText: 'Kode Voucher'),
              ),
              TextField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Harga Voucher'),
              ),
              TextField(
                controller: _descController,
                keyboardType: TextInputType.text,
                decoration:
                    const InputDecoration(labelText: 'Deskripsi Voucher'),
              ),
              TextField(
                controller: _expiryController,
                decoration: const InputDecoration(
                    labelText: 'Tanggal Kadaluarsa (YYYY-MM-DD)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                final success = await addVoucher(
                  voucherCode: _codeController.text,
                  voucherPrice: int.tryParse(_priceController.text) ?? 0,
                  voucherDesc: _descController.text,
                  expiryDate: _expiryController.text,
                  isActive: true,
                );

                if (success) {
                  _loadVouchers();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Voucher berhasil ditambahkan')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Gagal menambahkan voucher')),
                  );
                }
              },
              child: const Text('Tambah'),
            ),
          ],
        );
      },
    );
  }

  void _editVoucher(Map<String, dynamic> voucher) {
    final _codeController = TextEditingController(text: voucher['voucherCode']);
    final _priceController =
        TextEditingController(text: voucher['voucherPrice'].toString());
    final _descController = TextEditingController(text: voucher['voucherDesc']);
    final _expiryController =
        TextEditingController(text: voucher['expiryDate']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Voucher'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _codeController,
                decoration: const InputDecoration(labelText: 'Kode Voucher'),
              ),
              TextField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Harga Voucher'),
              ),
              TextField(
                controller: _descController,
                keyboardType: TextInputType.text,
                decoration:
                    const InputDecoration(labelText: 'Deskripsi Voucher'),
              ),
              TextField(
                controller: _expiryController,
                decoration: const InputDecoration(
                    labelText: 'Tanggal Kadaluarsa (YYYY-MM-DD)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                final success = await editVoucher(
                  voucherId: voucher['voucherId'].toString(),
                  voucherCode: _codeController.text,
                  voucherPrice: int.tryParse(_priceController.text) ?? 0,
                  voucherDesc: _descController.text,
                  expiryDate: _expiryController.text,
                  isActive: voucher['isActive'],
                );

                if (success) {
                  _loadVouchers();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Voucher berhasil diperbarui')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Gagal memperbarui voucher')),
                  );
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kelola Voucher',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.card_giftcard, color: Colors.green),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: vouchers.length + 1,
              itemBuilder: (context, index) {
                if (index == vouchers.length) {
                  return const SizedBox(height: 60);
                }
                final voucher = vouchers[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading:
                        const Icon(Icons.card_giftcard, color: Colors.green),
                    title: Text('${voucher['voucherCode']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Harga: ${voucher['voucherPrice']} poin'),
                        Text('Kadaluarsa: ${voucher['expiryDate']}'),
                        Text('Deskripsi: ${voucher['voucherDesc']}'),
                        Text(
                            'Status: ${voucher['isActive'] ? 'Aktif' : 'Nonaktif'}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editVoucher(voucher),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addVoucher,
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}
