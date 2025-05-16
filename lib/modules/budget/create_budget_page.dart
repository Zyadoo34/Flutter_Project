import 'package:flutter/material.dart';
import '../category/category-page.dart';
import '../../shared/styles/colors.dart';
import '../../shared/styles/styles.dart';
import '../../layout/entry_form_layout.dart';

class AddCostScreen extends StatefulWidget {
  const AddCostScreen({super.key});

  @override
  _AddCostScreenState createState() => _AddCostScreenState();
}

class _AddCostScreenState extends State<AddCostScreen> {
  String? selectedCategory = 'Attire & Accessories';
  IconData? selectedCategoryIcon = Icons.checkroom;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return EntryFormLayout(
      title: 'Add a new cost',
      fields: [
        TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'Name',
            labelStyle: AppStyles.menuLabelStyle.copyWith(
              fontSize: 14,
              color: AppColors.grey,
            ),
            filled: true,
            fillColor: AppColors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppStyles.smallBorderRadius),
              borderSide: BorderSide(color: AppColors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppStyles.smallBorderRadius),
              borderSide: BorderSide(color: AppColors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppStyles.smallBorderRadius),
              borderSide: BorderSide(color: AppColors.primary),
            ),
          ),
        ),
        SizedBox(height: AppStyles.smallPadding),
        TextField(
          controller: noteController,
          decoration: InputDecoration(
            labelText: 'Note',
            labelStyle: AppStyles.menuLabelStyle.copyWith(
              fontSize: 14,
              color: AppColors.grey,
            ),
            filled: true,
            fillColor: AppColors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppStyles.smallBorderRadius),
              borderSide: BorderSide(color: AppColors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppStyles.smallBorderRadius),
              borderSide: BorderSide(color: AppColors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppStyles.smallBorderRadius),
              borderSide: BorderSide(color: AppColors.primary),
            ),
          ),
        ),
        SizedBox(height: AppStyles.smallPadding),
        GestureDetector(
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SelectCategoryPage()),
            );
            if (result != null) {
              setState(() {
                selectedCategory = result[0];
                selectedCategoryIcon = result[1];
              });
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppStyles.smallPadding,
              vertical: AppStyles.smallPadding - 2,
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppStyles.smallBorderRadius),
              border: Border.all(color: AppColors.grey),
            ),
            child: Row(
              children: [
                Icon(
                  selectedCategoryIcon ?? Icons.checkroom,
                  color: AppColors.primaryDark,
                  size: AppStyles.iconSize - 2,
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedCategory ?? '',
                      style: AppStyles.subtitleStyle.copyWith(fontSize: 11),
                    ),
                    Text(
                      selectedCategory ?? '',
                      style: AppStyles.menuLabelStyle.copyWith(
                        fontSize: 14,
                        color: AppColors.text,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.grey,
                  size: AppStyles.smallIconSize,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: AppStyles.smallPadding),
        TextField(
          controller: amountController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Amount',
            labelStyle: AppStyles.menuLabelStyle.copyWith(
              fontSize: 14,
              color: AppColors.grey,
            ),
            filled: true,
            fillColor: AppColors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppStyles.smallBorderRadius),
              borderSide: BorderSide(color: AppColors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppStyles.smallBorderRadius),
              borderSide: BorderSide(color: AppColors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppStyles.smallBorderRadius),
              borderSide: BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ],
      buttonText: 'ADD',
      onSubmit: () {
        print("Name: \\${nameController.text}");
        print("Note: \\${noteController.text}");
        print("Category: \\$selectedCategory");
        print("Amount: \\${amountController.text}");
        Navigator.pop(context);
      },
    );
  }
}