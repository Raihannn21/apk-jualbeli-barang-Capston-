import 'package:flutter/material.dart';
import '../../models/cart_item.dart';
import '../../models/user_address.dart';
import '../../services/address_service.dart';
import '../../services/cart_service.dart';
import '../../services/order_service.dart';
import '../history/history_screen.dart';
import 'select_shipping_screen.dart';

class OrderSummaryScreen extends StatefulWidget {
  final int addressId;
  final ShippingOption shippingOption;

  const OrderSummaryScreen({
    super.key,
    required this.addressId,
    required this.shippingOption,
  });

  @override
  State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  late Future<Map<String, dynamic>> _summaryFuture;
  bool _isPlacingOrder = false;

  @override
  void initState() {
    super.initState();
    _summaryFuture = _getSummaryData();
  }

  Future<Map<String, dynamic>> _getSummaryData() async {
    final results = await Future.wait([
      AddressService().getAddressById(widget.addressId),
      CartService().getCart(),
    ]);
    return {
      'address': results[0] as UserAddress,
      'cartItems': results[1] as List<CartItem>,
    };
  }

  void _placeOrder(UserAddress address, List<CartItem> cartItems) async {
    setState(() {
      _isPlacingOrder = true;
    });
    try {
      await OrderService().createOrder(
        addressId: address.id,
        shippingCost: widget.shippingOption.price,
        shippingCourier: widget.shippingOption.name,
        cartItemIds: [],
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Pesanan berhasil dibuat!'),
            backgroundColor: Colors.green));
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HistoryScreen()),
          (route) => route.isFirst,
        );
      }
    } catch (e) {
    } finally {
      if (mounted)
        setState(() {
          _isPlacingOrder = false;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Konfirmasi Pesanan')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _summaryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Gagal memuat ringkasan.'));
          }

          final UserAddress address = snapshot.data!['address'];
          final List<CartItem> cartItems = snapshot.data!['cartItems'];

          double subtotal = 0;
          for (var item in cartItems) {
            subtotal +=
                (double.tryParse(item.product.price) ?? 0) * item.quantity;
          }
          final double total = subtotal + widget.shippingOption.price;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const Text('Alamat Pengiriman',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Card(
                child: ListTile(
                  title: Text(address.recipientName),
                  subtitle: Text('${address.address}, ${address.city}'),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Metode Pengiriman',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Card(
                child: ListTile(
                  title: Text(widget.shippingOption.name),
                  subtitle: Text(widget.shippingOption.description),
                  trailing: Text(
                      'Rp ${widget.shippingOption.price.toStringAsFixed(0)}'),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Rincian Produk',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ...cartItems.map((item) => ListTile(
                    title: Text(item.product.name),
                    subtitle: Text('x${item.quantity}'),
                    trailing: Text(
                        'Rp ${(double.tryParse(item.product.price) ?? 0) * item.quantity}'),
                  )),
              const Divider(height: 32),
              const Text('Rincian Pembayaran',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ListTile(
                  title: const Text('Subtotal Produk'),
                  trailing: Text('Rp ${subtotal.toStringAsFixed(0)}')),
              ListTile(
                  title: const Text('Ongkos Kirim'),
                  trailing: Text(
                      'Rp ${widget.shippingOption.price.toStringAsFixed(0)}')),
              ListTile(
                title: const Text('Total Pembayaran',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                trailing: Text('Rp ${total.toStringAsFixed(0)}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Theme.of(context).primaryColor)),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _isPlacingOrder
              ? null
              : () {
                  // ignore: unnecessary_null_comparison
                  if (_summaryFuture.then((data) => data.isNotEmpty) != null) {
                    _summaryFuture.then((data) {
                      final UserAddress address = data['address'];
                      final List<CartItem> cartItems = data['cartItems'];
                      _placeOrder(address, cartItems);
                    });
                  }
                },
          child: _isPlacingOrder
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('Buat Pesanan & Bayar'),
        ),
      ),
    );
  }
}
