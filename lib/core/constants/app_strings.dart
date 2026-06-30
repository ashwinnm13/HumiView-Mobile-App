/// HumiView — UI Strings
///
/// Centralized strings for consistency and future localization.
class AppStrings {
  AppStrings._();

  // ─── App ───
  static const String appName = 'HumiView';
  static const String tagline = 'Precision Environmental Monitoring for Healthcare';

  // ─── Splash ───
  static const String splashSecure = 'Secure Healthcare Monitoring';
  static const String splashLoading = 'Initializing secure environment...';

  // ─── Auth ───
  static const String login = 'Login';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String rememberMe = 'Remember me';
  static const String forgotPassword = 'Forgot Password?';
  static const String signUp = 'Sign Up';
  static const String welcomeBack = 'Welcome Back';
  static const String loginSubtitle = 'Sign in to continue monitoring';
  static const String emailHint = 'doctor@hospital.com';
  static const String passwordHint = 'Enter your password';
  static const String emailRequired = 'Email is required';
  static const String emailInvalid = 'Enter a valid email';
  static const String passwordRequired = 'Password is required';
  static const String passwordTooShort = 'Password must be at least 6 characters';

  // ─── Dashboard ───
  static const String patients = 'Patients';
  static const String alerts = 'Alerts';
  static const String analytics = 'Analytics';
  static const String profile = 'Profile';
  static const String addDevice = 'Add Device';
  static const String searchPatients = 'Search patients...';
  static const String allPatients = 'All';
  static const String criticalFilter = 'Critical';
  static const String warningFilter = 'Warning';
  static const String stableFilter = 'Stable';
  static const String offlineFilter = 'Offline';

  // ─── Patient ───
  static const String room = 'Room';
  static const String deviceId = 'Device';
  static const String lastSync = 'Last Sync';

  // ─── Metrics ───
  static const String temperature = 'Temperature';
  static const String relativeHumidity = 'Relative Humidity';
  static const String absoluteHumidity = 'Absolute Humidity';
  static const String signalStrength = 'Signal';
  static const String heaterStatus = 'Heater';
  static const String history = 'History';

  // ─── Units ───
  static const String celsius = '°C';
  static const String percent = '%';
  static const String gPerM3 = 'g/m³';
  static const String dBm = 'dBm';

  // ─── Patient History ───
  static const String patientHistory = 'Patient History';
  static const String avgTemperature = 'Avg Temperature';
  static const String avgRelativeHumidity = 'Avg Relative Humidity';
  static const String avgAbsoluteHumidity = 'Avg Absolute Humidity';
  static const String heaterActivity = 'Heater Activity';
  static const String alertHistory = 'Alert History';
  static const String noHistoryData = 'No history data available for this time range.';

  // ─── Monitoring ───
  static const String liveMonitoring = 'Live Monitoring';
  static const String temperatureTrend = 'Temperature Trend';
  static const String rhTrend = 'Relative Humidity Trend';
  static const String ahTrend = 'Absolute Humidity Trend';
  static const String pause = 'Pause';
  static const String resume = 'Resume';
  static const String zoom = 'Zoom';
  static const String timeRange = 'Time Range';

  // ─── Heater ───
  static const String heaterControl = 'Heater Control';
  static const String condensationPrevention = 'Condensation Prevention';
  static const String mode = 'Mode';
  static const String autoMode = 'Auto';
  static const String manualMode = 'Manual';
  static const String cycleInfo = 'Cycle: Every 30 min → ON for 20 sec';
  static const String nextCycle = 'Next Cycle';
  static const String runtime = 'Runtime';
  static const String idle = 'Idle';
  static const String active = 'Active';

  // ─── Alerts ───
  static const String alertCenter = 'Alert Center';
  static const String notifications = 'Notifications';
  static const String acknowledge = 'Acknowledge';
  static const String dismiss = 'Dismiss';
  static const String markAllRead = 'Mark All as Read';
  static const String today = 'Today';
  static const String yesterday = 'Yesterday';
  static const String earlier = 'Earlier';
  static const String critical = 'Critical';
  static const String warning = 'Warning';
  static const String info = 'Info';

  // ─── Analytics ───
  static const String dailyTrends = 'Daily Trends';
  static const String weeklyReports = 'Weekly Reports';
  static const String connectionStability = 'Connection Stability';
  static const String heaterRuntime = 'Heater Runtime';
  static const String export = 'Export';

  // ─── Profile ───
  static const String settings = 'Settings';
  static const String connectedDevices = 'Connected Devices';
  static const String themeToggle = 'Theme';
  static const String about = 'About';
  static const String logout = 'Logout';
  static const String logoutConfirm = 'Are you sure you want to logout?';
  static const String appVersion = 'Version 1.0.0';

  // ─── Empty States ───
  static const String noPatients = 'No patients connected';
  static const String noPatientsDesc = 'Add a device to start monitoring';
  static const String noConnection = 'No connection';
  static const String noConnectionDesc = 'Check your network and try again';
  static const String noAlerts = 'No alerts';
  static const String noAlertsDesc = 'All systems operating normally';
  static const String serverError = 'Server error';
  static const String serverErrorDesc = 'Something went wrong. Please try again later.';
  static const String offlineMode = 'Offline mode';
  static const String offlineModeDesc = 'Displaying cached data. Reconnecting...';

  // ─── Status ───
  static const String online = 'Online';
  static const String offline = 'Offline';
  static const String stable = 'Stable';
  static const String connecting = 'Connecting';

  // ─── Greetings ───
  static String greeting(String name) {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning, $name';
    if (hour < 17) return 'Good Afternoon, $name';
    return 'Good Evening, $name';
  }
}
