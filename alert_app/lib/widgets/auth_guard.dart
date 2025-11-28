import 'package:flutter/material.dart';
import '../services/authentication_service.dart';

/// Role-based guard widget — shows the login page if not authenticated or role mismatch,
/// otherwise shows the protected home.
class RoleGuard extends StatefulWidget {
  final String allowedRole;
  final Widget loginPage;
  final Widget homePage;

  const RoleGuard({super.key, required this.allowedRole, required this.loginPage, required this.homePage});

  @override
  State<RoleGuard> createState() => _RoleGuardState();
}

class _RoleGuardState extends State<RoleGuard> {
  final AuthenticationService _authService = AuthenticationService();
  bool? _isAuthorized;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    try {
      await _authService.initialize();
      final valid = await _authService.verifyToken();
      if (valid && _authService.currentUser?.role == widget.allowedRole) {
        setState(() => _isAuthorized = true);
      } else {
        setState(() => _isAuthorized = false);
      }
    } catch (e) {
      setState(() => _isAuthorized = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isAuthorized == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_isAuthorized == false) {
      return widget.loginPage;
    }

    return widget.homePage;
  }
}
