import 'package:escapia/core/constants/app_colors.dart';
import 'package:escapia/core/constants/app_text_styles.dart';
import 'package:escapia/core/utils/context_extension.dart';
import 'package:escapia/features/settings/presentation/widgets/preference_about_section.dart';
import 'package:escapia/features/settings/presentation/widgets/drop_down.dart';
import 'package:escapia/features/settings/presentation/widgets/preference_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PreferencesCard extends StatefulWidget {
  final bool isWeb;
  final VoidCallback? onLogoutOtherSessions;

  const PreferencesCard({
    super.key,
    this.isWeb = false,
    this.onLogoutOtherSessions,
  });

  @override
  State<PreferencesCard> createState() => _PreferencesCardState();
}

class _PreferencesCardState extends State<PreferencesCard> {
  bool isDarkMode = true;
  String selectedLanguage = 'English';
  String selectedTimeZone = 'Cairo (GMT+2)';
  double fontSizeValue = 0.25;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.space(widget.isWeb ? 24 : 20)),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Preferences', style: AppTextStyles.font18W700Primary),
          SizedBox(height: context.space(18)),
          Container(
            decoration: BoxDecoration(
              color: AppColors.darkSurfaceNavy,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.dividerBorder, width: 1),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                PreferenceTile(
                  title: 'Theme',
                  trailing: Transform.scale(
                    scale: 0.8,
                    child: CupertinoSwitch(
                      value: isDarkMode,
                      activeColor: AppColors.borderMediumSlate,
                      trackColor: AppColors.cardBackground,
                      onChanged: (value) => setState(() => isDarkMode = value),
                    ),
                  ),
                ),
                PreferenceTile(
                  title: 'Language',
                  trailing: DropDown(text: selectedLanguage),
                ),
                PreferenceTile(
                  title: 'Time zone',
                  trailing: DropDown(text: selectedTimeZone),
                ),
                PreferenceTile(
                  showBottomBorder: widget.isWeb,
                  customContent: Row(
                    children: [
                      const Text(
                        '- A',
                        style: AppTextStyles.font13W700Secondary,
                      ),
                      Expanded(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 2,
                            activeTrackColor: AppColors.textSecondary,
                            inactiveTrackColor: AppColors.dividerBorder,
                            thumbColor: AppColors.textSecondary,
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 6,
                            ),
                            overlayShape: SliderComponentShape.noOverlay,
                          ),
                          child: Slider(
                            value: fontSizeValue,
                            onChanged: (value) =>
                                setState(() => fontSizeValue = value),
                          ),
                        ),
                      ),
                      const Text('+ A', style: AppTextStyles.font18W700Primary),
                    ],
                  ),
                ),
                const PreferenceAboutSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
