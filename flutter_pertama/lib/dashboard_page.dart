// DashboardPage.dart

import 'package:flutter/material.dart';

import 'menu_detail_page.dart';
import 'models/menu_category.dart';
import 'models/menu_item.dart';

class DashboardPage extends StatelessWidget {
  static const Color primaryOrange = Color(0xFFFFA726);
  static const Color accentYellow = Color(0xFFFFF1E0);
  final String username;

  DashboardPage({super.key, required this.username});

  // OOP: List of MenuCategory (encapsulation)
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
        MenuItem(nama: "Strawberry Squash", harga: 12000, gambar: "strawberrysquash.jpg"),
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
    SpecialMenuCategory(
      name: "SPESIAL Jonjoni",
      image: "spesial.png",
      items: [
        SpecialMenuItem(nama: "Kopi Susu Joni", harga: 10000, gambar: "Kopisusu.jpeg", specialNote: "Best Seller"),
        SpecialMenuItem(nama: "Butterscotch", harga: 12000, gambar: "Butterscotch.jpg", specialNote: ""),
        SpecialMenuItem(nama: "Renggoreng", harga: 15000, gambar: "RengGoreng.jpg", specialNote: ""),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: accentYellow,
      appBar: AppBar(
        backgroundColor: primaryOrange,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Jonjoni Coffee",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
            ),
            Text(
              "Halo, $username 👋",
              style: const TextStyle(fontSize: 13, color: Colors.white70),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Pilih Kategori",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF6D4C41)),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return _buildCategoryCard(context, category);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, MenuCategory category) {
    return Card(
      elevation: 3,
      shadowColor: primaryOrange.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MenuDetailPage(
                categoryTitle: category.name,
                items: category.items.map((e) => {
                  "nama": e.nama,
                  "harga": e.harga,
                  "gambar": e.gambar,
                  if (e is SpecialMenuItem) "specialNote": e.specialNote,
                }).toList(),
              ),
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/${category.image}',
              height: 60,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.coffee, size: 60, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                category.name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5D4037),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}