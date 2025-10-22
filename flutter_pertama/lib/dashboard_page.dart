import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'menu_detail_page.dart';
import 'models/menu_category.dart';
import 'models/menu_item.dart';
import 'models/cart_provider.dart';

class DashboardPage extends StatefulWidget {
  static const Color primaryOrange = Color(0xFFFFA726);
  static const Color accentBg = Color(0xFFF7F3EE);
  final String username;

  const DashboardPage({super.key, required this.username});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  int selectedChip = 0; // 0 = All, 1..n = categories[0..n-1]

  final List<MenuCategory> categories = [
    MenuCategory(
      name: "KOPI",
      image: "kopi.png",
      items: [
        MenuItem(nama: "Kopi Gula Aren", harga: 10000, gambar: "Kopisusu.jpeg"),
        MenuItem(nama: "Caramel Macchiato", harga: 12000, gambar: "CaramelMacchiato.jpg"),
        MenuItem(nama: "Kopi Susu Joni", harga: 10000, gambar: "KopiSusu.jpg"),
        MenuItem(nama: "Hazelnut", harga: 12000, gambar: "Hezelnut.jpg"),
        MenuItem(nama: "Butterscotch", harga: 12000, gambar: "Butterscotch.jpg"),
        MenuItem(nama: "Americano", harga: 8000, gambar: "Amerricano.jpg"),
      ],
    ),
    MenuCategory(
      name: "SUSU KOCOK",
      image: "susu_kocok.png",
      items: [
        MenuItem(nama: "Manggo Kocok", harga: 11000, gambar: "ManggoKocok.jpg"),
        MenuItem(nama: "Sakura Kocok", harga: 11000, gambar: "SakuraKocok.jpg"),
      ],
    ),
    MenuCategory(
      name: "MILK BASED",
      image: "milk_based.png",
      items: [
        MenuItem(nama: "Red Velvet", harga: 11000, gambar: "RedVelvet.jpg"),
        MenuItem(nama: "Cokelat", harga: 11000, gambar: "Cokelat.jpg"),
        MenuItem(nama: "Taro", harga: 11000, gambar: "Taro.jpg"),
        MenuItem(nama: "Matcha", harga: 12000, gambar: "Matcha.jpg"),
      ],
    ),
    MenuCategory(
      name: "HOT",
      image: "hot.png",
      items: [
        MenuItem(nama: "Ngeteh", harga: 5000, gambar: "Ngeteh.jpg"),
        MenuItem(nama: "Americano", harga: 8000, gambar: "AmerricanoPanas.jpg"),
      ],
    ),
    MenuCategory(
      name: "NON SUSU",
      image: "squash.png",
      items: [
        MenuItem(nama: "Strawberry Squash", harga: 12000, gambar: "StrawberrySquash.jpg"),
        MenuItem(nama: "Lemon Squash", harga: 12000, gambar: "LemonSquash.jpg"),
      ],
    ),
    MenuCategory(
      name: "NYEMIL",
      image: "nyemil.png",
      items: [
        MenuItem(nama: "Gethuk Goreng", harga: 12000, gambar: "GethukGoreng.jpg"),
        MenuItem(nama: "Reng Goreng", harga: 15000, gambar: "RengGoreng.jpg"),
        MenuItem(nama: "Kemrinyik", harga: 3000, gambar: "Kreminyik.jpg"),
        MenuItem(nama: "Usus", harga: 6000, gambar: "Usus.jpg"),
        MenuItem(nama: "Nyemil Hu Hah", harga: 14000, gambar: "NyemilHuHah.webp"),
      ],
    ),
  ];

  List<MenuItem> get _allItems => categories.expand((c) => c.items).toList();

  List<MenuItem> get _filtered {
    final q = _searchCtrl.text.trim().toLowerCase();

    // if selectedChip == 0 => All, otherwise selected category = categories[selectedChip - 1]
    List<MenuItem> base;
    if (selectedChip == 0) {
      base = _allItems;
    } else {
      final idx = selectedChip - 1;
      if (idx >= 0 && idx < categories.length) {
        base = categories[idx].items;
      } else {
        base = _allItems;
      }
    }

    if (q.isEmpty) return base;
    return base.where((i) => i.nama.toLowerCase().contains(q)).toList();
  }

  String _formatRp(int n) {
    final s = n.toString();
    return 'Rp ${s.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DashboardPage.accentBg,
      appBar: AppBar(
        backgroundColor: DashboardPage.primaryOrange,
        elevation: 0,
        title: Row(children: [
          const Icon(Icons.local_cafe_outlined, color: Colors.white),
          const SizedBox(width: 8),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Jonjoni Coffee', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('Halo, ${widget.username}', style: const TextStyle(fontSize: 12, color: Colors.white70)),
          ]),
        ]),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search + banner
                Row(children: [
                  Expanded(
                    child: TextField(
                      controller: _searchCtrl,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Cari kopi pilihanmu!',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                ]),
                const SizedBox(height: 14),
                // Banner: tampilkan Image langsung; jika asset tidak ada, tidak menampilkan kotak putih
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/banner.jpg',
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
                const SizedBox(height: 16),

                // Category chips (with "All" as first chip)
                SizedBox(
                  height: 72,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length + 1,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, i) {
                      // i == 0 -> "All"
                      final isAll = i == 0;
                      final label = isAll ? 'All' : categories[i - 1].name;
                      final selected = i == selectedChip;
                      return ChoiceChip(
                        label: Text(label, style: TextStyle(color: selected ? Colors.white : Colors.brown)),
                        selected: selected,
                        selectedColor: DashboardPage.primaryOrange,
                        onSelected: (_) => setState(() => selectedChip = i),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),

                // grid of items (filtered) — responsive sizes for Android & Web
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      int crossAxis = 2;
                      double childAspect = 0.85;

                      if (width >= 1200) {
                        crossAxis = 4;
                        childAspect = 0.78;
                      } else if (width >= 900) {
                        crossAxis = 3;
                        childAspect = 0.8;
                      } else if (width >= 600) {
                        crossAxis = 2;
                        childAspect = 0.9;
                      } else {
                        crossAxis = 2;
                        childAspect = 0.95;
                      }

                      return GridView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: _filtered.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxis,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: childAspect,
                        ),
                        itemBuilder: (context, idx) {
                          final item = _filtered[idx];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MenuDetailPage(
                                    categoryTitle: item.nama,
                                    items: [
                                      {"nama": item.nama, "harga": item.harga, "gambar": item.gambar}
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              clipBehavior: Clip.antiAlias,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // image area uses AspectRatio so cards look consistent across screen sizes
                                  AspectRatio(
                                    aspectRatio: 4 / 3,
                                    child: Image.asset(
                                      'assets/${item.gambar}',
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(color: Colors.grey[200]),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Text(item.nama, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                      const SizedBox(height: 6),
                                      Text(_formatRp(item.harga), style: const TextStyle(color: Color(0xFFEF6C00), fontWeight: FontWeight.bold)),
                                    ]),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: DashboardPage.primaryOrange,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Keranjang'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        onTap: (i) {
          if (i == 1) {
            Navigator.pushNamed(context, '/cart');
            return;
          }
          if (i == 2) {
            Navigator.pushNamed(context, '/history');
            return;
          }
          if (i == 3) {
            Navigator.pushNamed(context, '/profile');
            return;
          }
        },
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Keranjang')),
      body: cart.items.isEmpty
          ? const Center(child: Text('Keranjang kosong'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, i) {
                      final ci = cart.items[i];
                      return ListTile(
                        leading: CircleAvatar(backgroundImage: AssetImage('assets/${ci.item.gambar}')),
                        title: Text(ci.item.nama),
                        subtitle: Text('Rp ${ci.item.harga} x ${ci.qty}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () => cart.removeSingle(ci.item)),
                            Text('${ci.qty}'),
                            IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () => cart.addItem(ci.item)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(child: Text('Total: Rp ${cart.totalPrice}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                      ElevatedButton(
                        onPressed: () {
                          // TODO: proses checkout
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Checkout belum diimplementasikan')));
                        },
                        child: const Text('Checkout'),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}