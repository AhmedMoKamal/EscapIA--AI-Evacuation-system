import 'package:escapia/features/settings/presentation/pages/settings_mobile_page.dart';
import 'package:escapia/features/settings/presentation/pages/settings_web_page.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 768) {
          return const SettingsWebPage();
        } else {
          return const SettingsMobilePage();
        }
      },
    );
  }
}