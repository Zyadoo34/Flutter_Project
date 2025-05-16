import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../shared/styles/colors.dart';
import '../../shared/styles/styles.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Events',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('events')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error loading events: ${snapshot.error}'),
                    );
                  }
                  final docs = snapshot.data?.docs ?? [];

                  if (docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('images/event-list.png', height: 120),
                          const SizedBox(height: 24),
                          const Text(
                            'No events yet',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.text,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Create your first event to get started',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;
                      return _buildEventCard(
                        context,
                        title: data['name'] ?? 'No Title',
                        subtitle: 'Budget: \$${data['budget'] ?? '-'}',
                        date: data['date'] ?? '',
                        icon: Icons.event,
                        iconBg: AppColors.primary,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/createEvent');
          // Or Navigator.push(...) to your CreateEventPage
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }

  Widget _buildEventCard(
      BuildContext context, {
        required String title,
        required String subtitle,
        required String date,
        required IconData icon,
        required Color iconBg,
      }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppStyles.defaultPadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppStyles.borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconBg,
          radius: AppStyles.iconSize,
          child: Icon(
            icon,
            color: AppColors.white,
            size: AppStyles.largeIconSize,
          ),
        ),
        title: Text(title, style: AppStyles.titleStyle),
        subtitle: Text(subtitle, style: AppStyles.subtitleStyle),
        trailing: Text(date, style: AppStyles.subtitleStyle),
        onTap: () {
          // Optional: Navigate to event details page
        },
      ),
    );
  }
}
