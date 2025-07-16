import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/cart_item.dart';
import '../../models/shipping_option.dart';
import '../../models/user_address.dart';
import '../../services/address_service.dart';
import '../../services/order_service.dart';
import '../../services/shipping_service.dart';
import '../../services/notification_service.dart';
import '../history/history_screen.dart';
import '../address/add_edit_address_screen.dart';
import 'select_address_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartItem> selectedCartItems;
  const CheckoutScreen({super.key, required this.selectedCartItems});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late Future<List<UserAddress>> _addressesFuture;
  UserAddress? _selectedAddress;
  Future<List<ShippingOption>>? _shippingOptionsFuture;
  ShippingOption? _selectedShipping;
  bool _isPlacingOrder = false;

  @override
  void initState() {
    super.initState();
    _addressesFuture = AddressService().getAddresses();
  }

  void _fetchShippingOptions(UserAddress address) {
    if (address.cityId == 0) {
      if (mounted) {
        NotificationService.showErrorNotification(context,
            'Alamat tidak memiliki ID Kota yang valid untuk cek ongkir.');
      }
      return;
    }
    setState(() {
      _selectedShipping = null;
      _shippingOptionsFuture = ShippingService()
          .getShippingOptions(
              destinationCityId: address.cityId,
              cartItems: widget.selectedCartItems)
          .then((options) {
        if (mounted && options.isNotEmpty) {
          setState(() {
            _selectedShipping = options.first;
          });
        }
        return options;
      });
    });
  }

  void _placeOrder() async {
    if (_selectedAddress == null || _selectedShipping == null) {
      NotificationService.showInfoNotification(
          context, 'Pilih alamat dan metode pengiriman.');
      return;
    }

    final cartItemIds =
        widget.selectedCartItems.map((item) => item.id).toList();

    setState(() {
      _isPlacingOrder = true;
    });

    try {
      await OrderService().createOrder(
        addressId: _selectedAddress!.id,
        shippingCost: _selectedShipping!.price.toDouble(),
        shippingCourier: _selectedShipping!.name,
        cartItemIds: cartItemIds,
      );

      if (mounted) {
        NotificationService.showSuccessNotification(
            context, 'Pesanan berhasil dibuat!');
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HistoryScreen()),
          (route) => route.isFirst,
        );
      }
    } catch (e) {
      if (mounted) {
        NotificationService.showErrorNotification(context, e.toString());
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPlacingOrder = false;
        });
      }
    }
  }

  void _reloadAddresses() {
    setState(() {
      _addressesFuture = AddressService().getAddresses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rincian Checkout')),
      body: FutureBuilder<List<UserAddress>>(
        future: _addressesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('Gagal memuat data alamat: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyAddressState();
          }

          final addresses = snapshot.data!;
          if (_selectedAddress == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                final primaryAddress = addresses.firstWhere((a) => a.isPrimary,
                    orElse: () => addresses.first);
                if (_selectedAddress?.id != primaryAddress.id) {
                  setState(() => _selectedAddress = primaryAddress);
                  _fetchShippingOptions(primaryAddress);
                }
              }
            });
          }

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    _buildSectionTitle('Alamat Pengiriman'),
                    _buildAddressSection(addresses),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Produk Dipesan'),
                    _buildProductSection(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Pilihan Pengiriman'),
                    _buildShippingSection(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Rincian Pembayaran'),
                    _buildPaymentDetails(),
                  ],
                ),
              ),
              _buildBottomBar(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(title,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildAddressSection(List<UserAddress> addresses) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        leading: const Icon(Icons.location_on_outlined),
        title: Text(_selectedAddress?.label ?? 'Memuat alamat...',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
            _selectedAddress != null
                ? '${_selectedAddress!.recipientName}\n${_selectedAddress!.address}'
                : '...',
            style:
                TextStyle(color: Theme.of(context).textTheme.bodySmall?.color)),
        isThreeLine: true,
        trailing: TextButton(
          child: const Text('Ganti'),
          onPressed: () async {
            if (_selectedAddress == null) return;
            final newAddress = await Navigator.push<UserAddress>(
              context,
              MaterialPageRoute(
                  builder: (context) => SelectAddressScreen(
                      addresses: addresses,
                      currentAddressId: _selectedAddress!.id)),
            );
            if (newAddress != null && newAddress.id != _selectedAddress!.id) {
              setState(() => _selectedAddress = newAddress);
              _fetchShippingOptions(newAddress);
            }
          },
        ),
      ),
    );
  }

  Widget _buildProductSection() {
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: widget.selectedCartItems.map((item) {
          final priceToUse = double.tryParse(
                  item.product.discountPrice ?? item.product.price) ??
              0;
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(item.product.imageUrl,
                  width: 50, height: 50, fit: BoxFit.cover),
            ),
            title: Text(item.product.name,
                maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle:
                Text('${formatter.format(priceToUse)} x ${item.quantity}'),
            trailing: Text(formatter.format(priceToUse * item.quantity),
                style: const TextStyle(fontWeight: FontWeight.bold)),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildShippingSection() {
    if (_shippingOptionsFuture == null) {
      return const Card(
          child: ListTile(title: Text('Pilih alamat untuk melihat ongkir...')));
    }
    return FutureBuilder<List<ShippingOption>>(
      future: _shippingOptionsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator()));
        }
        if (snapshot.hasError) {
          return Card(
              child: ListTile(
                  title: Text('Gagal memuat ongkir',
                      style: TextStyle(color: Colors.red))));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Card(
              child: ListTile(
                  title: Text('Tidak ada opsi pengiriman ke alamat ini.')));
        }
        final options = snapshot.data!;
        if (_selectedShipping == null && options.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _selectedShipping = options.first);
          });
        }
        return Card(
          child: Column(
            children: options
                .map((option) => RadioListTile<ShippingOption>(
                      title: Text(option.name),
                      subtitle: Text(option.description),
                      secondary: Text(NumberFormat.currency(
                              locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
                          .format(option.price)),
                      value: option,
                      groupValue: _selectedShipping,
                      onChanged: (value) =>
                          setState(() => _selectedShipping = value),
                    ))
                .toList(),
          ),
        );
      },
    );
  }

  Widget _buildPaymentDetails() {
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    double subtotal = 0;
    double totalDiscount = 0;
    for (var item in widget.selectedCartItems) {
      final originalPrice = double.tryParse(item.product.price) ?? 0;
      final discountPrice =
          double.tryParse(item.product.discountPrice ?? item.product.price) ??
              0;
      subtotal += originalPrice * item.quantity;
      totalDiscount += (originalPrice - discountPrice) * item.quantity;
    }
    final shippingCost = _selectedShipping?.price.toDouble() ?? 0.0;
    final total = subtotal - totalDiscount + shippingCost;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoRow('Subtotal Produk', formatter.format(subtotal)),
            const SizedBox(height: 8),
            _buildInfoRow('Ongkos Kirim', formatter.format(shippingCost)),
            if (totalDiscount > 0)
              _buildInfoRow(
                  'Total Diskon', '- ${formatter.format(totalDiscount)}',
                  textColor: Colors.green),
            const Divider(height: 24),
            _buildInfoRow('Total Pembayaran', formatter.format(total),
                isTotal: true),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16)),
          onPressed: (_selectedAddress != null &&
                  _selectedShipping != null &&
                  !_isPlacingOrder)
              ? _placeOrder
              : null,
          child: _isPlacingOrder
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2))
              : const Text('Bayar Sekarang'),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value,
      {bool isTotal = false, Color? textColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
          Text(value,
              style: TextStyle(
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
                  fontSize: isTotal ? 18 : 16,
                  color: textColor)),
        ],
      ),
    );
  }

  Widget _buildEmptyAddressState() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Anda belum punya alamat tersimpan.'),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () async {
            final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddEditAddressScreen()));
            if (result == true) {
              setState(() {
                _addressesFuture = AddressService().getAddresses();
              });
            }
          },
          child: const Text('Tambah Alamat Baru'),
        ),
      ],
    ));
  }
}
