class ApiConfig {
  // URL de base de l'API
  static const String baseUrl = 'https://alert-app-nc1y.onrender.com/api';

  // Timeout pour les requêtes (augmenté pour Render qui peut être en veille)
  static const Duration requestTimeout = Duration(seconds: 60);

  // Headers par défaut
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Authentication Endpoints
  static const String loginEndpoint = '/users/login/';
  static const String registerEndpoint = '/users/signup/';
  static const String logoutEndpoint = '/auth/logout';
  static const String meEndpoint = '/users/me/';
  static const String refreshEndpoint = '/users/account/refresh/';
  static const String profileEndpoint = '/users/edit-profile/';
  static const String changePasswordEndpoint = '/users/change-password/';
  static const String resetPasswordEndpoint = '/users/reset-password/';
  static const String resetPasswordConfirmEndpoint = '/users/reset-password-confirm/';
  static const String googleLoginEndpoint = '/users/google-login/';

  // User Management Endpoints
  static const String usersEndpoint = '/users/';
  static const String usersAllEndpoint = '/users/all/';
  static const String usersPaginationEndpoint = '/users/pagination/';
  static const String userDetailEndpoint = '/users/{id}/';

  // Alert Endpoints (corrigé: /alert/ au lieu de /alerts/)
  static const String alertsEndpoint = '/alert/';
  static const String alertDetailEndpoint = '/alert/{id}/';
  static const String alertTypesEndpoint = '/alert/types/';
  static const String alertTypeDetailEndpoint = '/alert/types/{id}/';
  static const String createAlertEndpoint = '/alert/create/';

  // Mission Endpoints
  static const String missionsEndpoint = '/missions/';
  static const String missionDetailEndpoint = '/missions/{id}/';
  static const String missionLogsEndpoint = '/missions/{id}/logs/';

  // Notification Endpoints
  static const String notificationsEndpoint = '/notifications/';
  static const String notificationCountEndpoint = '/notifications/unread_count/';

  // Clés de stockage local
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String isAuthenticatedKey = 'is_authenticated';

  // Messages d'erreur
  static const String networkErrorMessage = 'Erreur de connexion réseau. Vérifiez votre connexion internet.';
  static const String serverErrorMessage = 'Erreur du serveur. Veuillez réessayer plus tard.';
  static const String timeoutErrorMessage = 'Délai d\'attente dépassé. Veuillez réessayer.';
  static const String unknownErrorMessage = 'Erreur inattendue. Veuillez réessayer.';

  // Messages de succès
  static const String loginSuccessMessage = 'Connexion réussie';
  static const String registerSuccessMessage = 'Inscription réussie. Vous pouvez maintenant vous connecter.';
  static const String logoutSuccessMessage = 'Déconnexion réussie';
  static const String profileUpdateSuccessMessage = 'Profil mis à jour avec succès';

  // Validation
  static const int minPasswordLength = 6;
  static const String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
}
