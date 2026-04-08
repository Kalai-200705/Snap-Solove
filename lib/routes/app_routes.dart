import 'package:flutter/material.dart';

import '../screens/auth/role_selection_screen.dart';
import '../screens/citizen/citizen_homescreen.dart';
import '../screens/citizen/citizen_login_screen.dart';
import '../screens/citizen/citizen_report_issue_screen.dart';
import '../screens/citizen/forgot_password_screen.dart';
import '../screens/citizen/issue_detail_screen.dart';
import '../screens/citizen/signup_screen.dart';

// ignore: unused_import
import '../screens/employee/employee_login_screen.dart';

Map<String, WidgetBuilder> routes = {
  '/': (context) => RoleSelectionScreen(),

  '/login': (context) => LoginScreen(),

  '/home': (context) => const HomeScreen(),

  '/report-issue': (context) => const CitizenReportIssueScreen(),

  '/issue-detail': (context) {
    final issueType = ModalRoute.of(context)?.settings.arguments as String?;
    return IssueDetailScreen(issueType: issueType ?? "");
  },

  '/employee-login': (context) => const EmployeeLoginScreen(),

  // ✅ ADD THESE
  '/forgot-password': (context) => ForgotPasswordScreen(),
  '/signup': (context) => SignupScreen(),
};
