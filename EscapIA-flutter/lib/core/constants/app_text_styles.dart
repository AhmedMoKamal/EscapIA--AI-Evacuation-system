import 'package:flutter/material.dart';
import 'package:escapia/core/constants/app_colors.dart';

abstract class AppTextStyles {
  AppTextStyles._();

  static const TextStyle font26W700 = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 26,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle font22W700 = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
  );

  static const TextStyle font22W700RouteBlue = TextStyle(
    color: AppColors.routeBlue,
    fontSize: 22,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle font21W700 = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 21,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle font20W700 = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle font18W700Primary = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle font18W700RouteBlue = TextStyle(
    color: AppColors.routeBlue,
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle font22W700White = TextStyle(
    color: Colors.white,
    fontSize: 22,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle font17W700 = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 17,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle font17W700Spacing = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 17,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.1,
  );

  static const TextStyle font16W700 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
  );

  static const TextStyle font16W700Primary = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle font16W600 = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle font16W500White70 = TextStyle(
    color: AppColors.textWhite70,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle font16W400White54 = TextStyle(
    color: AppColors.textWhite54,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle font16W400White70 = TextStyle(
    color: AppColors.textWhite70,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle font15W700Primary = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 15,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle font15W700Red = TextStyle(
    color: AppColors.vividRed,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
  );
  static const TextStyle font15W700Spacing = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.3,
  );
  static const TextStyle font15W600Primary = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle font15W500 = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle font15W400Primary = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle font15W400RouteBlue = TextStyle(
    color: AppColors.routeBlue,
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle font15W400Empty = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
  );

  static const TextStyle font14W700Primary = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle font14W500Primary = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle font14W500Red = TextStyle(
    color: AppColors.vividRed,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle font14W400Red = TextStyle(
    color: AppColors.vividRed,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle font14W400White70 = TextStyle(
    color: AppColors.textWhite70,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle font14W400White54 = TextStyle(
    color: AppColors.textWhite54,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle font14W400InfoLabel = TextStyle(
    color: AppColors.infoLabelText,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle font14W600Primary = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle font14Code = TextStyle(
    fontSize: 14,
    fontFamily: 'monospace',
    color: AppColors.textPrimary,
  );

  static const TextStyle font13W600 = TextStyle(
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w600,
    fontSize: 13,
  );

  static const TextStyle font13W600Primary = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle font13W500Primary = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle font13W500InfoValue = TextStyle(
    color: AppColors.infoValueText,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle font13W400Primary = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 13,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle font13W400Secondary = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 13,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle font13W700Secondary = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 13,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle font13W500MutedSlate = TextStyle(
    color: AppColors.mutedSlateText,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle font13W500RouteBlue = TextStyle(
    color: AppColors.routeBlue,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle font13W400SlateGray = TextStyle(
    color: AppColors.slateGrayText,
    fontSize: 13,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle font13W400White54 = TextStyle(
    color: AppColors.textWhite54,
    fontSize: 13,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle font14W400Secondary = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle font12W500LightSlate = TextStyle(
    color: AppColors.lightSlateText,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle font12W400White54 = TextStyle(
    color: AppColors.textWhite54,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle font12W400Secondary = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static const TextStyle font12W400Primary = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.35,
  );

  static const TextStyle font11W700 = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 11,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle font11W700Cyan = TextStyle(
    color: AppColors.brightCyan,
    fontSize: 11,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle font11W600 = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle font11W600MonospaceBlue = TextStyle(
    color: AppColors.routeBlue,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    fontFamily: 'monospace',
  );
  static const TextStyle font11W500InfoValue = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle font11W400 = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle font11W400InfoLabel = TextStyle(
    color: AppColors.infoLabelText,
    fontSize: 11,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle font11W400SlateBlue = TextStyle(
    color: AppColors.infoSlateBlue,
    fontSize: 11,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle font10W700Amber = TextStyle(
    color: AppColors.warningAmber,
    fontSize: 10,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle font34FireIcon = TextStyle(
    fontSize: 34,
    color: AppColors.vividRed,
    shadows: [
      Shadow(
        color: AppColors.vividRed,
        blurRadius: 10,
      ),
    ],
  );
}