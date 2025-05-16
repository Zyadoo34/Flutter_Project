import 'package:flutter/material.dart';
import '../category/category-page.dart';

class AddCostScreen extends StatefulWidget {
  const AddCostScreen({super.key});

  @override
  _AddCostScreenState createState() => _AddCostScreenState();
}

class _AddCostScreenState extends State<AddCostScreen> {
  String? selectedCategory ='Nothing';
  final TextEditingController nameController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a new cost'),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: noteController,
              decoration: InputDecoration(labelText: 'Note'),
            ),
            ListTile(
              leading: Icon(Icons.checkroom),
              title: Text('Category'),
              subtitle: Text(selectedCategory ?? ''),
              onTap: () async {
                final result = await Navigator.push<String>(
                  context,
                  MaterialPageRoute(builder: (_) => SelectCategoryPage()),
                );
                if (result != null) {
                  setState(() {
                    selectedCategory = result;
                  });
                }
              },
            ),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Amount'),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                child: Text('ADD'),
                onPressed: () {
                  print("Name: ${nameController.text}");
                  print("Note: ${noteController.text}");
                  print("Category: $selectedCategory");
                  print("Amount: ${amountController.text}");
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
