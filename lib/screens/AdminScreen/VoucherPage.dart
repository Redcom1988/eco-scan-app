import 'package:flutter/material.dart';
import 'KelolaEdukasiPage.dart';
import 'PusatBantuanPage.dart';
import 'ProfileAdminPage.dart';

class VoucherPage extends StatefulWidget {
  @override
  _VoucherPageState createState() => _VoucherPageState();
}


class _VoucherPageState extends State<VoucherPage> {
  int _currentIndex = 0; // Untuk menyimpan halaman aktif
  late final List<Widget> _pages = [
  VoucherPageContent(
    vouchers: vouchers,
    onEditVoucher: _editVoucher, // Kirimkan fungsi _editVoucher ke VoucherPageContent
  ),
  KelolaEdukasiPage(),
  PusatBantuanPage(),
  ProfileAdminPage(),
];

  String _getPageTitle() {
  switch (_currentIndex) {
    case 0:
      return 'Kelola Voucher'; // Judul untuk VoucherPage
    case 1:
      return 'Kelola Edukasi'; // Judul untuk Kelola Edukasi
    case 2:
      return 'Pusat Bantuan';  // Judul untuk Pusat Bantuan
    case 3:
      return 'Profil Admin';   // Judul untuk Profil
    default:
      return 'Ecoscan Admin';  // Judul default (fallback)
  }
}

  List<Voucher> vouchers = [
    Voucher(
        value: 50000,
        points: 50000,
        merchants: ["Alfamart", "Indomaret", "Starbucks"],
        barcode: "BARCODE1"),
    Voucher(
        value: 25000,
        points: 25000,
        merchants: ["Alfamart", "Starbucks"],
        barcode: "BARCODE2"),
    Voucher(
        value: 10000,
        points: 10000,
        merchants: ["Indomaret", "KFC"],
        barcode: "BARCODE3"),
  ];

void _addVoucher() {
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _pointsController = TextEditingController();
  final TextEditingController _merchantsController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Tambah Voucher'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _valueController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Nilai Voucher (Rp)'),
            ),
            TextField(
              controller: _pointsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Jumlah Poin'),
            ),
            TextField(
              controller: _merchantsController,
              decoration: const InputDecoration(
                  labelText: 'Merchants (pisahkan dengan koma)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Tutup dialog
            },
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                vouchers.add(Voucher(
                  value: int.tryParse(_valueController.text) ?? 0,
                  points: int.tryParse(_pointsController.text) ?? 0,
                  merchants: _merchantsController.text
                      .split(',')
                      .map((e) => e.trim())
                      .toList(),
                  barcode: "BARCODE${vouchers.length + 1}",
                ));
              });
              Navigator.pop(context); // Tutup dialog setelah submit
            },
            child: const Text('Tambah'),
          ),
        ],
      );
    },
  );
}

void _editVoucher(int index) {
  final _valueController =
      TextEditingController(text: vouchers[index].value.toString());
  final _pointsController =
      TextEditingController(text: vouchers[index].points.toString());
  final _merchantsController =
      TextEditingController(text: vouchers[index].merchants.join(', '));

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Edit Voucher'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _valueController,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: 'Nilai Voucher (Rp)'),
            ),
            TextField(
              controller: _pointsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Jumlah Poin'),
            ),
            TextField(
              controller: _merchantsController,
              decoration: const InputDecoration(
                  labelText: 'Merchants (pisahkan dengan koma)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Tutup dialog
            },
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                vouchers[index] = Voucher(
                  value: int.tryParse(_valueController.text) ?? 0,
                  points: int.tryParse(_pointsController.text) ?? 0,
                  merchants: _merchantsController.text
                      .split(',')
                      .map((e) => e.trim())
                      .toList(),
                  barcode: "BARCODE${index + 1}",
                );
              });
              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                vouchers.removeAt(index); // Hapus voucher dari daftar
              });
              Navigator.pop(context);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
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
      title: Text(
        _getPageTitle(), // Menentukan judul berdasarkan halaman
        style: const TextStyle(color: Colors.black),
      ),
      backgroundColor: Colors.white, // Latar belakang putih
      elevation: 0, // Hilangkan bayangan AppBar (opsional)
      leading: const Icon(Icons.eco, color: Colors.green), // Ikon daun
      actions: [
        IconButton(
          onPressed: _addVoucher,
          icon: const Icon(Icons.add, color: Colors.black), // Warna ikon hitam
          tooltip: 'Tambah Voucher',
        ),
      ],
    ),
    body: _pages[_currentIndex], // Menampilkan halaman sesuai dengan indeks
    bottomNavigationBar: _bottomNavBar(),
  );
}


Widget _voucherCard(Voucher voucher, int index) {
  return Card(
    margin: const EdgeInsets.all(10),
    child: InkWell(
      onTap: () {
        _editVoucher(index); // Panggil dialog edit saat kartu ditekan
      },
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.card_giftcard, color: Colors.green),
            title: Text('EcoscanVoucher - Rp ${voucher.value}'),
            subtitle: Text(
                'Tukar dengan ${voucher.points} poin Ecoscan\nMerchants: ${voucher.merchants.join(', ')}'),
            trailing: const Icon(Icons.qr_code),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text('Barcode: ${voucher.barcode}'),
          ),
        ],
      ),
    ),
  );
}


    Widget _bottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex, // Indeks halaman aktif
      onTap: (index) {
        setState(() {
          _currentIndex = index; // Ubah halaman aktif
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.card_giftcard),
          label: 'Voucher',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Kelola Edukasi',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.help_outline),
          label: 'Pusat Bantuan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.black54,
    );
  }

}

class Voucher {
  final int value;
  final int points;
  final List<String> merchants;
  final String barcode;

  Voucher({
    required this.value,
    required this.points,
    required this.merchants,
    required this.barcode,
  });
}
class VoucherPageContent extends StatelessWidget {
  final List<Voucher> vouchers;
  final Function(int) onEditVoucher; // Tambahkan parameter callback

  VoucherPageContent({required this.vouchers, required this.onEditVoucher});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: vouchers.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(10),
          child: ListTile(
            leading: const Icon(Icons.card_giftcard, color: Colors.green),
            title: Text('EcoscanVoucher - Rp ${vouchers[index].value}'),
            subtitle: Text(
                'Tukar dengan ${vouchers[index].points} poin Ecoscan\nMerchants: ${vouchers[index].merchants.join(', ')}'),
            trailing: const Icon(Icons.qr_code),
            onTap: () {
              onEditVoucher(index); // Panggil callback untuk edit voucher
            },
          ),
        );
      },
    );
  }
}



