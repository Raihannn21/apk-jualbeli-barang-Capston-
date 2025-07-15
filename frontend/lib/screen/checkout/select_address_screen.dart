// lib/screens/checkout/select_address_screen.dart
import 'package:flutter/material.dart';
import '../../models/user_address.dart';

class SelectAddressScreen extends StatefulWidget {
  final List<UserAddress> addresses;
  final int currentAddressId;

  const SelectAddressScreen(
      {super.key, required this.addresses, required this.currentAddressId});

  @override
  State<SelectAddressScreen> createState() => _SelectAddressScreenState();
}

class _SelectAddressScreenState extends State<SelectAddressScreen> {
  late int? _selectedAddressId;

  @override
  void initState() {
    super.initState();
    _selectedAddressId = widget.currentAddressId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Alamat Lain')),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: widget.addresses.length,
        itemBuilder: (context, index) {
          final address = widget.addresses[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: RadioListTile<int>(
              title: Text(address.label,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${address.recipientName}\n${address.address}'),
              isThreeLine: true,
              value: address.id,
              groupValue: _selectedAddressId,
              onChanged: (value) => setState(() => _selectedAddressId = value),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _selectedAddressId == null
              ? null
              : () {
                  final selectedAddress = widget.addresses
                      .firstWhere((a) => a.id == _selectedAddressId);
                  // Kembalikan objek UserAddress yang dipilih ke halaman sebelumnya
                  Navigator.pop(context, selectedAddress);
                },
          child: const Text('Pilih Alamat Ini'),
        ),
      ),
    );
  }
}
