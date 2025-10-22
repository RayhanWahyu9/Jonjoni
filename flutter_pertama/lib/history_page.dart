import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/orders_provider.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  String _formatRp(int n) {
    final s = n.toString();
    return 'Rp ${s.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<OrdersProvider>(context).orders;
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Pesanan'), backgroundColor: const Color(0xFFFFA726)),
      body: orders.isEmpty
          ? const Center(child: Text('Belum ada pesanan', style: TextStyle(color: Colors.grey)))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final o = orders[i];
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    title: Text('Order ${o.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${o.items.length} item · ${o.createdAt.toLocal().toString().split('.').first}\n${_formatRp(o.total)}'),
                    isThreeLine: true,
                    onTap: () {
                      // detail dialog
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('Detail Order ${o.id}'),
                          content: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Nama: ${o.namaCustomer}'),
                                Text('No: ${o.phone}'),
                                Text('Alamat: ${o.alamat}'),
                                Text('Metode: ${o.paymentMethod}'),
                                const SizedBox(height: 8),
                                const Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 6),
                                ...o.items.map((it) => ListTile(
                                      leading: it.gambar != null ? Image.asset('assets/${it.gambar}', width: 40, height: 40, fit: BoxFit.cover, errorBuilder: (_,__,___)=>const SizedBox()) : null,
                                      title: Text(it.nama),
                                      trailing: Text('${it.qty} x ${_formatRp(it.harga)}'),
                                    )),
                                const SizedBox(height: 8),
                                Text('Total: ${_formatRp(o.total)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Tutup')),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}