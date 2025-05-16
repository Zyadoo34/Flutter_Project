import 'package:flutter/material.dart';
import '../shared/styles/colors.dart';
import '../shared/styles/styles.dart';
import 'events/events_page.dart';
import 'budget/budget-page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    void onMenuGridTap(String label) {
      if (label == 'Events') {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const EventsPage()));
      } else if (label == 'Budget') {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => AddCostScreen()));
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
        '.',
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
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppStyles.borderRadius),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTimeUnit('01', 'Days'),
                _buildTimeSeparator(),
                _buildTimeUnit('08', 'Hours'),
                _buildTimeSeparator(),
                _buildTimeUnit('22', 'Mins'),
                _buildTimeSeparator(),
                _buildTimeUnit('12', 'Secs'),
              ],
            ),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.event, color: AppColors.white),
            ),
            title: Text('Name is not defined', style: AppStyles.titleStyle),
            subtitle: Text(
              '4/30/25, Your event',
              style: AppStyles.subtitleStyle,
            ),
            trailing: const Icon(Icons.menu, color: AppColors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String label,
    Color color,
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
                Icon(
                  Icons.grid_view,
                  size: AppStyles.smallIconSize,
                  color: AppColors.text,
                ),
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
                _buildMenuItem(
                  Icons.checklist,
                  'Checklist',
                  AppColors.primary,
                  onTap,
                ),
                _buildMenuItem(Icons.event, 'Events', AppColors.primary, onTap),
                _buildMenuItem(
                  Icons.attach_money,
                  'Budget',
                  AppColors.primary,
                  onTap,
                ),
                _buildMenuItem(
                  Icons.people_outline,
                  'Helpers',
                  AppColors.primary,
                  onTap,
                ),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppStyles.defaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.checklist_rtl,
                      size: AppStyles.smallIconSize,
                      color: AppColors.text,
                    ),
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
                Text(
                  'There are no uncompleted tasks',
                  style: AppStyles.subtitleStyle,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppStyles.defaultPadding,
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: 100,
                    backgroundColor: AppColors.grey,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                    minHeight: 8,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('0% completed', style: AppStyles.subtitleStyle),
                      Text('0 out of 0', style: AppStyles.subtitleStyle),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppStyles.smallPadding),
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
                    Icon(
                      Icons.account_balance_wallet_outlined,
                      size: AppStyles.smallIconSize,
                      color: AppColors.text,
                    ),
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
                Icon(
                  Icons.announcement_outlined,
                  size: AppStyles.smallIconSize,
                  color: AppColors.grey,
                ),
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
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: AppStyles.defaultPadding,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppStyles.smallBorderRadius,
                  ),
                ),
              ),
              child: const Text(
                'RATE THIS APP',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
              ),
            ),
          ),
          const SizedBox(height: AppStyles.smallPadding),
        ],
      ),
    );
  }
}
