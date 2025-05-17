import 'dart:ui';

import 'package:flutter/material.dart' show Alignment, BorderRadius, BoxDecoration, BoxShadow, BuildContext, Center, CircleAvatar, CircularProgressIndicator, Colors, Column, ConnectionState, Container, CrossAxisAlignment, Dismissible, Divider, EdgeInsets, ElevatedButton, FontWeight, Icon, IconData, Icons, Key, LinearProgressIndicator, ListTile, MainAxisAlignment, Offset, Padding, Row, Scaffold, ScaffoldMessenger, SingleChildScrollView, SizedBox, SnackBar, State, StatefulWidget, StatelessWidget, StreamBuilder, Text, TextDecoration, TextStyle, VoidCallback, Widget;
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildEventsSection(),
            _buildChecklistSection(),
            _buildBudgetSection(),
            _buildRateAppSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsSection() {
  return _buildSection(
    title: 'EVENTS',
    icon: Icons.event,
    stream: _firestore.collection('events').orderBy('date').limit(3).snapshots(),
    emptyMessage: 'No upcoming events',
    itemBuilder: (context, doc) {
      final data = doc.data();
       if (data == null) {
        return const SizedBox(); // Or a placeholder
      }
      return EventListItem(
        eventData: data,
        onDelete: () => _deleteEvent(doc.id),
        docId: doc.id,
      );
    },
  );
}


  Widget _buildChecklistSection() {
    return _buildSection(
      title: 'CHECKLIST',
      icon: Icons.checklist_rtl,
      stream: _firestore.collection('checklistItems').orderBy('createdAt', descending: true).limit(3).snapshots(),
      emptyMessage: 'No tasks yet',
      itemBuilder: (context, doc) {
        final data = doc.data();
         if (data == null) {
        return const SizedBox(); // Or a placeholder
      }
        return ChecklistItemWidget(
          taskData: data,
          onDelete: () => _deleteChecklistItem(doc.id),
          docId: doc.id,
        );
      },
      showProgress: true,
    );
  }

  Widget _buildBudgetSection() {
    return _buildSection(
      title: 'BUDGET',
      icon: Icons.account_balance_wallet_outlined,
      stream: _firestore.collection('budgetItems').orderBy('createdAt', descending: true).limit(3).snapshots(),
      emptyMessage: 'No budget items yet',
      itemBuilder: (context, doc) {
        final data = doc.data();
         if (data == null) {
        return const SizedBox(); // Or a placeholder
      }
        return BudgetItemWidget(
          budgetData: data,
          onDelete: () => _deleteBudgetItem(doc.id),
          docId: doc.id,
        );
      },
      showBudget: true,
    );
  }

  Widget _buildRateAppSection() {
    return SectionContainer(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            //  Implement
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 74, 197, 239),
            foregroundColor: Colors.white,
          ),
          child: const Text('RATE THIS APP'),
        ),
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required Stream<QuerySnapshot<Map<String, dynamic>>> stream,
    required String emptyMessage,
    required Widget Function(BuildContext context, QueryDocumentSnapshot<Map<String, dynamic>> doc) itemBuilder,
    bool showProgress = false,
    bool showBudget = false,
  }) {
    return SectionContainer(
      child: Column(
        children: <Widget>[
          SectionTitleBar(icon: icon, title: title),
          const Divider(),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Error loading data'),
                );
              }
              final docs = snapshot.data?.docs ?? [];
              if (docs.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(emptyMessage),
                );
              }

              if (showBudget) {
                double totalBudget = 0;
                double totalSpent = 0;
                for (var doc in docs) {
                  final data = doc.data();
                  if(data != null){
                    totalBudget += (data['amount'] ?? 0).toDouble();
                    if (data['isPaid'] == true) {
                      totalSpent += (data['amount'] ?? 0).toDouble();
                    }
                  }
                }
                return Column(
                  children: <Widget>[
                    ...docs.map((doc) => itemBuilder(context, doc)).toList(),
                    _buildBudgetSummary(totalBudget, totalSpent),
                  ],
                );
              } else if (showProgress) {
                int completedTasks = docs.where((doc) {
                  final data = doc.data();
                  return data != null && data['isCompleted'] == true;
                }).length;
                double completionPercentage =
                    docs.isEmpty ? 0 : completedTasks / docs.length;
                return Column(
                  children: <Widget>[
                    ...docs.map((doc) => itemBuilder(context, doc)).toList(),
                    _buildProgressIndicator(
                        completionPercentage, completedTasks, docs.length),
                  ],
                );
              } else {
                return Column(
                  children: docs.map((doc) => itemBuilder(context, doc)).toList(),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetSummary(double totalBudget, double totalSpent) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Budget:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('\$${totalBudget.toStringAsFixed(2)}'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Spent:'),
              Text('\$${totalSpent.toStringAsFixed(2)}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(
      double completionPercentage, int completedTasks, int totalTasks) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          LinearProgressIndicator(value: completionPercentage),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('${(completionPercentage * 100).toInt()}% completed'),
              Text('$completedTasks out of $totalTasks'),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _deleteEvent(String eventId) async {
    try {
      await _firestore.collection('events').doc(eventId).delete();
    } catch (e) {
      _showErrorSnackBar('Failed to delete event: $e');
    }
  }

  Future<void> _deleteChecklistItem(String itemId) async {
    try {
      await _firestore.collection('checklistItems').doc(itemId).delete();
    } catch (e) {
      _showErrorSnackBar('Failed to delete checklist item: $e');
    }
  }

  Future<void> _deleteBudgetItem(String itemId) async {
    try {
      await _firestore.collection('budgetItems').doc(itemId).delete();
    } catch (e) {
      _showErrorSnackBar('Failed to delete budget item: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}

// Reusable Widgets
class SectionContainer extends StatelessWidget {
  final Widget child;
  const SectionContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}

class SectionTitleBar extends StatelessWidget {
  final IconData icon;
  final String title;
  const SectionTitleBar({Key? key, required this.icon, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon, size: 24, color: const Color.fromARGB(255, 78, 180, 244)),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class EventListItem extends StatelessWidget {
  const EventListItem({
    Key? key,
    required this.eventData,
    required this.onDelete,
    required this.docId,
  }) : super(key: key);
  final Map<String, dynamic> eventData;
  final VoidCallback onDelete;
  final String docId;
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(docId),
      onDismissed: (_) => onDelete(),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: ListTile(
        leading: const CircleAvatar(backgroundColor: Color.fromRGBO(74, 200, 238, 0.942), child: Icon(Icons.event, color: Colors.white)),
        title: Text(eventData['name'] ?? 'Untitled Event'),
        subtitle: Text('${eventData['date'] ?? 'No date'} ${eventData['time'] ?? ''}'),
        trailing: Text('\$${eventData['budget'] ?? 0}'),
      ),
    );
  }
}

class ChecklistItemWidget extends StatelessWidget {
  const ChecklistItemWidget({
    Key? key,
    required this.taskData,
    required this.onDelete,
    required this.docId,
  }) : super(key: key);
  final Map<String, dynamic> taskData;
  final VoidCallback onDelete;
  final String docId;
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(docId),
      onDismissed: (_) => onDelete(),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: taskData['isCompleted'] == true ? const Color.fromRGBO(255, 72, 207, 203) : Colors.grey,
          child: Icon(taskData['isCompleted'] == true ? Icons.check : Icons.pending, color: Colors.white),
        ),
        title: Text(
          taskData['eventName'] ?? 'Untitled Task',
          style: TextStyle(
            decoration:
                taskData['isCompleted'] == true ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(taskData['category'] ?? 'No category'),
        trailing: Text(taskData['date'] ?? 'No date'),
      ),
    );
  }
}

class BudgetItemWidget extends StatelessWidget {
  const BudgetItemWidget({
    Key? key,
    required this.budgetData,
    required this.onDelete,
    required this.docId,
  }) : super(key: key);
  final Map<String, dynamic> budgetData;
  final VoidCallback onDelete;
  final String docId;
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(docId),
      onDismissed: (_) => onDelete(),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              budgetData['isPaid'] == true ? const Color.fromARGB(255, 72, 207, 203) : Colors.grey,
          child: const Icon(
            Icons.attach_money,
            color: Colors.white,
          ),
        ),
        title: Text(budgetData['description'] ?? 'Untitled Item'),
        subtitle: Text(budgetData['category'] ?? 'No category'),
        trailing: Text('\$${budgetData['amount'] ?? 0}'),
      ),
    );
  }
}