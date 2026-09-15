import 'package:escapia/core/constants/app_assets.dart';
import 'package:escapia/core/constants/app_colors.dart';
import 'package:escapia/core/constants/app_strings.dart';
import 'package:escapia/core/constants/app_text_styles.dart';
import 'package:escapia/core/routing/app_routes.dart';
import 'package:escapia/core/widgets/sidebar_item.dart';
import 'package:escapia/features/overview/domain/entities/zone_entity.dart';
import 'package:escapia/features/overview/presentation/cubit/building_state_cubit/building_state_cubit.dart';
import 'package:escapia/features/overview/presentation/cubit/building_state_cubit/building_state_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

enum SystemStatus { normal, smoke, critical }

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  Color _getGlowColor(SystemStatus status) {
    switch (status) {
      case SystemStatus.normal:
        return AppColors.successEmerald80;
      case SystemStatus.smoke:
        return AppColors.warningAmber;
      case SystemStatus.critical:
        return AppColors.brightRed;  
    }
  }

  SystemStatus _calculateStatusFromZones(List<ZoneEntity> zones) {
    if (zones.isEmpty) return SystemStatus.normal;

    final hasFire = zones.any((zone) => zone.fireDetected == true);
    if (hasFire) return SystemStatus.critical;

    final hasSmokeOrWarning = zones.any((zone) {
      final risk = zone.riskLevel.trim().toLowerCase();
      return zone.smokeDetected == true ||
          risk == 'smoke' ||
          risk == 'warning' ||
          risk == 'medium' ||
          risk == 'high'; 
    });

    if (hasSmokeOrWarning) return SystemStatus.smoke;

    final hasEvacuation = zones.any((zone) => zone.evacuationRequired == true);
    if (hasEvacuation) return SystemStatus.critical;

    return SystemStatus.normal;
  }

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.path;
    final Size screenSize = MediaQuery.sizeOf(context);

    final double sidebarWidth = (screenSize.width * 0.18).clamp(210.0, 260.0);

    final bool isShortScreen = screenSize.height < 720;
    final double topPadding = isShortScreen ? 20.0 : 34.0;
    final double logoSize = isShortScreen ? 46.0 : 58.0;

    return BlocBuilder<BuildingStateCubit, BuildingStateState>(
      builder: (context, state) {
        SystemStatus currentStatus = SystemStatus.normal;

        if (state is BuildingStateLoaded) {
          currentStatus = _calculateStatusFromZones(state.zones);
        }

        final glowColor = _getGlowColor(currentStatus);

        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: sidebarWidth,
          height: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.graphiteBackground,
            gradient: RadialGradient(
              center: const Alignment(-1.2, 1.2),
              radius: 1.8,
              colors: [
                glowColor.withOpacity(0.60),
                glowColor.withOpacity(0.20),
                Colors.transparent,
              ],
              stops: const [0.0, 0.45, 1.0],
            ),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 18,
                    right: 18,
                    top: topPadding,
                    bottom: isShortScreen ? 12 : 20,
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        AppAssets.escapiaLogoTransparent,
                        height: logoSize,
                        width: logoSize,
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          AppStrings.appname,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: AppTextStyles.font17W700Spacing,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isShortScreen ? 6 : 12),

                SidebarItem(
                  icon: Icons.grid_view,
                  label: 'Overview',
                  isSelected: currentPath == AppRoutes.overview,
                  onTap: () => context.go(AppRoutes.overview),
                ),
                SidebarItem(
                  icon: Icons.map_outlined,
                  label: 'Live Map',
                  isSelected: currentPath == AppRoutes.liveMap,
                  onTap: () => context.go(AppRoutes.liveMap),
                ),
                SidebarItem(
                  icon: Icons.warning_amber_outlined,
                  label: 'Incidents',
                  isSelected: currentPath == AppRoutes.incidents,
                  onTap: () => context.go(AppRoutes.incidents),
                ),
                SidebarItem(
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                  isSelected: currentPath == AppRoutes.settings,
                  onTap: () => context.go(AppRoutes.settings),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}