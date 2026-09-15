import 'package:escapia/core/constants/app_assets.dart';
import 'package:escapia/core/constants/app_colors.dart';
import 'package:escapia/core/constants/app_text_styles.dart';
import 'package:escapia/core/routing/app_routes.dart';
import 'package:escapia/core/widgets/custom_bottom_nav_bar.dart';
import 'package:escapia/core/widgets/page_header.dart';
import 'package:escapia/core/widgets/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({
    super.key,
    required this.navigationShell,
  });

  String _getScreenTitle(String path) {
    switch (path) {
      case AppRoutes.overview:
        return 'Overview';
      case AppRoutes.liveMap:
        return 'Live Map';
      case AppRoutes.incidents:
        return 'Incidents';
      case AppRoutes.settings:
        return 'Settings';
      default:
        return '';
    }
  }

  void _onNavTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.path;
    final title = _getScreenTitle(currentPath);

    final isMobile = MediaQuery.sizeOf(context).width < 768;

    if (isMobile) {
      return Scaffold(
        backgroundColor: AppColors.richBlackBackground,
        appBar: AppBar(
          backgroundColor: AppColors.graphiteBackground,
          elevation: 0,
          titleSpacing: 16,
          title: Row(
            children: [
              Image.asset(
                AppAssets.escapiaLogoTransparent,
                height: 24,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTextStyles.font18W700Primary,
              ),
            ],
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.twilightBlueBackground,
                AppColors.richBlackBackground,
              ],
            ),
          ),
          child: navigationShell,
        ),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: navigationShell.currentIndex,
          onTap: _onNavTap,
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.coolSlateSurface,
              AppColors.richBlackBackground,
            ],
          ),
        ),
        child: Row(
          children: [
            const Sidebar(),
            Expanded(
              child: Column(
                children: [
                  PageHeader(title: title),
                  Expanded(child: navigationShell),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}