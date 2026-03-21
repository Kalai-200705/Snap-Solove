import 'package:flutter/material.dart';
import '../screens/auth/role_selection_screen.dart';
import '../screens/employee/employee_login_screen.dart';
import '../screens/employee/employee_dashboard.dart';
import '../screens/auth/login_screen.dart';
import '../screens/citizen/dashboard_screen.dart';
import '../screens/citizen/report_issue_screen.dart';
import '../screens/government/government_login_screen.dart';
import '../screens/government/government_dashboard.dart';
import '../screens/government/map_view_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
  '/': (context) => const RoleSelectionScreen(),

  '/login': (context) => const LoginScreen(),
  '/dashboard': (context) => const DashboardScreen(),
  '/report': (context) => const ReportIssueScreen(),

  '/employee-login': (context) => const EmployeeLoginScreen(),
  '/employee-dashboard': (context) => const EmployeeDashboard(),

  // ✅ ADD THIS
  '/government-login': (context) => const GovernmentLoginScreen(),
  '/government-dashboard': (context) => const GovernmentDashboard(),
   '/map-view': (context) => const MapViewScreen(),
};
}
