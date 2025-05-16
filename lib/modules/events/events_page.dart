import 'package:flutter/material.dart';
import '../../shared/styles/colors.dart';
import '../../shared/styles/styles.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppStyles.defaultPadding),
      children: [
        _buildEventCard(
          context,
          title: 'Name is not defined',
          subtitle: 'Your event',
          date: '4/30/25',
          icon: Icons.mic,
          iconBg: AppColors.primary,
        ),
        // Add more events here as needed
      ],
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
        onTap: () {},
      ),
    );
  }
}
