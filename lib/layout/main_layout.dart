import 'package:event_planner/checklist/view.dart';
import 'package:flutter/material.dart';
import '../modules/budget/budget-page.dart';
import '../modules/budget/create_budget_page.dart';
import '../shared/styles/colors.dart';
import '../modules/events/events_page.dart';
import '../modules/home_page.dart';
import '../modules/events/create_event_page.dart';
import '../modules/menu/menu_page.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const ChecklistPage(), // Placeholder for Checklist
    const EventsPage(),
    AddCostScreen(), // Placeholder for Budget
    const MenuPage(),
  ];

  String get _title {
    switch (_selectedIndex) {
      case 0:
        return 'Home';
      case 1:
        return 'Checklist';
      case 2:
        return 'Events';
      case 3:
        return 'Budget';
      case 4:
        return 'Menu';
      default:
        return '';
    }
  }

  IconData get _titleIcon {
    switch (_selectedIndex) {
      case 0:
        return Icons.home_outlined;
      case 1:
        return Icons.task_alt;
      case 2:
        return Icons.event;
      case 3:
        return Icons.account_balance_wallet;
      case 4:
        return Icons.grid_view;
      default:
        return Icons.home_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Icon(_titleIcon, color: AppColors.text),
            const SizedBox(width: 8),
            Text(
              _title,
              style: const TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.white,
      ),
      body: _pages[_selectedIndex],
      backgroundColor: AppColors.background,
      floatingActionButton:
          _selectedIndex == 2
              ? FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CreateEventPage(),
                    ),
                  );
                },
                backgroundColor: AppColors.primary,
                shape: const CircleBorder(),
                child: const Icon(Icons.add, color: AppColors.white),
              )
              : null,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.task_alt),
            label: 'Checklist',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Budget',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Menu'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
