import 'package:escapia/core/constants/app_colors.dart';
import 'package:escapia/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = const [
      (icon: Icons.home_outlined, label: 'Overview', branchIndex: 0),
      (icon: Icons.location_on, label: 'Map', branchIndex: 1),
      (icon: Icons.person, label: 'Profile', branchIndex: 3),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.navBackground,
        border: Border(
          top: BorderSide(color: AppColors.darkSteelBlueBorder, width: 0.8),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: items.map((item) {
              final isSelected = item.branchIndex == currentIndex;
              final itemColor = isSelected
                  ? AppColors.navItemActive
                  : AppColors.navItemInactive;

              return Expanded(
                child: InkWell(
                  onTap: () => onTap(item.branchIndex),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        item.icon,
                        color: itemColor,
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: (isSelected
                                ? AppTextStyles.font11W600
                                : AppTextStyles.font11W400)
                            .copyWith(color: itemColor),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}