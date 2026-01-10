import 'package:json_annotation/json_annotation.dart';

part 'api_models.g.dart';

// Enums
enum StatusEnum {
  @JsonValue('New')
  new_,
  @JsonValue('Validated')
  validated,
  @JsonValue('Rejected')
  rejected,
  @JsonValue('In Progress')
  inProgress,
  @JsonValue('Resolved')
  resolved,
  @JsonValue('Closed')
  closed,
}

enum RoleEnum {
  @JsonValue('Admin')
  admin,
  @JsonValue('Operator')
  operator,
  @JsonValue('User')
  user,
}

// Authentication Models
@JsonSerializable()
class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

@JsonSerializable()
class LoginResponse {
  final TokenData token;
  final User user;

  LoginResponse({
    required this.token,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable()
class TokenData {
  final String refresh;
  final String access;

  TokenData({
    required this.refresh,
    required this.access,
  });

  factory TokenData.fromJson(Map<String, dynamic> json) =>
      _$TokenDataFromJson(json);

  Map<String, dynamic> toJson() => _$TokenDataToJson(this);
}

@JsonSerializable()
class TokenRefresh {
  final String access;
  final String refresh;

  TokenRefresh({
    required this.access,
    required this.refresh,
  });

  factory TokenRefresh.fromJson(Map<String, dynamic> json) =>
      _$TokenRefreshFromJson(json);

  Map<String, dynamic> toJson() => _$TokenRefreshToJson(this);
}

// User Models
@JsonSerializable()
class User {
  final String id;
  final String email;
  final RoleEnum role;
  final String? firstname;
  final String? lastname;
  final String? middlename;
  final String? telephone;
  @JsonKey(name: 'get_avatar')
  final String getAvatar;
  @JsonKey(name: 'is_active')
  final bool isActive;

  User({
    required this.id,
    required this.email,
    required this.role,
    this.firstname,
    this.lastname,
    this.middlename,
    this.telephone,
    required this.getAvatar,
    required this.isActive,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      role: _parseRoleEnum(json['role'] as String),
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
      middlename: json['middlename'] as String?,
      telephone: json['telephone'] as String?,
      getAvatar: json['get_avatar'] as String,
      isActive: json['is_active'] as bool,
    );
  }

  Map<String, dynamic> toJson() => _$UserToJson(this);

  String get fullName => '${firstname ?? ''} ${lastname ?? ''}'.trim();

  static RoleEnum _parseRoleEnum(String role) {
    switch (role) {
      case 'Admin':
        return RoleEnum.admin;
      case 'Operator':
        return RoleEnum.operator;
      case 'User':
      default:
        return RoleEnum.user;
    }
  }
}

@JsonSerializable()
class UserPagination {
  final int pageCourante;
  final int totalPages;
  final int totalElements;
  final List<User> pages;

  UserPagination({
    required this.pageCourante,
    required this.totalPages,
    required this.totalElements,
    required this.pages,
  });

  factory UserPagination.fromJson(Map<String, dynamic> json) =>
      _$UserPaginationFromJson(json);

  Map<String, dynamic> toJson() => _$UserPaginationToJson(this);
}

// Alert Models
@JsonSerializable()
class TypeAlert {
  final String id;
  final String? name;
  final String? description;
  final String? slug;

  TypeAlert({
    required this.id,
    this.name,
    this.description,
    this.slug,
  });

  factory TypeAlert.fromJson(Map<String, dynamic> json) =>
      _$TypeAlertFromJson(json);

  Map<String, dynamic> toJson() => _$TypeAlertToJson(this);
}

@JsonSerializable()
class AlertMedia {
  final String id;
  final String file;
  final DateTime uploadedAt;

  AlertMedia({
    required this.id,
    required this.file,
    required this.uploadedAt,
  });

  factory AlertMedia.fromJson(Map<String, dynamic> json) =>
      _$AlertMediaFromJson(json);

  Map<String, dynamic> toJson() => _$AlertMediaToJson(this);
}

@JsonSerializable()
class Alert {
  final String id;
  final TypeAlert type;
  final User user;
  final String? description;
  final double? latitude;
  final double? longitude;
  final StatusEnum status;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  final List<AlertMedia> medias;

  Alert({
    required this.id,
    required this.type,
    required this.user,
    this.description,
    this.latitude,
    this.longitude,
    required this.status,
    required this.createdAt,
    required this.medias,
  });

  factory Alert.fromJson(Map<String, dynamic> json) => _$AlertFromJson(json);

  Map<String, dynamic> toJson() => _$AlertToJson(this);
}

@JsonSerializable()
class CreateAlertRequest {
  final String type;
  final String description;
  final double? latitude;
  final double? longitude;
  final List<String>? medias;

  CreateAlertRequest({
    required this.type,
    required this.description,
    this.latitude,
    this.longitude,
    this.medias,
  });

  factory CreateAlertRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateAlertRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateAlertRequestToJson(this);
}

// Mission Models (based on API endpoints)
@JsonSerializable()
class Mission {
  final String id;
  final String? alertId;
  final String? operatorId;
  final String? status;
  final DateTime? createdAt;
  final DateTime? finishedAt;

  Mission({
    required this.id,
    this.alertId,
    this.operatorId,
    this.status,
    this.createdAt,
    this.finishedAt,
  });

  factory Mission.fromJson(Map<String, dynamic> json) => _$MissionFromJson(json);

  Map<String, dynamic> toJson() => _$MissionToJson(this);
}

@JsonSerializable()
class MissionLog {
  final String id;
  final String missionId;
  final String userId;
  final String message;
  final DateTime createdAt;

  MissionLog({
    required this.id,
    required this.missionId,
    required this.userId,
    required this.message,
    required this.createdAt,
  });

  factory MissionLog.fromJson(Map<String, dynamic> json) =>
      _$MissionLogFromJson(json);

  Map<String, dynamic> toJson() => _$MissionLogToJson(this);
}

// Notification Models
@JsonSerializable()
class NotificationCount {
  final int unreadCount;

  NotificationCount({
    required this.unreadCount,
  });

  factory NotificationCount.fromJson(Map<String, dynamic> json) =>
      _$NotificationCountFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationCountToJson(this);
}

// Error Models
@JsonSerializable()
class ApiError {
  final String message;
  final String? detail;
  final int? statusCode;

  ApiError({
    required this.message,
    this.detail,
    this.statusCode,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorFromJson(json);

  Map<String, dynamic> toJson() => _$ApiErrorToJson(this);
}

@JsonSerializable()
class ServerError {
  final String message;

  ServerError({
    required this.message,
  });

  factory ServerError.fromJson(Map<String, dynamic> json) =>
      _$ServerErrorFromJson(json);

  Map<String, dynamic> toJson() => _$ServerErrorToJson(this);
}

@JsonSerializable()
class TypeAlertNotFound {
  final String message;

  TypeAlertNotFound({
    required this.message,
  });

  factory TypeAlertNotFound.fromJson(Map<String, dynamic> json) =>
      _$TypeAlertNotFoundFromJson(json);

  Map<String, dynamic> toJson() => _$TypeAlertNotFoundToJson(this);
}

@JsonSerializable()
class TypeAlertCreateError {
  final String message;

  TypeAlertCreateError({
    required this.message,
  });

  factory TypeAlertCreateError.fromJson(Map<String, dynamic> json) =>
      _$TypeAlertCreateErrorFromJson(json);

  Map<String, dynamic> toJson() => _$TypeAlertCreateErrorToJson(this);
}

@JsonSerializable()
class TypeAlertUpdateError {
  final String message;

  TypeAlertUpdateError({
    required this.message,
  });

  factory TypeAlertUpdateError.fromJson(Map<String, dynamic> json) =>
      _$TypeAlertUpdateErrorFromJson(json);

  Map<String, dynamic> toJson() => _$TypeAlertUpdateErrorToJson(this);
}

@JsonSerializable()
class UpdateError {
  final String message;

  UpdateError({
    required this.message,
  });

  factory UpdateError.fromJson(Map<String, dynamic> json) =>
      _$UpdateErrorFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateErrorToJson(this);
}

@JsonSerializable()
class LoginError {
  final String message;

  LoginError({
    required this.message,
  });

  factory LoginError.fromJson(Map<String, dynamic> json) =>
      _$LoginErrorFromJson(json);

  Map<String, dynamic> toJson() => _$LoginErrorToJson(this);
}

@JsonSerializable()
class SignupError {
  final String message;

  SignupError({
    required this.message,
  });

  factory SignupError.fromJson(Map<String, dynamic> json) =>
      _$SignupErrorFromJson(json);

  Map<String, dynamic> toJson() => _$SignupErrorToJson(this);
}

@JsonSerializable()
class GoogleLoginRequest {
  final String idToken;

  GoogleLoginRequest({
    required this.idToken,
  });

  factory GoogleLoginRequest.fromJson(Map<String, dynamic> json) =>
      _$GoogleLoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GoogleLoginRequestToJson(this);
}

@JsonSerializable()
class GoogleLoginSuccess {
  final String message;
  final String access;
  final String refresh;
  final User user;

  GoogleLoginSuccess({
    required this.message,
    required this.access,
    required this.refresh,
    required this.user,
  });

  factory GoogleLoginSuccess.fromJson(Map<String, dynamic> json) =>
      _$GoogleLoginSuccessFromJson(json);

  Map<String, dynamic> toJson() => _$GoogleLoginSuccessToJson(this);
}

@JsonSerializable()
class GoogleLoginError {
  final String message;

  GoogleLoginError({
    required this.message,
  });

  factory GoogleLoginError.fromJson(Map<String, dynamic> json) =>
      _$GoogleLoginErrorFromJson(json);

  Map<String, dynamic> toJson() => _$GoogleLoginErrorToJson(this);
}

class SignupResponse {
  final int id;
  final String email;
  final String firstname;
  final String lastname;
  final String? middlename;
  final String? telephone;
  final String role;
  final bool isActive;

  SignupResponse({
    required this.id,
    required this.email,
    required this.firstname,
    required this.lastname,
    this.middlename,
    this.telephone,
    required this.role,
    required this.isActive,
  });

  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    return SignupResponse(
      id: json['id'],
      email: json['email'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      middlename: json['middlename'],
      telephone: json['telephone'],
      role: json['role'],
      isActive: json['is_active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstname': firstname,
      'lastname': lastname,
      'middlename': middlename,
      'telephone': telephone,
      'role': role,
      'is_active': isActive,
    };
  }
}

// Request/Response Models
@JsonSerializable()
class SignupRequest {
  final String email;
  final String password1;
  final String password2;
  final String firstname;
  final String lastname;
  final String? middlename;
  final String? telephone;
  final String role;

  SignupRequest({
    required this.email,
    required this.password1,
    required this.password2,
    required this.firstname,
    required this.lastname,
    this.middlename,
    this.telephone,
    this.role = 'User',
  });

  factory SignupRequest.fromJson(Map<String, dynamic> json) =>
      _$SignupRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SignupRequestToJson(this);
}

@JsonSerializable()
class SignupSuccess {
  final String message;

  SignupSuccess({
    required this.message,
  });

  factory SignupSuccess.fromJson(Map<String, dynamic> json) =>
      _$SignupSuccessFromJson(json);

  Map<String, dynamic> toJson() => _$SignupSuccessToJson(this);
}

@JsonSerializable()
class RegisterRequest {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String? phone;

  RegisterRequest({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    this.phone,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}

@JsonSerializable()
class RegisterResponse {
  final String message;
  final User user;

  RegisterResponse({
    required this.message,
    required this.user,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterResponseToJson(this);
}

@JsonSerializable()
class ChangePasswordRequest {
  final String oldPassword;
  final String newPassword;
  final String confirmPassword;

  ChangePasswordRequest({
    required this.oldPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ChangePasswordRequestToJson(this);
}

@JsonSerializable()
class ResetPasswordRequest {
  final String email;

  ResetPasswordRequest({
    required this.email,
  });

  factory ResetPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ResetPasswordRequestToJson(this);
}

@JsonSerializable()
class ResetPasswordConfirmRequest {
  final int uid;
  final String token;
  final String newPassword;
  final String confirmPassword;

  ResetPasswordConfirmRequest({
    required this.uid,
    required this.token,
    required this.newPassword,
    required this.confirmPassword,
  });

  factory ResetPasswordConfirmRequest.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordConfirmRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ResetPasswordConfirmRequestToJson(this);
}
