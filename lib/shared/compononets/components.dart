import 'package:flutter/material.dart';
import '../styles/colors.dart';
import '../styles/styles.dart';

Widget scrollSelectorRow({
  required List<dynamic> items,
  required int selectedIndex,
  required ValueChanged<int> onSelected,
  double? horizontalPadding,
  double? verticalPadding,
  bool isIconList = false,
}) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: List.generate(items.length, (index) {
        final selected = selectedIndex == index;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 2.0),
          child: GestureDetector(
            onTap: () => onSelected(index),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: verticalPadding ?? 6,
              ),
              decoration: BoxDecoration(
                gradient:
                    selected
                        ? const LinearGradient(
                          colors: AppColors.primaryGradient,
                        )
                        : null,
                color: selected ? null : AppColors.white,
                borderRadius: BorderRadius.circular(
                  AppStyles.smallBorderRadius - 2,
                ),
                border: selected ? null : Border.all(color: AppColors.grey),
              ),
              child:
                  isIconList
                      ? Icon(
                        items[index],
                        color: selected ? AppColors.white : AppColors.text,
                        size: 28,
                      )
                      : Text(
                        items[index],
                        style: TextStyle(
                          color: selected ? AppColors.white : AppColors.text,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
            ),
          ),
        );
      }),
    ),
  );
}

Widget standardCard({
  required Widget child,
  EdgeInsets? padding,
  EdgeInsets? margin,
}) {
  return Container(
    margin: margin ?? const EdgeInsets.all(AppStyles.smallPadding),
    padding: padding ?? const EdgeInsets.all(AppStyles.smallPadding),
    decoration: AppStyles.cardDecoration,
    child: child,
  );
}

Widget sectionHeader({
  required IconData icon,
  required String title,
  String? actionText,
  VoidCallback? onActionTap,
}) {
  return Padding(
    padding: const EdgeInsets.all(AppStyles.smallPadding),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: AppStyles.smallIconSize - 2,
              color: AppColors.text,
            ),
            const SizedBox(width: AppStyles.smallPadding - 2),
            Text(title, style: AppStyles.titleStyle.copyWith(fontSize: 12)),
          ],
        ),
        if (actionText != null)
          GestureDetector(
            onTap: onActionTap,
            child: Text(
              actionText,
              style: AppStyles.subtitleStyle.copyWith(fontSize: 11),
            ),
          ),
      ],
    ),
  );
}

Widget progressBar({required double value, double? height}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(3),
    child: LinearProgressIndicator(
      value: value,
      backgroundColor: AppColors.progressBackground,
      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
      minHeight: height ?? 6,
    ),
  );
}

Widget menuItem({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(AppStyles.smallPadding - 2),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppStyles.borderRadius - 4),
          ),
          child: Icon(
            icon,
            color: AppColors.white,
            size: AppStyles.iconSize - 4,
          ),
        ),
        const SizedBox(height: AppStyles.smallPadding - 2),
        Text(label, style: AppStyles.menuLabelStyle.copyWith(fontSize: 10)),
      ],
    ),
  );
}
