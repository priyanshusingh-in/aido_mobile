import 'package:flutter/material.dart';

import '../../../../core/constants/theme_constants.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final FocusNode? focusNode;
  final TextInputAction textInputAction;
  final Iterable<String>? autofillHints;
  final void Function(String)? onFieldSubmitted;
  final TextCapitalization textCapitalization;
  final bool enableSuggestions;
  final bool enabled;
  final bool autocorrect;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.focusNode,
    this.textInputAction = TextInputAction.next,
    this.autofillHints,
    this.onFieldSubmitted,
    this.textCapitalization = TextCapitalization.none,
    this.enableSuggestions = true,
    this.enabled = true,
    this.autocorrect = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autofillHints: autofillHints,
      onFieldSubmitted: onFieldSubmitted,
      textCapitalization: textCapitalization,
      enableSuggestions: enableSuggestions,
      autocorrect: autocorrect,
      enabled: enabled,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppColors.textTertiary)
            : null,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: AppColors.inputFocusedBorder, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        filled: true,
        fillColor: AppColors.inputBackground,
        hintStyle:
            AppTextStyles.bodyMedium.copyWith(color: AppColors.textTertiary),
        labelStyle:
            AppTextStyles.bodyMedium.copyWith(color: AppColors.textTertiary),
      ),
      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
    );
  }
}
