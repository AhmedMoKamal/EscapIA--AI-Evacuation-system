import 'package:escapia/core/constants/app_colors.dart';
import 'package:escapia/core/constants/app_text_styles.dart';
import 'package:escapia/core/utils/context_extension.dart';
import 'package:escapia/features/settings/presentation/cubit/profle_cubit/profile_cubit.dart';
import 'package:escapia/features/settings/presentation/cubit/profle_cubit/profile_state.dart';
import 'package:escapia/features/settings/presentation/widgets/mobile_profile_info_card.dart';
import 'package:escapia/features/settings/presentation/widgets/preference_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsMobilePage extends StatefulWidget {
  const SettingsMobilePage({super.key});

  @override
  State<SettingsMobilePage> createState() => _SettingsMobilePageState();
}

class _SettingsMobilePageState extends State<SettingsMobilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: context.space(16),
            vertical: context.space(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Settings', style: AppTextStyles.font22W700),
              SizedBox(height: context.space(20)),
              BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoading || state is ProfileInitial) {
                    return Container(
                      height: context.space(160),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: const CircularProgressIndicator(
                        color: AppColors.routeBlue,
                      ),
                    );
                  }
                  if (state is ProfileError) {
                    return Container(
                      padding: EdgeInsets.all(context.space(16)),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.font14W400Red,
                          ),
                          SizedBox(height: context.space(10)),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.routeBlue,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              context.read<ProfileCubit>().fetchProfile();
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is ProfileSuccess) {
                    final user = state.profile;
                    return MobileProfileInfoCard(
                      name: user.name,
                      phoneNumber: user.phoneNumber,
                      role: user.role,
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
              SizedBox(height: context.space(20)),
              const PreferencesCard(isWeb: false),
              SizedBox(height: context.space(28)),
              Center(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.darkSurfaceNavy,
                    side: const BorderSide(color: AppColors.dividerBorder),
                    padding: EdgeInsets.symmetric(
                      horizontal: context.space(24),
                      vertical: context.space(10),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'Log Out',
                    style: AppTextStyles.font13W500Primary,
                  ),
                ),
              ),
              SizedBox(height: context.space(24)),
            ],
          ),
        ),
      ),
    );
  }
}
