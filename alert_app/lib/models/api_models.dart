import 'package:json_annotation/json_annotation.dart';

part 'api_models.g.dart';

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
class User {
  final String id;
  final String email;
  final String role;
  final String firstname;
  final String lastname;
  final String? middlename;
  final String? telephone;
  @JsonKey(name: 'get_avatar')
  final String? getAvatar;
  @JsonKey(name: 'is_active')
  final bool isActive;

  User({
    required this.id,
    required this.email,
    required this.role,
    required this.firstname,
    required this.lastname,
    this.middlename,
    this.telephone,
    this.getAvatar,
    required this.isActive,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  String get fullName => '$firstname $lastname';
}

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
class SignupResponse {
  final String id;
  final String email;
  final String role;
  final String firstname;
  final String lastname;
  final String? middlename;
  final String? telephone;
  @JsonKey(name: 'get_avatar')
  final String? getAvatar;
  @JsonKey(name: 'is_active')
  final bool isActive;

  SignupResponse({
    required this.id,
    required this.email,
    required this.role,
    required this.firstname,
    required this.lastname,
    this.middlename,
    this.telephone,
    this.getAvatar,
    required this.isActive,
  });

  factory SignupResponse.fromJson(Map<String, dynamic> json) =>
      _$SignupResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SignupResponseToJson(this);
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
