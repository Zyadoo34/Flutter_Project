import 'package:flutter/material.dart';
import '../shared/styles/colors.dart';
import '../shared/styles/styles.dart';
import 'events/events_page.dart';
import 'budget/budget-page.dart'; // Make sure this file exists
import '../checklist/view.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer? _timer;
  DateTime? _eventDate;
  String _eventName = 'No Event Selected';
  Map<String, String> _timeLeft = {
    'days': '00',
    'hours': '00',
    'minutes': '00',
    'seconds': '00'
  };

  @override
  void initState() {
    super.initState();
    // Set a sample event date - you can replace this with actual event data
    _eventDate = DateTime.now().add(const Duration(days: 7));
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_eventDate != null) {
        final now = DateTime.now();
        final difference = _eventDate!.difference(now);
        
        if (difference.isNegative) {
          setState(() {
            _timeLeft = {
              'days': '00',
              'hours': '00',
              'minutes': '00',
              'seconds': '00'
            };
          });
          timer.cancel();
        } else {
          final days = difference.inDays;
          final hours = difference.inHours.remainder(24);
          final minutes = difference.inMinutes.remainder(60);
          final seconds = difference.inSeconds.remainder(60);

          setState(() {
            _timeLeft = {
              'days': days.toString().padLeft(2, '0'),
              'hours': hours.toString().padLeft(2, '0'),
              'minutes': minutes.toString().padLeft(2, '0'),
              'seconds': seconds.toString().padLeft(2, '0')
            };
          });
        }
      }
    });
  }

  void _selectEventDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _eventDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );

    if (picked != null) {
      setState(() {
        _eventDate = picked;
      });
      
      // Show dialog to enter event name
      // ignore: use_build_context_synchronously
      final name = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Event Name'),
          content: TextField(
            decoration: const InputDecoration(
              hintText: 'Enter event name',
              labelText: 'Event Name',
            ),
            onSubmitted: (value) => Navigator.pop(context, value),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'My Event'),
              child: const Text('OK'),
            ),
          ],
        ),
      );

      if (name != null) {
        setState(() {
          _eventName = name;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    void onMenuGridTap(String label) {
      switch (label) {
        case 'Events':
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EventsPage()),
          );
          break;
        case 'Budget':
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddCostScreen()),
          );
          break;
        case 'Checklist':
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChecklistPage()),
          );
          break;
        case 'Helpers':
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Coming Soon'),
              content: const Text('The Helpers feature will be available in a future update.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
          break;
      }
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(AppStyles.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCountdownTimer(),
            _buildMenuGrid(onMenuGridTap),
            _buildChecklistSection(),
            _buildBudgetSection(),
            _buildRateAppSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeUnit(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: AppColors.white, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildTimeSeparator() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: AppStyles.smallPadding),
      child: Text(
        ':',
        style: TextStyle(
          color: AppColors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCountdownTimer() {
    return Container(
      margin: const EdgeInsets.only(bottom: AppStyles.defaultPadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppStyles.borderRadius),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppStyles.borderRadius),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTimeUnit(_timeLeft['days']!, 'Days'),
                _buildTimeSeparator(),
                _buildTimeUnit(_timeLeft['hours']!, 'Hours'),
                _buildTimeSeparator(),
                _buildTimeUnit(_timeLeft['minutes']!, 'Mins'),
                _buildTimeSeparator(),
                _buildTimeUnit(_timeLeft['seconds']!, 'Secs'),
              ],
            ),
          ),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppColors.primary,
              child: Icon(Icons.event, color: AppColors.white),
            ),
            title: Text(_eventName, style: AppStyles.titleStyle),
            subtitle: Text(
              _eventDate != null 
                ? '${_eventDate!.day}/${_eventDate!.month}/${_eventDate!.year}'
                : 'No date selected',
              style: AppStyles.subtitleStyle,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.edit, color: AppColors.grey),
              onPressed: _selectEventDate,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String label,
    void Function(String) onTap,
  ) {
    return GestureDetector(
      onTap: () => onTap(label),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(AppStyles.smallPadding),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppStyles.borderRadius),
            ),
            child: Icon(icon, color: AppColors.white, size: AppStyles.iconSize),
          ),
          const SizedBox(height: AppStyles.smallPadding),
          Text(label, style: AppStyles.menuLabelStyle),
        ],
      ),
    );
  }

  Widget _buildMenuGrid(void Function(String) onTap) {
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
                Icon(Icons.grid_view, size: AppStyles.smallIconSize, color: AppColors.text),
                const SizedBox(width: AppStyles.smallPadding),
                Text('MENU', style: AppStyles.titleStyle),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.grey),
          Padding(
            padding: const EdgeInsets.all(AppStyles.defaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMenuItem(Icons.checklist, 'Checklist', onTap),
                _buildMenuItem(Icons.event, 'Events', onTap),
                _buildMenuItem(Icons.attach_money, 'Budget', onTap),
                _buildMenuItem(Icons.people_outline, 'Helpers', onTap),
              ],
            ),
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
                Text('Summary >', style: AppStyles.subtitleStyle),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.grey),
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Image.asset('images/checklist.png', height: 75),
                const SizedBox(height: AppStyles.defaultPadding),
                Text('There are no uncompleted tasks', style: AppStyles.subtitleStyle),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppStyles.defaultPadding),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: const LinearProgressIndicator(
                    value: 1.0,
                    backgroundColor: AppColors.grey,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('100% completed', style: AppStyles.subtitleStyle),
                    Text('0 out of 0', style: AppStyles.subtitleStyle),
                  ],
                ),
              ],
            ),
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
                Text('Balance >', style: AppStyles.subtitleStyle),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.grey),
          Padding(
            padding: const EdgeInsets.all(AppStyles.defaultPadding),
            child: Column(
              children: [
                _buildBudgetRow('Budget', 'Not defined'),
                _buildBudgetRow('Paid', '\$0'),
                _buildBudgetRow('Pending', '\$0'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppStyles.smallPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppStyles.titleStyle),
          Text(
            value,
            style: TextStyle(
              color: value == 'Not defined' ? AppColors.grey : AppColors.text,
              fontSize: 14,
            ),
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