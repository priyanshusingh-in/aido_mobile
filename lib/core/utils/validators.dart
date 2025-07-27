import '../constants/app_constants.dart';

class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < AppConstants.minPasswordLength) {
      return 'Password must be at least ${AppConstants.minPasswordLength} characters';
    }
    
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    
    if (value != password) {
      return 'Passwords do not match';
    }
    
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    
    return null;
  }

  static String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Title is required';
    }
    
    if (value.length > AppConstants.maxTitleLength) {
      return 'Title must be less than ${AppConstants.maxTitleLength} characters';
    }
    
    return null;
  }

  static String? validateDescription(String? value) {
    if (value != null && value.length > AppConstants.maxDescriptionLength) {
      return 'Description must be less than ${AppConstants.maxDescriptionLength} characters';
    }
    
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    
    return null;
  }

  static String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Date is required';
    }
    
    try {
      final date = DateTime.parse(value);
      if (date.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
        return 'Date cannot be in the past';
      }
    } catch (e) {
      return 'Please enter a valid date';
    }
    
    return null;
  }

  static String? validateTime(String? value) {
    if (value == null || value.isEmpty) {
      return 'Time is required';
    }
    
    final timeRegex = RegExp(r'^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$');
    if (!timeRegex.hasMatch(value)) {
      return 'Please enter a valid time (HH:MM)';
    }
    
    return null;
  }

  static String? validateDuration(String? value) {
    if (value != null && value.isNotEmpty) {
      final duration = int.tryParse(value);
      if (duration == null || duration <= 0) {
        return 'Duration must be a positive number';
      }
      if (duration > 1440) { // 24 hours in minutes
        return 'Duration cannot exceed 24 hours';
      }
    }
    
    return null;
  }
}