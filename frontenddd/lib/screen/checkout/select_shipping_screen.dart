
import 'package:flutter/material.dart';
import 'order_summary_screen.dart';


class ShippingOption {
  final String id;
  final String name;
  final String description;
  final double price;

  ShippingOption(
      {required this.id,
      required this.name,
      required this.description,
      required this.price});
}

class SelectShippingScreen extends StatefulWidget {
  final int addressId;
  const SelectShippingScreen({super.key, required this.addressId});

  @override
  State<SelectShippingScreen> createState() => _SelectShippingScreenState();
}

class _SelectShippingScreenState extends State<SelectShippingScreen> {
  final List<ShippingOption> _shippingOptions = [
    ShippingOption(
        id: 'jne_reg',
        name: 'JNE REG',
        description: 'Estimasi 2-3 hari',
        price: 15000),
    ShippingOption(
        id: 'jnt_exp',
        name: 'J&T Express',
        description: 'Estimasi 1-2 hari',
        price: 18000),
    ShippingOption(
        id: 'sicepat_best',
        name: 'SiCepat BEST',
        description: 'Estimasi 1 hari sampai',
        price: 25000),
  ];

  ShippingOption? _selectedOption;

  @override
  void initState() {
    super.initState();
    if (_shippingOptions.isNotEmpty) {
      _selectedOption = _shippingOptions[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Metode Pengiriman'),
      ),
      body: ListView.builder(
        itemCount: _shippingOptions.length,
        itemBuilder: (context, index) {
          final option = _shippingOptions[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: RadioListTile<ShippingOption>(
              title: Text(option.name,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(option.description),
              secondary: Text('Rp ${option.price.toStringAsFixed(0)}'),
              value: option,
              groupValue: _selectedOption,
              onChanged: (ShippingOption? value) {
                setState(() {
                  _selectedOption = value;
                });
              },
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _selectedOption == null
              ? null
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderSummaryScreen(
                        addressId: widget.addressId,
                        shippingOption: _selectedOption!,
                      ),
                    ),
                  );
                },
          child: const Text('Lanjutkan ke Ringkasan'),
        ),
      ),
    );
  }
}
