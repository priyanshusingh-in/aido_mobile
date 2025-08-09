import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/theme_constants.dart';
import '../../../../core/utils/validators.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_button.dart';
import '../widgets/animated_background.dart';
import 'register_screen.dart';
import '../../../home/presentation/pages/main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _isFormValid = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            LoginSubmitted(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            ),
          );
    }
  }

  void _updateValidity() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (isValid != _isFormValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const MainScreen()),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          }
        },
        child: Stack(
          children: [
            const Positioned.fill(child: AuthAnimatedBackground()),
            SafeArea(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        // Logo and Brand Section
                        Expanded(
                          flex: 1,
                          child: Container(
                            width: double.infinity,
                            decoration:
                                const BoxDecoration(color: Colors.transparent),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Logo Container
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.schedule,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'AIdo',
                                  style: AppTextStyles.heading1.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -1,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'AI-Powered Scheduling Assistant',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Login Form Section
                        Expanded(
                          flex: 4,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.background.withOpacity(0.82),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(32),
                                topRight: Radius.circular(32),
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(32, 40, 32, 32),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Welcome Text
                                  Text(
                                    'Welcome back',
                                    style: AppTextStyles.heading2.copyWith(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Sign in to your account',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 40),

                                  // Login Form
                                  Form(
                                    key: _formKey,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        // Email Field
                                        AuthTextField(
                                          controller: _emailController,
                                          label: 'Email',
                                          hint: 'you@example.com',
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          prefixIcon: Icons.email_outlined,
                                          validator: Validators.validateEmail,
                                          focusNode: _emailFocusNode,
                                          textInputAction: TextInputAction.next,
                                          autofillHints: const [
                                            AutofillHints.email
                                          ],
                                          autocorrect: false,
                                          onChanged: (_) => _updateValidity(),
                                          onFieldSubmitted: (_) {
                                            _passwordFocusNode.requestFocus();
                                          },
                                        ),
                                        const SizedBox(height: 24),

                                        // Password Field
                                        AuthTextField(
                                          controller: _passwordController,
                                          label: 'Password',
                                          hint: 'Minimum 6 characters',
                                          obscureText: _obscurePassword,
                                          prefixIcon: Icons.lock_outlined,
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _obscurePassword
                                                  ? Icons.visibility_outlined
                                                  : Icons
                                                      .visibility_off_outlined,
                                              color: AppColors.textTertiary,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _obscurePassword =
                                                    !_obscurePassword;
                                              });
                                            },
                                          ),
                                          validator:
                                              Validators.validatePassword,
                                          focusNode: _passwordFocusNode,
                                          textInputAction: TextInputAction.done,
                                          autofillHints: const [
                                            AutofillHints.password
                                          ],
                                          enableSuggestions: false,
                                          autocorrect: false,
                                          onChanged: (_) => _updateValidity(),
                                          onFieldSubmitted: (_) =>
                                              _handleLogin(),
                                        ),
                                        const SizedBox(height: 8),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: TextButton(
                                            onPressed: () {
                                              // TODO: integrate reset password flow
                                            },
                                            child:
                                                const Text('Forgot password?'),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        // Social sign-in removed for minimal UI

                                        // Sign In Button
                                        BlocBuilder<AuthBloc, AuthState>(
                                          builder: (context, state) {
                                            return AuthButton(
                                              text: 'Sign In',
                                              onPressed:
                                                  (state is AuthLoading ||
                                                          !_isFormValid)
                                                      ? null
                                                      : _handleLogin,
                                              isLoading: state is AuthLoading,
                                            );
                                          },
                                        ),
                                        const SizedBox(height: 32),

                                        // Sign Up Link
                                        Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Don't have an account? ",
                                                style: AppTextStyles.bodyMedium
                                                    .copyWith(
                                                  color:
                                                      AppColors.textSecondary,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          const RegisterScreen(),
                                                    ),
                                                  );
                                                },
                                                child: Text(
                                                  'Sign Up',
                                                  style: AppTextStyles
                                                      .bodyMedium
                                                      .copyWith(
                                                    color:
                                                        AppColors.accentLight,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
