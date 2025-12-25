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

  // Alert Endpoints (corrected from OpenAPI spec)
  static const String alertsMyAlertsEndpoint = '/alert/alerts/my-alerts/';
  static const String alertsAllEndpoint = '/alert/alerts/all/';
  static const String alertCreateEndpoint = '/alert/alerts/create/';
  static const String alertDetailEndpoint = '/alert/alerts/{id}/';
  static const String alertUpdateEndpoint = '/alert/alerts/{id}/update/';
  static const String alertDeleteEndpoint = '/alert/alerts/{id}/delete/';
  static const String alertsEndpoint = '/alert/alerts/';
  static const String alertValidateEndpoint = '/alert/alerts/{id}/validate/';

  // Alert Types Endpoints
  static const String alertTypesEndpoint = '/alert/typealerts/';
  static const String alertTypeListEndpoint = '/alert/typealerts/';
  static const String alertTypeDetailEndpoint = '/alert/typealerts/{id}/';
  static const String alertTypeCreateEndpoint = '/alert/typealerts/';
  static const String alertTypeUpdateEndpoint = '/alert/typealerts/{id}/';
  static const String alertTypeDeleteEndpoint = '/alert/typealerts/{id}/';

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
