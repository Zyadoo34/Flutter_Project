import 'package:event_planner/shared/compononets/components.dart';
import 'package:flutter/material.dart';
import '../../layout/entry_form_layout.dart';
import '../../shared/styles/colors.dart';
import '../../shared/styles/styles.dart';


class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({super.key});

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final _nameController = TextEditingController();
  final _noteController = TextEditingController();

  final List<IconData> _icons = [
    Icons.checkroom,
    Icons.spa,
    Icons.music_note,
    Icons.local_florist,
    Icons.photo_camera,
    Icons.emoji_events,
    Icons.room_service,
    Icons.directions_car,
    Icons.home,
    Icons.church,
    Icons.ring_volume,
  ];
  int _selectedIconIndex = 0;

  @override
  Widget build(BuildContext context) {
    return EntryFormLayout(
      title: 'Add a new category',
      fields: [
        TextField(
          controller: _nameController,
          decoration: AppStyles.inputDecoration(label: 'Name'),
        ),
        SizedBox(height: AppStyles.smallPadding),
        TextField(
          controller: _noteController,
          decoration: AppStyles.inputDecoration(label: 'Note'),
        ),
        SizedBox(height: AppStyles.smallPadding),
        standardCard(
          margin: const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5, bottom: 8),
                child: Text(
                  'Select Icon',
                  style: AppStyles.menuLabelStyle.copyWith(
                    fontSize: 14,
                    color: AppColors.grey,
                  ),
                ),
              ),
              scrollSelectorRow(
                items: _icons,
                selectedIndex: _selectedIconIndex,
                onSelected:
                    (index) => setState(() => _selectedIconIndex = index),
                isIconList: true,
                horizontalPadding: 4,
                verticalPadding: 3,
              ),
            ],
          ),
        ),
      ],
      buttonText: 'ADD',
      onSubmit: () {
        if (_nameController.text.isNotEmpty) {
          Navigator.pop(context, {
            'name': _nameController.text,
            'note': _noteController.text,
            'icon': _icons[_selectedIconIndex],
          });
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Name is required')));
        }
      },
    );
  }
}