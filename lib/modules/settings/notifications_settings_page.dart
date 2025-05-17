import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared/styles/colors.dart';
import '../../shared/styles/styles.dart';

class NotificationsSettingsPage extends StatefulWidget {
  const NotificationsSettingsPage({super.key});

  @override
  State<NotificationsSettingsPage> createState() => _NotificationsSettingsPageState();
}

class _NotificationsSettingsPageState extends State<NotificationsSettingsPage> {
  bool _eventsNotifications = true;
  bool _checklistReminders = true;
  bool _budgetAlerts = true;
  bool _appUpdates = true;

  @override
  void initState() {
    super.initState();
    _loadNotificationPreferences();
  }

  Future<void> _loadNotificationPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _eventsNotifications = prefs.getBool('events_notifications') ?? true;
      _checklistReminders = prefs.getBool('checklist_reminders') ?? true;
      _budgetAlerts = prefs.getBool('budget_alerts') ?? true;
      _appUpdates = prefs.getBool('app_updates') ?? true;
    });
  }

  Future<void> _saveNotificationPreference(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Widget _buildNotificationSwitch({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.dividerColor, width: 0.5),
        ),
      ),
      child: SwitchListTile(
        title: Text(
          title,
          style: AppStyles.menuLabelStyle.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppStyles.subtitleStyle.copyWith(
            fontSize: 12,
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: theme.colorScheme.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Notification Preferences',
                style: AppStyles.titleStyle.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            Container(
              color: theme.colorScheme.surface,
              child: Column(
                children: [
                  _buildNotificationSwitch(
                    title: 'Event Notifications',
                    subtitle: 'Get notified about upcoming events and changes',
                    value: _eventsNotifications,
                    onChanged: (value) {
                      setState(() => _eventsNotifications = value);
                      _saveNotificationPreference('events_notifications', value);
                    },
                  ),
                  _buildNotificationSwitch(
                    title: 'Checklist Reminders',
                    subtitle: 'Receive reminders for pending checklist items',
                    value: _checklistReminders,
                    onChanged: (value) {
                      setState(() => _checklistReminders = value);
                      _saveNotificationPreference('checklist_reminders', value);
                    },
                  ),
                  _buildNotificationSwitch(
                    title: 'Budget Alerts',
                    subtitle: 'Get alerts for budget updates and overruns',
                    value: _budgetAlerts,
                    onChanged: (value) {
                      setState(() => _budgetAlerts = value);
                      _saveNotificationPreference('budget_alerts', value);
                    },
                  ),
                  _buildNotificationSwitch(
                    title: 'App Updates',
                    subtitle: 'Stay informed about new features and updates',
                    value: _appUpdates,
                    onChanged: (value) {
                      setState(() => _appUpdates = value);
                      _saveNotificationPreference('app_updates', value);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 