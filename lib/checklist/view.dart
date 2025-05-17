import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'create.dart';

class ChecklistPage extends StatefulWidget {
  const ChecklistPage({super.key});

  @override
  State<ChecklistPage> createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checklist'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('checklistItems')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;

              return CheckboxListTile(
                title: Text(data['eventName'] ?? ''),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (data['note'] != null) Text(data['note']),
                    if (data['date'] != null) Text(data['date']),
                  ],
                ),
                secondary: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteItem(doc.id),
                ),
                value: data['isCompleted'] ?? false,
                onChanged: (value) => _toggleComplete(doc.id, value!),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreatePage,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _toggleComplete(String docId, bool value) async {
    await FirebaseFirestore.instance
        .collection('checklistItems')
        .doc(docId)
        .update({'isCompleted': value});
  }

  Future<void> _deleteItem(String id) async {
    await FirebaseFirestore.instance
        .collection('checklistItems')
        .doc(id)
        .delete();
  }

  void _navigateToCreatePage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChecklistCreatePage()),
    );
    setState(() {}); // Refresh after returning
  }
}