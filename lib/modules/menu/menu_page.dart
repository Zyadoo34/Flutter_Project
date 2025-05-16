import 'package:flutter/material.dart';
import '../../shared/styles/colors.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Settings & Tools',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 24),
          _buildSection(
            context,
            'Account Settings',
            [
              _MenuItem(
                icon: Icons.person_outline,
                title: 'Profile',
                onTap: () {
                  // TODO: Implement profile navigation
                },
              ),
              _MenuItem(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                onTap: () {
                  // TODO: Implement notifications settings
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            context,
            'Event Planning Tools',
            [
              _MenuItem(
                icon: Icons.calendar_today,
                title: 'Calendar Sync',
                onTap: () {
                  // TODO: Implement calendar sync
                },
              ),
              _MenuItem(
                icon: Icons.people_outline,
                title: 'Guest List Templates',
                onTap: () {
                  // TODO: Implement guest list templates
                },
              ),
              _MenuItem(
                icon: Icons.restaurant_menu,
                title: 'Menu Templates',
                onTap: () {
                  // TODO: Implement menu templates
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            context,
            'Support',
            [
              _MenuItem(
                icon: Icons.help_outline,
                title: 'Help Center',
                onTap: () {
                  // TODO: Implement help center
                },
              ),
              _MenuItem(
                icon: Icons.feedback_outlined,
                title: 'Send Feedback',
                onTap: () {
                  // TODO: Implement feedback
                },
              ),
              _MenuItem(
                icon: Icons.info_outline,
                title: 'About',
                onTap: () {
                  // TODO: Implement about page
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<_MenuItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.grey, width: 1),
          ),
          child: Column(
            children: items.map((item) {
              return Column(
                children: [
                  ListTile(
                    leading: Icon(item.icon, color: AppColors.primary),
                    title: Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.text,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: AppColors.grey,
                    ),
                    onTap: item.onTap,
                  ),
                  if (items.last != item)
                    const Divider(height: 1, color: AppColors.grey),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });
} 