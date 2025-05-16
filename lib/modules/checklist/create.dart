import 'package:flutter/material.dart';

class ChecklistCreatePage extends StatefulWidget {
  const ChecklistCreatePage({super.key});

  @override
  State<ChecklistCreatePage> createState() => _ChecklistCreatePageState();
}

class _ChecklistCreatePageState extends State<ChecklistCreatePage> {
  final _eventNameController = TextEditingController();
  final _noteController = TextEditingController();
  final _categoryController = TextEditingController();
  DateTime? _selectedDate;

  void _submitForm() {
    if (_eventNameController.text.isNotEmpty) {
      Navigator.pop(context, {
        'eventName': _eventNameController.text,
        'note': _noteController.text,
        'category': _categoryController.text,
        'date': _selectedDate?.toIso8601String().split('T').first ?? '',
      });
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Checklist Item')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _eventNameController,
              decoration: const InputDecoration(labelText: 'Event Name'),
            ),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(labelText: 'Note'),
            ),
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedDate == null
                        ? 'No date chosen'
                        : 'Date: ${_selectedDate!.toLocal()}'.split(' ')[0],
                  ),
                ),
                TextButton(
                  onPressed: _pickDate,
                  child: const Text('Pick Date'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _submitForm, child: const Text('Create')),
          ],
        ),
      ),
    );
  }
}
