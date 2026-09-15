import 'dart:async';
import 'package:escapia/core/constants/app_colors.dart';
import 'package:escapia/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PageHeader extends StatefulWidget {
  final String title;

  const PageHeader({super.key, required this.title});

  @override
  State<PageHeader> createState() => _PageHeaderState();
}

class _PageHeaderState extends State<PageHeader> {
  late Timer _timer;
  String currentTime = '';

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  void _updateTime() {
    setState(() {
      currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(color: AppColors.midnightNavyBackground),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.title, style: AppTextStyles.font22W700),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.richBlackBackground,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.textMuted, width: 1),
                ),
                child: Text(
                  currentTime,
                  style: AppTextStyles.font14W400White70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
