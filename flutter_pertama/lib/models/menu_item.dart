// models/menu_item.dart

class MenuItem {
  final String nama;
  final int harga;
  final String gambar;

  MenuItem({required this.nama, required this.harga, required this.gambar});

  String get displayPrice => 'Rp ${harga.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
}

// Inheritance: SpecialMenuItem
class SpecialMenuItem extends MenuItem {
  final String specialNote;
  SpecialMenuItem({
    required String nama,
    required int harga,
    required String gambar,
    required this.specialNote,
  }) : super(nama: nama, harga: harga, gambar: gambar);
}

// Polymorphism: All menu items can be treated as MenuItem, but SpecialMenuItem has extra info.
