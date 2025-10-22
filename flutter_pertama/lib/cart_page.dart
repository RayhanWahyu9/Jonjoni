import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/cart_provider.dart';
import 'models/orders_provider.dart';
import 'models/order.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  String _formatRp(int n) {
    final s = n.toString();
    return 'Rp ${s.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  Future<void> _showCheckoutDialog(BuildContext context, CartProvider cart) async {
    String name = '';
    String address = '';
    String phone = '';
    String payment = 'Cash';

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          final total = cart.totalPrice;
          final canConfirm = name.trim().isNotEmpty && address.trim().isNotEmpty && phone.trim().isNotEmpty && cart.items.isNotEmpty;

          return AlertDialog(
            title: const Text('Checkout'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(alignment: Alignment.centerLeft, child: Text('Total: ${_formatRp(total)}')),
                  const SizedBox(height: 12),
                  TextField(decoration: const InputDecoration(labelText: 'Nama'), onChanged: (v) => setState(() => name = v)),
                  const SizedBox(height: 8),
                  TextField(decoration: const InputDecoration(labelText: 'Alamat'), onChanged: (v) => setState(() => address = v)),
                  const SizedBox(height: 8),
                  TextField(decoration: const InputDecoration(labelText: 'No. Telepon'), keyboardType: TextInputType.phone, onChanged: (v) => setState(() => phone = v)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: payment,
                    items: const [
                      DropdownMenuItem(value: 'Cash', child: Text('Cash')),
                      DropdownMenuItem(value: 'OVO', child: Text('OVO')),
                      DropdownMenuItem(value: 'Dana', child: Text('Dana')),
                      DropdownMenuItem(value: 'Transfer', child: Text('Transfer')),
                    ],
                    onChanged: (v) => setState(() => payment = v ?? 'Cash'),
                    decoration: const InputDecoration(labelText: 'Metode pembayaran'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Batal')),
              ElevatedButton(
                onPressed: canConfirm
                    ? () async {
                        // buat order dari cart
                        final orderId = DateTime.now().millisecondsSinceEpoch.toString();
                        final orderItems = cart.items
                            .map((ci) => OrderItem(nama: ci.item.nama, harga: ci.item.harga, qty: ci.qty, gambar: ci.item.gambar))
                            .toList();
                        final order = Order(
                          id: orderId,
                          createdAt: DateTime.now(),
                          items: orderItems,
                          total: cart.totalPrice,
                          namaCustomer: name,
                          alamat: address,
                          phone: phone,
                          paymentMethod: payment,
                        );

                        // simpan ke history
                        await Provider.of<OrdersProvider>(context, listen: false).addOrder(order);

                        // clear cart dan tutup dialog
                        cart.clear();
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pesanan berhasil (ID: $orderId)')));
                      }
                    : null,
                child: const Text('Konfirmasi Pesanan'),
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang'),
        centerTitle: true,
        backgroundColor: const Color(0xFFFFA726),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF7F3EE),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Column(
              children: [
                // list area
                Expanded(
                  child: cart.items.isEmpty
                      ? Center(child: Text('Keranjang masih kosong', style: TextStyle(color: Colors.grey[700])))
                      : ListView.separated(
                          itemCount: cart.items.length + 1,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            if (index == cart.items.length) {
                              // "+ Tambah Menu Lain" button
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Color(0xFF8B5E34)),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    foregroundColor: const Color(0xFF6D4C41),
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('+ Tambah Menu Lain', style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              );
                            }

                            final ci = cart.items[index];
                            return Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        'assets/${ci.item.gambar}',
                                        width: 90,
                                        height: 70,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(width: 90, height: 70, color: Colors.grey[200]),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // subtitle and edit icon removed — hanya tampilkan judul
                                          Text(ci.item.nama, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 8),
                                          // harga & quantity tetap ada (baris berikut tetap seperti sebelumnya)
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(_formatRp(ci.item.harga), style: const TextStyle(color: Color(0xFF8B4513), fontWeight: FontWeight.bold)),
                                              Row(
                                                children: [
                                                  // decrement
                                                  InkWell(
                                                    onTap: () => cart.removeSingle(ci.item),
                                                    borderRadius: BorderRadius.circular(6),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(color: const Color(0xFFBDB2A7)),
                                                        borderRadius: BorderRadius.circular(6),
                                                        color: Colors.white,
                                                      ),
                                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                      child: const Icon(Icons.remove, size: 18),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text('${ci.qty}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                                  const SizedBox(width: 8),
                                                  // increment
                                                  InkWell(
                                                    onTap: () => cart.addItem(ci.item),
                                                    borderRadius: BorderRadius.circular(6),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(color: const Color(0xFFBDB2A7)),
                                                        borderRadius: BorderRadius.circular(6),
                                                        color: Colors.white,
                                                      ),
                                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                      child: const Icon(Icons.add, size: 18),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),

                // bottom summary bar
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Total Harga (${cart.totalItems} item${cart.totalItems > 1 ? 's' : ''})', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                            const SizedBox(height: 6),
                            Text(_formatRp(cart.totalPrice), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFFA726),
                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: cart.items.isEmpty ? null : () => _showCheckoutDialog(context, cart),
                        child: const Text('Pesan', style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}