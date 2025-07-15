import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/cart_item.dart';
import '../../services/cart_service.dart';
import '../../services/notification_service.dart'; // <-- IMPORT BARU
import '../checkout/checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _cartService = CartService();
  List<CartItem>? _cartItems;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshCart();
  }

  Future<void> _refreshCart() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });
    try {
      final items = await _cartService.getCart();
      if (mounted) {
        setState(() {
          _cartItems = items;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        NotificationService.showErrorNotification(
            context, e.toString()); // Ganti di sini
      }
    }
  }

  void _updateQuantity(CartItem item, int newQuantity) async {
    if (newQuantity < 1) {
      _showDeleteConfirmation(item.id, item);
      return;
    }
    int originalQuantity = item.quantity;
    setState(() => item.quantity = newQuantity);
    try {
      await _cartService.updateItemQuantity(item.id, newQuantity);
    } catch (e) {
      setState(() => item.quantity = originalQuantity);
      if (mounted)
        NotificationService.showErrorNotification(
            context, e.toString()); // Ganti di sini
    }
  }

  void _deleteItem(int cartItemId) async {
    final originalItems = List<CartItem>.from(_cartItems ?? []);
    setState(() => _cartItems?.removeWhere((item) => item.id == cartItemId));
    try {
      await _cartService.deleteItem(cartItemId);
      if (mounted)
        NotificationService.showSuccessNotification(
            context, 'Item dihapus dari keranjang'); // Ganti di sini
    } catch (e) {
      setState(() => _cartItems = originalItems);
      if (mounted)
        NotificationService.showErrorNotification(
            context, e.toString()); // Ganti di sini
    }
  }

  void _showDeleteConfirmation(int cartItemId, CartItem item) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Hapus Item'),
            content: const Text(
                'Anda yakin ingin menghapus item ini dari keranjang?'),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Batal')),
              TextButton(
                child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                onPressed: () {
                  Navigator.of(context).pop();
                  _deleteItem(cartItemId);
                },
              ),
            ],
          );
        });
  }

  double _calculateSelectedTotalPrice() {
    if (_cartItems == null) return 0;
    double totalPrice = 0;
    for (var item in _cartItems!.where((item) => item.isSelected)) {
      final priceToUse =
          double.tryParse(item.product.discountPrice ?? item.product.price) ??
              0;
      totalPrice += priceToUse * item.quantity;
    }
    return totalPrice;
  }

  void _handleCheckout() {
    if (_cartItems == null) return;
    final selectedItems = _cartItems!.where((item) => item.isSelected).toList();
    if (selectedItems.isEmpty) {
      NotificationService.showInfoNotification(context,
          'Pilih setidaknya satu item untuk checkout.'); // Ganti di sini juga
      return;
    }
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                CheckoutScreen(selectedCartItems: selectedItems)));
  }

  void _handleDeleteSelected() {
    if (_cartItems == null) return;
    final selectedIds = _cartItems!
        .where((item) => item.isSelected)
        .map((item) => item.id)
        .toList();
    if (selectedIds.isEmpty) {
      NotificationService.showInfoNotification(
          context, 'Pilih item yang ingin dihapus.'); // Ganti di sini
      return;
    }

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Hapus ${selectedIds.length} Item?'),
              content: const Text(
                  'Anda yakin ingin menghapus semua item yang dipilih?'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Batal')),
                TextButton(
                  child:
                      const Text('Hapus', style: TextStyle(color: Colors.red)),
                  onPressed: () {
                    Navigator.of(context).pop();
                    for (var id in selectedIds) {
                      _deleteItem(id);
                    }
                  },
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    bool areAllItemsSelected = _cartItems?.isNotEmpty == true &&
        _cartItems!.every((item) => item.isSelected);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Saya'),
        actions: [
          IconButton(
              tooltip: 'Hapus item yang dipilih',
              onPressed: _handleDeleteSelected,
              icon: const Icon(Icons.delete_outline))
        ],
      ),
      bottomNavigationBar: _cartItems != null && _cartItems!.isNotEmpty
          ? _buildBottomBar(areAllItemsSelected)
          : null,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _cartItems == null || _cartItems!.isEmpty
              ? const Center(child: Text('Keranjang Anda kosong.'))
              : RefreshIndicator(
                  onRefresh: _refreshCart,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _cartItems!.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1, color: Colors.transparent),
                    itemBuilder: (context, index) {
                      final item = _cartItems![index];
                      return _buildCartItemRow(item);
                    },
                  ),
                ),
    );
  }

  Widget _buildCartItemRow(CartItem item) {
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final hasDiscount = item.product.discountPrice != null &&
        item.product.discountPrice != item.product.price;
    final priceToUse =
        double.tryParse(item.product.discountPrice ?? item.product.price) ?? 0;
    final originalPrice = double.tryParse(item.product.price) ?? 0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: item.isSelected,
          onChanged: (value) =>
              setState(() => item.isSelected = value ?? false),
          activeColor: Theme.of(context).primaryColor,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(item.product.imageUrl,
              width: 80, height: 80, fit: BoxFit.cover),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(formatter.format(priceToUse),
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16)),
              if (hasDiscount)
                Text(formatter.format(originalPrice),
                    style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                        fontSize: 12)),
              const SizedBox(height: 8),
              Container(
                height: 32,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        icon: const Icon(Icons.remove, size: 16),
                        onPressed: () =>
                            _updateQuantity(item, item.quantity - 1),
                        splashRadius: 20,
                        constraints: const BoxConstraints()),
                    Text(item.quantity.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    IconButton(
                        icon: const Icon(Icons.add, size: 16),
                        onPressed: () =>
                            _updateQuantity(item, item.quantity + 1),
                        splashRadius: 20,
                        constraints: const BoxConstraints()),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(bool areAllItemsSelected) {
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final selectedItemsCount =
        _cartItems?.where((item) => item.isSelected).length ?? 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 10)
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {},
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                children: [
                  Icon(Icons.sell_outlined, color: Colors.grey.shade600),
                  const SizedBox(width: 12),
                  const Text('Gunakan Voucher'),
                  const Spacer(),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              children: [
                Checkbox(
                  value: areAllItemsSelected,
                  onChanged: (value) => setState(() => _cartItems
                      ?.forEach((item) => item.isSelected = value ?? false)),
                ),
                const Text('Semua'),
                const Expanded(child: SizedBox()),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Total Harga:'),
                    Text(
                      formatter.format(_calculateSelectedTotalPrice()),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: selectedItemsCount > 0 ? _handleCheckout : null,
                  child: Text('Checkout ($selectedItemsCount)'),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
