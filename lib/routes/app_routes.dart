import 'package:flutter/material.dart';

import '../screens/auth/role_selection_screen.dart';
import '../screens/auth/citizen_login_screen.dart';
import '../screens/citizen/dashboard_screen.dart';
import '../screens/citizen/report_issue_screen.dart';
import '../screens/citizen/profile_page.dart';
import '../screens/citizen/track_issue_screen.dart';
import '../screens/citizen/settings_screen.dart';
import '../screens/citizen/notification_screen.dart';
import '../screens/citizen/feedback_screen.dart';
import '../screens/employee/employee_login_screen.dart';

Map<String, WidgetBuilder> routes = {
  '/': (context) => RoleSelectionScreen(),
  '/login': (context) => RoleSelectionScreen(),
  '/citizen-login': (context) => const CitizenLoginScreen(),
  '/home': (context) => const DashboardScreen(),
  '/report-issue': (context) => const ReportIssueScreen(),
  '/profile': (context) => const ProfilePage(),
  '/track-issue': (context) => const TrackIssueScreen(),
  '/settings': (context) => const SettingsScreen(),
  '/notifications': (context) => const NotificationsScreen(),
  '/feedback': (context) => const FeedbackScreen(),
  '/employee-login': (context) => const EmployeeLoginScreen(),
};
