import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/theme_constants.dart';
import '../../../../core/utils/validators.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_button.dart';
import '../widgets/animated_background.dart';
import '../../../home/presentation/pages/main_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  bool _agreeToTerms = false;
  double _passwordStrength = 0.0;
  bool _isFormValid = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            RegisterSubmitted(
              email: _emailController.text.trim(),
              password: _passwordController.text,
              firstName: _firstNameController.text.trim(),
              lastName: _lastNameController.text.trim(),
            ),
          );
    }
  }

  void _updatePasswordStrength(String value) {
    double strength = 0.0;
    if (value.length >= 6) strength += 0.25;
    if (RegExp(r"[A-Z]").hasMatch(value)) strength += 0.25;
    if (RegExp(r"[0-9]").hasMatch(value)) strength += 0.25;
    if (RegExp(r"[^A-Za-z0-9]").hasMatch(value)) strength += 0.25;
    setState(() {
      _passwordStrength = strength.clamp(0.0, 1.0);
    });
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
              ),
            );
          }
        },
        child: Stack(
          children: [
            const Positioned.fill(child: AuthAnimatedBackground()),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 24),
                      child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Icon(
                              Icons.person_add_outlined,
                              size: 64,
                              color: AppColors.primary,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Create your account',
                              style: AppTextStyles.heading2,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Join AIdo today',
                              style: AppTextStyles.bodySmall,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 32),
                            Row(
                              children: [
                                Expanded(
                                  child: AuthTextField(
                                    controller: _firstNameController,
                                    label: 'First Name',
                                    prefixIcon: Icons.person_outlined,
                                    validator: Validators.validateName,
                                    focusNode: _firstNameFocus,
                                    textInputAction: TextInputAction.next,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    autofillHints: const [
                                      AutofillHints.givenName
                                    ],
                                    onFieldSubmitted: (_) =>
                                        _lastNameFocus.requestFocus(),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: AuthTextField(
                                    controller: _lastNameController,
                                    label: 'Last Name',
                                    prefixIcon: Icons.person_outlined,
                                    validator: Validators.validateName,
                                    focusNode: _lastNameFocus,
                                    textInputAction: TextInputAction.next,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    autofillHints: const [
                                      AutofillHints.familyName
                                    ],
                                    onFieldSubmitted: (_) =>
                                        _emailFocus.requestFocus(),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            AuthTextField(
                              controller: _emailController,
                              label: 'Email',
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Icons.email_outlined,
                              validator: Validators.validateEmail,
                              focusNode: _emailFocus,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.email],
                              onChanged: (_) => _updateValidity(),
                              onFieldSubmitted: (_) =>
                                  _passwordFocus.requestFocus(),
                            ),
                            const SizedBox(height: 16),
                            AuthTextField(
                              controller: _passwordController,
                              label: 'Password',
                              obscureText: _obscurePassword,
                              prefixIcon: Icons.lock_outlined,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              validator: Validators.validatePassword,
                              focusNode: _passwordFocus,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.newPassword],
                              enableSuggestions: false,
                              autocorrect: false,
                              onChanged: (v) {
                                _updatePasswordStrength(v);
                                _updateValidity();
                              },
                              onFieldSubmitted: (_) =>
                                  _confirmPasswordFocus.requestFocus(),
                            ),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: _passwordStrength,
                              backgroundColor: AppColors.inputBackground,
                              color: _passwordStrength < 0.5
                                  ? AppColors.error
                                  : _passwordStrength < 0.75
                                      ? AppColors.warning
                                      : AppColors.success,
                              minHeight: 6,
                            ),
                            const SizedBox(height: 16),
                            AuthTextField(
                              controller: _confirmPasswordController,
                              label: 'Confirm Password',
                              obscureText: _obscureConfirmPassword,
                              prefixIcon: Icons.lock_outlined,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword =
                                        !_obscureConfirmPassword;
                                  });
                                },
                              ),
                              validator: (value) =>
                                  Validators.validateConfirmPassword(
                                value,
                                _passwordController.text,
                              ),
                              focusNode: _confirmPasswordFocus,
                              textInputAction: TextInputAction.done,
                              autofillHints: const [AutofillHints.newPassword],
                              onChanged: (_) => _updateValidity(),
                              onFieldSubmitted: (_) => _handleRegister(),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Checkbox(
                                  value: _agreeToTerms,
                                  onChanged: (v) => setState(() {
                                    _agreeToTerms = v ?? false;
                                  }),
                                ),
                                Expanded(
                                  child: Text(
                                    'I agree to the Terms and Privacy Policy',
                                    style: AppTextStyles.bodySmall,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                final canSubmit = _isFormValid && _agreeToTerms;
                                return AuthButton(
                                  text: 'Create Account',
                                  onPressed:
                                      (state is AuthLoading || !canSubmit)
                                          ? null
                                          : _handleRegister,
                                  isLoading: state is AuthLoading,
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            // Social sign-up removed for minimal UI
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                  'Already have an account? Sign In'),
                            ),
                          ],
                        ), // end Column
                      ), // end Form
                    ), // end Padding
                  ), // end Card
                ), // end SingleChildScrollView
              ), // end Center
            ), // end SafeArea
          ],
        ), // end Stack
      ), // end BlocListener
    ); // end Scaffold
  }
}
