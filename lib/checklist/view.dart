import 'package:flutter/material.dart';
import 'package:event_planner/checklist/create.dart';

class ChecklistPage extends StatefulWidget {
  const ChecklistPage({super.key});

  @override
  State<ChecklistPage> createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  List<Map<String, String>> checklistItems = [];

  void _navigateToCreatePage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChecklistCreatePage()),
    );

    if (result != null && result is Map<String, String>) {
      setState(() {
        checklistItems.add(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: ListView.builder(
        itemCount: checklistItems.length,
        itemBuilder: (context, index) {
          final item = checklistItems[index];
          return ListTile(
            title: Text(item['eventName'] ?? ''),
            subtitle: Text(item['note'] ?? ''),
            trailing: Text(item['date'] ?? ''),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreatePage,
        child: const Icon(Icons.add),
      ),
    );
  }
}
