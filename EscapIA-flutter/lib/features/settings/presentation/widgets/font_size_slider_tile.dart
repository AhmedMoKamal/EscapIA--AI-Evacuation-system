import 'package:escapia/core/constants/app_colors.dart';
import 'package:escapia/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

class FontSizeSliderTile extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final bool showDivider;

  const FontSizeSliderTile({
    super.key,
    required this.value,
    required this.onChanged,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '- A',
                style: AppTextStyles.font13W500InfoValue,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 2,
                    activeTrackColor:  AppColors.borderMediumSlate,
                    inactiveTrackColor: const Color(0xFF374151),
                    thumbColor: Colors.transparent,
                    overlayColor: Colors.transparent,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 6,
                      elevation: 0,
                    ),
                  ),
                  child: Slider(
                    value: value,
                    min: 0.0,
                    max: 1.0,
                    onChanged: onChanged,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '+ A',
                style: AppTextStyles.font22W700White,
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFF202B3C),
          ),
      ],
    );
  }
}