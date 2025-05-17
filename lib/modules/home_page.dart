import 'package:flutter/material.dart';
import '../shared/styles/colors.dart';
import '../shared/styles/styles.dart';
import 'budget/create_budget_page.dart';
import 'events/events_page.dart';
import 'budget/budget-page.dart'; // Make sure this file exists
import '../checklist/view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(AppStyles.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
    return Container(
      margin: const EdgeInsets.only(bottom: AppStyles.defaultPadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppStyles.borderRadius),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppStyles.defaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.event, size: AppStyles.smallIconSize, color: AppColors.text),
                    const SizedBox(width: AppStyles.smallPadding),
                    Text('EVENTS', style: AppStyles.titleStyle),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EventsPage()),
                    );
                  },
                  child: Text('View All >', style: AppStyles.subtitleStyle),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.grey),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('events')
                .orderBy('date')
                .limit(3)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text('Error loading events: ${snapshot.error}'),
                );
              }

              final docs = snapshot.data?.docs ?? [];

              if (docs.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Image.asset('images/event-list.png', height: 75),
                      const SizedBox(height: AppStyles.defaultPadding),
                      Text('No upcoming events', style: AppStyles.subtitleStyle),
                    ],
                  ),
                );
              }

              return Column(
                children: docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return Column(
                    children: [
                      Dismissible(
                        key: Key(doc.id),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Delete Event'),
                                content: const Text(
                                  'Are you sure you want to delete this event?'
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: const Text('CANCEL'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(true),
                                    child: const Text(
                                      'DELETE',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        onDismissed: (direction) async {
                          try {
                            await FirebaseFirestore.instance
                                .collection('events')
                                .doc(doc.id)
                                .delete();
                            
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Event deleted successfully'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error deleting event: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: AppColors.primary,
                            child: Icon(Icons.event, color: AppColors.white),
                          ),
                          title: Text(data['name'] ?? 'Untitled Event', style: AppStyles.titleStyle),
                          subtitle: Text(
                            '${data['date'] ?? 'No date'} ${data['time'] ?? ''}',
                            style: AppStyles.subtitleStyle,
                          ),
                          trailing: Text(
                            '\$${data['budget'] ?? 0}',
                            style: AppStyles.subtitleStyle.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      if (doc != docs.last) const Divider(height: 1, color: AppColors.grey),
                    ],
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: AppStyles.defaultPadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppStyles.borderRadius),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppStyles.defaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.checklist_rtl, size: AppStyles.smallIconSize, color: AppColors.text),
                    const SizedBox(width: AppStyles.smallPadding),
                    Text('CHECKLIST', style: AppStyles.titleStyle),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ChecklistPage()),
                    );
                  },
                  child: Text('View All >', style: AppStyles.subtitleStyle),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.grey),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('checklistItems')
                .orderBy('createdAt', descending: true)
                .limit(3)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text('Error loading checklist: ${snapshot.error}'),
                );
              }

              final docs = snapshot.data?.docs ?? [];

              if (docs.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Image.asset('images/checklist.png', height: 75),
                      const SizedBox(height: AppStyles.defaultPadding),
                      Text('No tasks yet', style: AppStyles.subtitleStyle),
                    ],
                  ),
                );
              }

              // Calculate completion percentage
              int completedTasks = docs.where((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return data['isCompleted'] == true;
              }).length;
              double completionPercentage = docs.isEmpty ? 0 : completedTasks / docs.length;

              return Column(
                children: [
                  Column(
                    children: docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return Column(
                        children: [
                          Dismissible(
                            key: Key(doc.id),
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            direction: DismissDirection.endToStart,
                            confirmDismiss: (direction) async {
                              return await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Delete Task'),
                                    content: const Text(
                                      'Are you sure you want to delete this task?'
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(false),
                                        child: const Text('CANCEL'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(true),
                                        child: const Text(
                                          'DELETE',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            onDismissed: (direction) async {
                              try {
                                await FirebaseFirestore.instance
                                    .collection('checklistItems')
                                    .doc(doc.id)
                                    .delete();
                                
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Task deleted successfully'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error deleting task: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: data['isCompleted'] == true 
                                    ? AppColors.primary 
                                    : AppColors.grey,
                                child: Icon(
                                  data['isCompleted'] == true 
                                      ? Icons.check 
                                      : Icons.pending,
                                  color: AppColors.white,
                                ),
                              ),
                              title: Text(
                                data['eventName'] ?? 'Untitled Task',
                                style: AppStyles.titleStyle.copyWith(
                                  decoration: data['isCompleted'] == true
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                              subtitle: Text(
                                data['category'] ?? 'No category',
                                style: AppStyles.subtitleStyle,
                              ),
                              trailing: Text(
                                data['date'] ?? 'No date',
                                style: AppStyles.subtitleStyle.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                          if (doc != docs.last) const Divider(height: 1, color: AppColors.grey),
                        ],
                      );
                    }).toList(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppStyles.defaultPadding),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: completionPercentage,
                            backgroundColor: AppColors.grey,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                            minHeight: 8,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${(completionPercentage * 100).toInt()}% completed',
                              style: AppStyles.subtitleStyle,
                            ),
                            Text(
                              '$completedTasks out of ${docs.length}',
                              style: AppStyles.subtitleStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: AppStyles.defaultPadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppStyles.borderRadius),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppStyles.defaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.account_balance_wallet_outlined, size: AppStyles.smallIconSize, color: AppColors.text),
                    const SizedBox(width: AppStyles.smallPadding),
                    Text('BUDGET', style: AppStyles.titleStyle),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddCostScreen()),
                    );
                  },
                  child: Text('View All >', style: AppStyles.subtitleStyle),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.grey),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('budgetItems')
                .orderBy('createdAt', descending: true)
                .limit(3)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text('Error loading budget items: ${snapshot.error}'),
                );
              }

              final docs = snapshot.data?.docs ?? [];

              if (docs.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.account_balance_wallet_outlined,
                        size: 75,
                        color: AppColors.grey,
                      ),
                      const SizedBox(height: AppStyles.defaultPadding),
                      Text('No budget items yet', style: AppStyles.subtitleStyle),
                    ],
                  ),
                );
              }

              double totalBudget = 0;
              double totalSpent = 0;

              for (var doc in docs) {
                final data = doc.data() as Map<String, dynamic>;
                totalBudget += (data['amount'] ?? 0).toDouble();
                if (data['isPaid'] == true) {
                  totalSpent += (data['amount'] ?? 0).toDouble();
                }
              }

              return Column(
                children: [
                  Column(
                    children: docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return Column(
                        children: [
                          Dismissible(
                            key: Key(doc.id),
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            direction: DismissDirection.endToStart,
                            confirmDismiss: (direction) async {
                              return await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Delete Budget Item'),
                                    content: const Text(
                                      'Are you sure you want to delete this budget item?'
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(false),
                                        child: const Text('CANCEL'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(true),
                                        child: const Text(
                                          'DELETE',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            onDismissed: (direction) async {
                              try {
                                await FirebaseFirestore.instance
                                    .collection('budgetItems')
                                    .doc(doc.id)
                                    .delete();
                                
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Budget item deleted successfully'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error deleting budget item: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: data['isPaid'] == true 
                                    ? AppColors.primary 
                                    : AppColors.grey,
                                child: Icon(
                                  Icons.attach_money,
                                  color: AppColors.white,
                                ),
                              ),
                              title: Text(
                                data['description'] ?? 'Untitled Item',
                                style: AppStyles.titleStyle,
                              ),
                              subtitle: Text(
                                data['category'] ?? 'No category',
                                style: AppStyles.subtitleStyle,
                              ),
                              trailing: Text(
                                '\$${data['amount'] ?? 0}',
                                style: AppStyles.subtitleStyle.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          if (doc != docs.last) const Divider(height: 1, color: AppColors.grey),
                        ],
                      );
                    }).toList(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppStyles.defaultPadding),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total Budget:', style: AppStyles.titleStyle),
                            Text(
                              '\$${totalBudget.toStringAsFixed(2)}',
                              style: AppStyles.titleStyle.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Spent:', style: AppStyles.subtitleStyle),
                            Text(
                              '\$${totalSpent.toStringAsFixed(2)}',
                              style: AppStyles.subtitleStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRateAppSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: AppStyles.defaultPadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppStyles.borderRadius),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppStyles.defaultPadding),
            child: Row(
              children: [
                Icon(Icons.announcement_outlined, size: AppStyles.smallIconSize, color: AppColors.grey),
                const SizedBox(width: AppStyles.smallPadding),
                Expanded(
                  child: Text(
                    'Please take a moment to rate this app or share your feedback with us',
                    style: AppStyles.subtitleStyle,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppStyles.defaultPadding,
              vertical: AppStyles.smallPadding,
            ),
            child: ElevatedButton(
              onPressed: () {
                // Implement rating functionality
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: AppStyles.defaultPadding),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppStyles.smallBorderRadius),
                ),
              ),
              child: const Text('RATE THIS APP', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
            ),
          ),
          const SizedBox(height: AppStyles.smallPadding),
        ],
      ),
    );
  }
}