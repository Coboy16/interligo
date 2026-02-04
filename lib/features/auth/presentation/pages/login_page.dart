import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/extensions.dart';
import '../bloc/bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _obscurePassword = true;

  void _onLogin() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final values = _formKey.currentState!.value;
      context.read<AuthBloc>().add(
            AuthLoginRequested(
              email: values['email'] as String,
              password: values['password'] as String,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.go(RoutePaths.dashboard);
        } else if (state is AuthError) {
          context.showSnackBar(state.message, isError: true);
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 60.h),
                  // Logo
                  Center(
                    child: Container(
                      width: 80.w,
                      height: 80.w,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Icon(
                        Icons.account_balance,
                        size: 44.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  // Title
                  Text(
                    'Bienvenido',
                    style: AppTypography.displayMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Inicia sesión para continuar',
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 48.h),
                  // Form
                  FormBuilder(
                    key: _formKey,
                    child: Column(
                      children: [
                        FormBuilderTextField(
                          name: 'email',
                          decoration: InputDecoration(
                            labelText: 'Correo electrónico',
                            prefixIcon: const Icon(LucideIcons.mail),
                            hintText: 'ejemplo@correo.com',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                              errorText: 'El correo es requerido',
                            ),
                            FormBuilderValidators.email(
                              errorText: 'Ingresa un correo válido',
                            ),
                          ]),
                        ),
                        SizedBox(height: 20.h),
                        FormBuilderTextField(
                          name: 'password',
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            prefixIcon: const Icon(LucideIcons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? LucideIcons.eyeOff
                                    : LucideIcons.eye,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _onLogin(),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                              errorText: 'La contraseña es requerida',
                            ),
                            FormBuilderValidators.minLength(
                              6,
                              errorText: 'Mínimo 6 caracteres',
                            ),
                          ]),
                        ),
                        SizedBox(height: 12.h),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // TODO: Implement forgot password
                            },
                            child: Text(
                              'Olvidé mi contraseña',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 32.h),
                        SizedBox(
                          width: double.infinity,
                          height: 52.h,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _onLogin,
                            child: isLoading
                                ? SizedBox(
                                    width: 24.w,
                                    height: 24.w,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Text('Iniciar sesión'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  // Demo credentials hint
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColors.info.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: AppColors.info.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              LucideIcons.info,
                              size: 18.sp,
                              color: AppColors.info,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Credenciales de prueba',
                              style: AppTypography.labelLarge.copyWith(
                                color: AppColors.info,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Email: demo@interligo.com\nPassword: demo123',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
