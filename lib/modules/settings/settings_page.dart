import 'package:flutter/material.dart';
import '../../shared/styles/colors.dart';
import '../../shared/styles/styles.dart';
import 'notifications_settings_page.dart';


class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(AppStyles.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSettingsSection(
              'Account Settings',
              [
                _buildSettingsItem(
                  Icons.person_outline,
                  'Profile',
                  onTap: () {
                    // TODO: Implement profile page navigation
                  },
                ),
                _buildSettingsItem(
                  Icons.lock_outline,
                  'Privacy & Security',
                  onTap: () {
                    // TODO: Implement privacy page navigation
                  },
                ),
                _buildSettingsItem(
                  Icons.backup_outlined,
                  'Backup & Restore',
                  onTap: () {
                    // TODO: Implement backup page navigation
                  },
                ),
              ],
            ),
            _buildSettingsSection(
              'App Settings',
              [
                _buildSettingsItem(
                  Icons.notifications_none,
                  'Notifications',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationsSettingsPage(),
                      ),
                    );
                  },
                ),
              
                _buildSettingsItem(
                  Icons.language,
                  'Language',
                  onTap: () {
                    // TODO: Implement language page navigation
                  },
                ),
              ],
            ),
            _buildSettingsSection(
              'Support',
              [
                _buildSettingsItem(
                  Icons.help_outline,
                  'Help Center',
                  onTap: () {
                    // TODO: Implement help center navigation
                  },
                ),
                _buildSettingsItem(
                  Icons.feedback_outlined,
                  'Send Feedback',
                  onTap: () {
                    // TODO: Implement feedback form
                  },
                ),
                _buildSettingsItem(
                  Icons.info_outline,
                  'About',
                  onTap: () {
                    // TODO: Implement about page navigation
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> items) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppStyles.defaultPadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppStyles.borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppStyles.defaultPadding),
            child: Text(
              title,
              style: AppStyles.titleStyle,
            ),
          ),
          const Divider(height: 1, color: AppColors.grey),
          ...items,
        ],
      ),
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, {VoidCallback? onTap}) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: AppColors.primary),
          title: Text(title, style: AppStyles.menuLabelStyle),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: onTap,
        ),
      ],
    );
  }
} 