import 'package:flutter/material.dart';
import '../shared/styles/colors.dart';
import '../shared/styles/styles.dart';

class EntryFormLayout extends StatelessWidget {
  final String title;
  final List<Widget> fields;
  final Widget? statusTabs;
  final String buttonText;
  final VoidCallback onSubmit;

  const EntryFormLayout({
    super.key,
    required this.title,
    required this.fields,
    this.statusTabs,
    required this.buttonText,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: AppStyles.titleStyle.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: AppColors.text,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.text),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.text),
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...fields,
            if (statusTabs != null) ...[
              const SizedBox(height: 12),
              statusTabs!,
            ],
            const SizedBox(height: 20),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppStyles.smallBorderRadius,
                    ),
                  ),
                ),
                onPressed: onSubmit,
                child: Text(
                  buttonText,
                  style: AppStyles.titleStyle.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}