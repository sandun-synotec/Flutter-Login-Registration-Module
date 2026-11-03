class AppStrings {
  AppStrings._();

  // App Identity
  static const String appName = 'Authify';
  static const String appTagline = 'Secure, Simple & Seamless Authentication';

  // Login Screen
  static const String loginTitle = 'Welcome Back';
  static const String loginSubtitle = 'Sign in to access your dashboard and continue';
  static const String emailOrMobileLabel = 'Email or Mobile Number';
  static const String emailOrMobileHint = 'name@example.com or 0771234567';
  static const String passwordLabel = 'Password';
  static const String passwordHint = 'Enter your password';
  static const String rememberMe = 'Remember me';
  static const String forgotPassword = 'Forgot password?';
  static const String signIn = 'Sign In';
  static const String signingIn = 'Signing in...';
  static const String noAccountPrompt = "Don't have an account? ";
  static const String signUpAction = 'Sign Up';

  // Registration Screen
  static const String registerTitle = 'Create Account';
  static const String registerSubtitle = 'Fill in your details to create your secure account';
  static const String fullNameLabel = 'Full Name';
  static const String fullNameHint = 'John Doe';
  static const String emailLabel = 'Email Address';
  static const String emailHint = 'john.doe@example.com';
  static const String mobileLabel = 'Mobile Number';
  static const String mobileHint = '+94 77 123 4567';
  static const String confirmPasswordLabel = 'Confirm Password';
  static const String confirmPasswordHint = 'Re-enter your password';
  static const String register = 'Create Account';
  static const String registering = 'Creating account...';
  static const String alreadyHaveAccountPrompt = 'Already have an account? ';
  static const String signInAction = 'Sign In';

  // Password Rules Checklist
  static const String passwordRequirementHeader = 'Password must contain:';
  static const String ruleMinLength = 'At least 8 characters';
  static const String ruleUppercase = 'At least one uppercase letter (A-Z)';
  static const String ruleLowercase = 'At least one lowercase letter (a-z)';
  static const String ruleNumber = 'At least one number (0-9)';
  static const String ruleSpecial = 'At least one special character (!@#\$%^&*...)';

  // Forgot Password Dialog
  static const String forgotPasswordTitle = 'Reset Password';
  static const String forgotPasswordSubtitle =
      'Enter your registered email address or mobile number to receive password reset instructions.';
  static const String sendResetLink = 'Send Reset Link';
  static const String sendingResetLink = 'Sending...';
  static const String cancel = 'Cancel';

  // Validation Error Messages
  static const String requiredField = 'This field is required';
  static const String invalidIdentifier = 'Enter a valid email address or mobile number';
  static const String invalidEmail = 'Enter a valid email address (e.g. name@example.com)';
  static const String invalidPhone = 'Enter a valid mobile number (e.g. 0771234567 or +94...)';
  static const String nameTooShort = 'Full name must be at least 2 characters';
  static const String nameInvalid = 'Enter a valid full name';
  static const String passwordTooShort = 'Password must be at least 8 characters';
  static const String passwordNotStrong = 'Password does not meet complexity requirements';
  static const String passwordsDoNotMatch = 'Passwords do not match';

  // Home / Dashboard
  static const String welcome = 'Welcome to Authify';
  static const String loggedInAs = 'You are currently authenticated as:';
  static const String logout = 'Sign Out';
  static const String logoutConfirm = 'Are you sure you want to sign out?';
  static const String profile = 'Profile Overview';
}
