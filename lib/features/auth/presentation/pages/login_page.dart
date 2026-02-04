import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

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
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 48.h),
                    // Header con logo
                    _buildHeader(),
                    SizedBox(height: 48.h),
                    // Formulario
                    _buildForm(isLoading),
                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Logo minimalista
        Container(
          width: 88.w,
          height: 88.w,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(
            Icons.account_balance_rounded,
            size: 44.sp,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 32.h),
        // Título
        Text(
          'Bienvenido',
          style: AppTypography.displayMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Inicia sesión para continuar',
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildForm(bool isLoading) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FormBuilder(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Campo de email
            Text(
              'Correo electrónico',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            FormBuilderTextField(
              name: 'email',
              decoration: InputDecoration(
                hintText: 'ejemplo@correo.com',
                prefixIcon: Icon(
                  LucideIcons.mail,
                  color: AppColors.textTertiary,
                  size: 20.sp,
                ),
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
            // Campo de contraseña
            Text(
              'Contraseña',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            FormBuilderTextField(
              name: 'password',
              decoration: InputDecoration(
                hintText: '••••••••',
                prefixIcon: Icon(
                  LucideIcons.lock,
                  color: AppColors.textTertiary,
                  size: 20.sp,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? LucideIcons.eyeOff : LucideIcons.eye,
                    color: AppColors.textTertiary,
                    size: 20.sp,
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
            SizedBox(height: 8.h),
            // Olvidé mi contraseña
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // TODO: Implement forgot password
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                ),
                child: Text(
                  'Olvidé mi contraseña',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            // Botón de login
            SizedBox(
              height: 56.h,
              child: ElevatedButton(
                onPressed: isLoading ? null : _onLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                child: isLoading
                    ? SizedBox(
                        width: 24.w,
                        height: 24.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Text(
                        'Iniciar sesión',
                        style: AppTypography.labelLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
