import 'package:escapia/core/di/injection_container.dart';
import 'package:escapia/core/utils/auth_notifier.dart';
import 'package:escapia/features/overview/presentation/cubit/building_state_cubit/building_state_cubit.dart';
import 'package:escapia/features/overview/presentation/pages/overview.dart';
import 'package:escapia/features/settings/presentation/cubit/profle_cubit/profile_cubit.dart';
import 'package:escapia/features/security_auth/presentation/pages/login_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:escapia/core/routing/app_routes.dart';
import 'package:escapia/core/widgets/app_shell.dart';
import 'package:escapia/features/live_map/presentation/pages/live_map_page.dart';
import 'package:escapia/features/incidents/presentation/cubits/incident_cubit/incidents_cubit.dart';
import 'package:escapia/features/incidents/presentation/cubits/report_cubit/report_cubit.dart';
import 'package:escapia/features/incidents/presentation/pages/incidents_page.dart';
import 'package:escapia/features/settings/presentation/pages/settings_page.dart';

class AppRouting {
  final GoRouter goRouter = GoRouter(
    initialLocation: AppRoutes.overview,

    refreshListenable: sl<AuthNotifier>(),

    redirect: (context, state) {
      if (kIsWeb) {
        return null;
      }
      final isLoggedIn = sl<AuthNotifier>().isLoggedIn;
      final isLoginPage = state.matchedLocation == AppRoutes.login;

      if (!isLoggedIn && !isLoginPage) {
        return AppRoutes.login;
      }

      if (isLoggedIn && isLoginPage) {
        return AppRoutes.overview;
      }

      return null;
    },

    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) {
          return const LoginPage();
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return BlocProvider(
            create: (_) => sl<BuildingStateCubit>()..initBuildingState(),
            child: AppShell(navigationShell: navigationShell),
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.overview,
                builder: (context, state) => const Overview(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.liveMap,
                builder: (context, state) => const LiveMap(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.incidents,
                builder: (context, state) => MultiBlocProvider(
                  providers: [
                    BlocProvider(create: (_) => sl<IncidentsCubit>()),
                    BlocProvider(create: (_) => sl<ReportCubit>()),
                  ],
                  child: const IncidentsPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                builder: (context, state) {
                  return BlocProvider(
                    create: (_) => sl<ProfileCubit>()..fetchProfile(),
                    child: const SettingsPage(),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
