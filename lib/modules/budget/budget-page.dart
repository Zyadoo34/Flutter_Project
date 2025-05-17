import 'package:flutter/material.dart';

class SelectCategoryPage extends StatelessWidget {
  const SelectCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Category'),
      ),
      body: ListView(
        children: [
          _buildCategoryItem(context, 'Attire & Accessories', Icons.checkroom),
          _buildCategoryItem(context, 'Venue', Icons.location_city),
          _buildCategoryItem(context, 'Catering', Icons.restaurant),
          _buildCategoryItem(context, 'Photography', Icons.camera_alt),
          _buildCategoryItem(context, 'Entertainment', Icons.music_note),
          _buildCategoryItem(context, 'Decorations', Icons.celebration),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, String name, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      title: Text(name),
      onTap: () => Navigator.pop(context, [name, icon]),
    );
  }
}