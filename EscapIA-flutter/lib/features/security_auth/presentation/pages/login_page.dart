import 'package:escapia/core/constants/app_assets.dart';
import 'package:escapia/core/constants/app_colors.dart';
import 'package:escapia/core/constants/app_text_styles.dart';
import 'package:escapia/core/di/injection_container.dart';
import 'package:escapia/core/utils/auth_notifier.dart';
import 'package:escapia/core/utils/context_extension.dart';
import 'package:escapia/features/security_auth/presentation/cubit/security_auth_cubit.dart';
import 'package:escapia/features/security_auth/presentation/cubit/security_auth_state.dart';
import 'package:escapia/features/security_auth/presentation/widgets/cutsom_text_filed.dart';
import 'package:escapia/features/security_auth/presentation/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validatePhoneNumber(String? value) {
    final phoneNumber = value?.trim() ?? '';
    if (phoneNumber.isEmpty) {
      return 'Please enter your phone number';
    }
    if (phoneNumber.length < 11) {
      return 'Phone number must be at least 11 characters';
    }
    if (!RegExp(r'^\d+$').hasMatch(phoneNumber)) {
      return 'Phone number must contain only digits';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) {
      return 'Please enter your password';
    }
    if (password.length < 7) {
      return 'Password must be at least 7 characters';
    }
    return null;
  }

  void _submitLogin(BuildContext context) {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    context.read<AuthCubit>().login(
      phoneNumber: _phoneController.text.trim(),
      password: _passwordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(
              SnackBar(
                backgroundColor: AppColors.fireRed,
                content: Text(
                  '${state.type}: ${state.message}',
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
              ),
            );
          }

          if (state is AuthSuccess) {
            FocusManager.instance.primaryFocus?.unfocus();

            sl<AuthNotifier>().login();
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Stack(
                children: [
                  Container(
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
                  ),
                  SafeArea(
                    bottom: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.space(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: context.space(36)),
                              Image.asset(
                                AppAssets.escapiaLogoTransparent,
                                height: context.space(90),
                                width: context.space(90),
                              ),
                              SizedBox(height: context.space(16)),
                              const Text(
                                'Welcome back!',
                                style: AppTextStyles.font26W700,
                              ),
                              SizedBox(height: context.space(8)),
                              const Text(
                                'Please enter your credentials to\naccess your account',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 15,
                                  height: 1.45,
                                ),
                              ),
                              SizedBox(height: context.space(52)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(context.space(10)),
                              topRight: Radius.circular(context.space(10)),
                            ),
                            child: Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  color: AppColors.cardBorder,
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  width: context.space(350),
                                  height: context.space(350),
                                  child: Image.asset(
                                    AppAssets.quarterCircles,
                                    fit: BoxFit.contain,
                                    alignment: Alignment.bottomRight,
                                  ),
                                ),
                                SingleChildScrollView(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: context.space(20),
                                    vertical: context.space(28),
                                  ),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        CustomTextField(
                                          controller: _phoneController,
                                          label: 'Phone Number',
                                          keyboardType: TextInputType.phone,
                                          validator: _validatePhoneNumber,
                                        ),
                                        SizedBox(height: context.space(16)),
                                        CustomTextField(
                                          controller: _passwordController,
                                          label: 'Password',
                                          obscureText: true,
                                          validator: _validatePassword,
                                        ),
                                        SizedBox(height: context.space(32)),
                                        PrimaryButton(
                                          label: isLoading
                                              ? 'Logging in...'
                                              : 'Login',
                                          onPressed: isLoading
                                              ? null
                                              : () => _submitLogin(context),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
