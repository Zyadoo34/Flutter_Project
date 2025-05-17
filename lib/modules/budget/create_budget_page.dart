import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  final TextEditingController nameController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController categorycontroller = TextEditingController();

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
        'category': categorycontroller.text.trim(),

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
        TextField(
          controller: categorycontroller,
          decoration: InputDecoration(
            labelText: 'Category',
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
