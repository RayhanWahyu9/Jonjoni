import 'package:flutter/material.dart';

class MenuDetailPage extends StatelessWidget {
  static const Color primaryOrange = Color(0xFFFFA726);
  static const Color accentYellow = Color(0xFFFFF1E0);
  static const Color priceColor = Color(0xFFEF6C00);

  final String categoryTitle;
  final List<Map<String, dynamic>> items;

  const MenuDetailPage({
    super.key,
    required this.categoryTitle,
    required this.items,
  });

  String _formatHarga(int harga) {
    return "Rp ${harga.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: accentYellow,
      appBar: AppBar(
        backgroundColor: primaryOrange,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          categoryTitle,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
     
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildMenuItemCard(context, item);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItemCard(BuildContext context, Map<String, dynamic> item) {
    return Card(
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 6,
            child: Image.asset(
              'assets/${item["gambar"]}',
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item["nama"],
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        _formatHarga(item["harga"]),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: priceColor,
                        ),
                      ),
                      CircleAvatar(
                        radius: 13,
                        backgroundColor: priceColor,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: 15,
                          icon: const Icon(Icons.add, color: Colors.white),
                          onPressed: () {
                            final snackBar = SnackBar(
                              content: Text('${item["nama"]} ditambahkan ke keranjang!'),
                              duration: const Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            );
                            ScaffoldMessenger.of(context).removeCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}