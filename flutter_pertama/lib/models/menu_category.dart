// models/menu_category.dart
import 'menu_item.dart';

class MenuCategory {
  final String name;
  final List<MenuItem> items;
  final String image;

  MenuCategory({required this.name, required this.items, required this.image});
}

// Example: Inheritance for special category
class SpecialMenuCategory extends MenuCategory {
  SpecialMenuCategory({required String name, required List<MenuItem> items, required String image})
      : super(name: name, items: items, image: image);
}
