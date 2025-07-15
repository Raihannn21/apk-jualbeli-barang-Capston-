import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../models/user_address.dart';
import '../../services/address_service.dart';
import 'add_edit_address_screen.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});
  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  late Future<List<UserAddress>> _addressesFuture;
  final AddressService _addressService = AddressService();

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  void _loadAddresses() {
    setState(() {
      _addressesFuture = _addressService.getAddresses();
    });
  }

  void _handleDeleteAddress(int addressId) async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Alamat?'),
        content: const Text(
            'Anda yakin ingin menghapus alamat ini secara permanen?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      try {
        await _addressService.deleteAddress(addressId);
        _loadAddresses(); // Refresh list setelah berhasil hapus
      } catch (e) {
        if (mounted)
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(e.toString().replaceAll('Exception: ', '')),
              backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alamat Saya'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddEditAddressScreen()));
          if (result == true) {
            _loadAddresses();
          }
        },
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadAddresses(),
        child: FutureBuilder<List<UserAddress>>(
          future: _addressesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                  child: Text('Anda belum punya alamat tersimpan.'));
            }

            final addresses = snapshot.data!;
            return AnimationLimiter(
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: addresses.length,
                itemBuilder: (context, index) {
                  final address = addresses[index];
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: _buildAddressCard(address),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAddressCard(UserAddress address) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on_outlined,
                    color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(address.label,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                if (address.isPrimary) ...[
                  const SizedBox(width: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text('Utama',
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit_outlined,
                      size: 20, color: Colors.blue),
                  onPressed: () async {
                    final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AddEditAddressScreen(address: address),
                        ));
                    if (result == true) {
                      _loadAddresses();
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline,
                      size: 20, color: Colors.red),
                  onPressed: () => _handleDeleteAddress(address.id),
                ),
              ],
            ),
            const Divider(height: 24),
            Text(address.recipientName,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            Text(address.phoneNumber),
            const SizedBox(height: 4),
            Text(
                '${address.address}, ${address.city}, ${address.province}, ${address.postalCode}'),
          ],
        ),
      ),
    );
  }
}
