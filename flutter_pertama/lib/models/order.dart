import 'dart:convert';

class OrderItem {
  final String nama;
  final int harga;
  final int qty;
  final String? gambar;

  OrderItem({required this.nama, required this.harga, required this.qty, this.gambar});

  Map<String, dynamic> toJson() => {
        'nama': nama,
        'harga': harga,
        'qty': qty,
        'gambar': gambar,
      };

  factory OrderItem.fromJson(Map<String, dynamic> j) => OrderItem(
        nama: j['nama'] as String,
        harga: j['harga'] as int,
        qty: j['qty'] as int,
        gambar: j['gambar'] as String?,
      );
}

class Order {
  final String id;
  final DateTime createdAt;
  final List<OrderItem> items;
  final int total;
  final String namaCustomer;
  final String alamat;
  final String phone;
  final String paymentMethod;

  Order({
    required this.id,
    required this.createdAt,
    required this.items,
    required this.total,
    required this.namaCustomer,
    required this.alamat,
    required this.phone,
    required this.paymentMethod,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'items': items.map((e) => e.toJson()).toList(),
        'total': total,
        'namaCustomer': namaCustomer,
        'alamat': alamat,
        'phone': phone,
        'paymentMethod': paymentMethod,
      };

  factory Order.fromJson(Map<String, dynamic> j) => Order(
        id: j['id'] as String,
        createdAt: DateTime.parse(j['createdAt'] as String),
        items: (j['items'] as List).map((e) => OrderItem.fromJson(e as Map<String, dynamic>)).toList(),
        total: j['total'] as int,
        namaCustomer: j['namaCustomer'] as String,
        alamat: j['alamat'] as String,
        phone: j['phone'] as String,
        paymentMethod: j['paymentMethod'] as String,
      );

  static List<Order> listFromJson(String jsonStr) {
    final list = json.decode(jsonStr) as List;
    return list.map((e) => Order.fromJson(e as Map<String, dynamic>)).toList();
  }

  static String listToJson(List<Order> orders) => json.encode(orders.map((o) => o.toJson()).toList());
}