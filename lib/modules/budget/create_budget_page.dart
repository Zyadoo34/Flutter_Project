import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? selectedCategory = 'Attire & Accessories';
  IconData? selectedCategoryIcon = Icons.checkroom;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  Future<void> _submitCost() async {
    try {
      // Validate inputs
      if (nameController.text.isEmpty) {
        throw 'Name is required';
      }

      final amountText = amountController.text.replaceAll(',', '.');
      final amount = double.tryParse(amountText);
      if (amount == null || amount <= 0) {
        throw 'Please enter a valid amount';
      }

      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      await _firestore.collection('budgetItems').add({
        'description': nameController.text.trim(),
        'note': noteController.text.trim(),
        'category': selectedCategory,
        'categoryIcon': selectedCategoryIcon?.codePoint,
        'amount': amount,
        'createdAt': FieldValue.serverTimestamp(),
        'isPaid': false,
      });

      // Clear the form
      nameController.clear();
      noteController.clear();
      amountController.clear();

      // Close loading indicator and show success message
      if (mounted) {
        Navigator.pop(context); // Close loading
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Budget item added successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading if open
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    noteController.dispose();
    amountController.dispose();
    super.dispose();
  }

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
              borderSide: const BorderSide(color: AppColors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppStyles.smallBorderRadius),
              borderSide: const BorderSide(color: AppColors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppStyles.smallBorderRadius),
              borderSide: const BorderSide(color: AppColors.primary),
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
              borderSide: const BorderSide(color: AppColors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppStyles.smallBorderRadius),
              borderSide: const BorderSide(color: AppColors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppStyles.smallBorderRadius),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
        ),
        SizedBox(height: AppStyles.smallPadding),
        GestureDetector(
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SelectCategoryPage()),
            );
            if (result != null && result is List && result.length == 2 && mounted) {
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
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Category',
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
                const Spacer(),
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
          keyboardType: TextInputType.numberWithOptions(decimal: true),
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
              borderSide: const BorderSide(color: AppColors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppStyles.smallBorderRadius),
              borderSide: const BorderSide(color: AppColors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppStyles.smallBorderRadius),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ],
      buttonText: 'ADD',
      onSubmit: _submitCost,
    );
  }
}