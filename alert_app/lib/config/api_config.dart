class ApiConfig {
  // URL de base de l'API
  static const String baseUrl = 'https://alert-app-nc1y.onrender.com/api';
  
  // Timeout pour les requêtes
  static const Duration requestTimeout = Duration(seconds: 30);
  
  // Headers par défaut
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Endpoints
  static const String loginEndpoint = '/users/login/';
  static const String registerEndpoint = '/users/signup/';
  static const String logoutEndpoint = '/auth/logout';
  static const String meEndpoint = '/auth/me';
  static const String refreshEndpoint = '/auth/refresh';
  static const String profileEndpoint = '/users/profile';
  
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
