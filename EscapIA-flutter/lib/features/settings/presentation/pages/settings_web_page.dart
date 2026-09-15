import 'package:escapia/core/utils/context_extension.dart';
import 'package:escapia/features/settings/presentation/widgets/preference_card.dart';
import 'package:escapia/features/settings/presentation/widgets/web_profile_info_card.dart';
import 'package:flutter/material.dart';

class SettingsWebPage extends StatelessWidget {
  const SettingsWebPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: context.space(36),
            vertical: context.space(24),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [
                  const Expanded(
                    flex: 4,
                    child: WebProfileInfoCard(
                      name: 'Malik Hassan',
                      phoneNumber: '+20 xxxxxxxxxx',
                      role: 'CCTV Operator',
                    ),
                  ),
                  SizedBox(width: context.space(24)),
                  Expanded(
                    flex: 6,
                    child: PreferencesCard(
                      isWeb: true,
                      onLogoutOtherSessions: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}