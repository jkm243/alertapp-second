// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) => LoginRequest(
  email: json['email'] as String,
  password: json['password'] as String,
);

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) =>
    <String, dynamic>{'email': instance.email, 'password': instance.password};

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      token: TokenData.fromJson(json['token'] as Map<String, dynamic>),
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{'token': instance.token, 'user': instance.user};

TokenData _$TokenDataFromJson(Map<String, dynamic> json) => TokenData(
  refresh: json['refresh'] as String,
  access: json['access'] as String,
);

Map<String, dynamic> _$TokenDataToJson(TokenData instance) => <String, dynamic>{
  'refresh': instance.refresh,
  'access': instance.access,
};

TokenRefresh _$TokenRefreshFromJson(Map<String, dynamic> json) => TokenRefresh(
  access: json['access'] as String,
  refresh: json['refresh'] as String,
);

Map<String, dynamic> _$TokenRefreshToJson(TokenRefresh instance) =>
    <String, dynamic>{'access': instance.access, 'refresh': instance.refresh};

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: json['id'] as String,
  email: json['email'] as String,
  role: $enumDecode(_$RoleEnumEnumMap, json['role']),
  firstname: json['firstname'] as String?,
  lastname: json['lastname'] as String?,
  middlename: json['middlename'] as String?,
  telephone: json['telephone'] as String?,
  getAvatar: json['get_avatar'] as String,
  isActive: json['is_active'] as bool,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'role': _$RoleEnumEnumMap[instance.role]!,
  'firstname': instance.firstname,
  'lastname': instance.lastname,
  'middlename': instance.middlename,
  'telephone': instance.telephone,
  'get_avatar': instance.getAvatar,
  'is_active': instance.isActive,
};

const _$RoleEnumEnumMap = {
  RoleEnum.admin: 'Admin',
  RoleEnum.operator: 'Operator',
  RoleEnum.user: 'User',
};

UserPagination _$UserPaginationFromJson(Map<String, dynamic> json) =>
    UserPagination(
      pageCourante: (json['pageCourante'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      totalElements: (json['totalElements'] as num).toInt(),
      pages: (json['pages'] as List<dynamic>)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserPaginationToJson(UserPagination instance) =>
    <String, dynamic>{
      'pageCourante': instance.pageCourante,
      'totalPages': instance.totalPages,
      'totalElements': instance.totalElements,
      'pages': instance.pages,
    };

TypeAlert _$TypeAlertFromJson(Map<String, dynamic> json) => TypeAlert(
  id: json['id'] as String,
  name: json['name'] as String?,
  description: json['description'] as String?,
  slug: json['slug'] as String?,
);

Map<String, dynamic> _$TypeAlertToJson(TypeAlert instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'slug': instance.slug,
};

AlertMedia _$AlertMediaFromJson(Map<String, dynamic> json) => AlertMedia(
  id: json['id'] as String,
  file: json['file'] as String,
  uploadedAt: DateTime.parse(json['uploadedAt'] as String),
);

Map<String, dynamic> _$AlertMediaToJson(AlertMedia instance) =>
    <String, dynamic>{
      'id': instance.id,
      'file': instance.file,
      'uploadedAt': instance.uploadedAt.toIso8601String(),
    };

Alert _$AlertFromJson(Map<String, dynamic> json) => Alert(
  id: json['id'] as String,
  type: TypeAlert.fromJson(json['type'] as Map<String, dynamic>),
  user: User.fromJson(json['user'] as Map<String, dynamic>),
  description: json['description'] as String?,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  status: $enumDecode(_$StatusEnumEnumMap, json['status']),
  createdAt: DateTime.parse(json['createdAt'] as String),
  medias: (json['medias'] as List<dynamic>)
      .map((e) => AlertMedia.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$AlertToJson(Alert instance) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'user': instance.user,
  'description': instance.description,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'status': _$StatusEnumEnumMap[instance.status]!,
  'createdAt': instance.createdAt.toIso8601String(),
  'medias': instance.medias,
};

const _$StatusEnumEnumMap = {
  StatusEnum.new_: 'New',
  StatusEnum.validated: 'Validated',
  StatusEnum.rejected: 'Rejected',
  StatusEnum.inProgress: 'In Progress',
  StatusEnum.resolved: 'Resolved',
  StatusEnum.closed: 'Closed',
};

CreateAlertRequest _$CreateAlertRequestFromJson(Map<String, dynamic> json) =>
    CreateAlertRequest(
      type: json['type'] as String,
      description: json['description'] as String,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      medias: (json['medias'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$CreateAlertRequestToJson(CreateAlertRequest instance) =>
    <String, dynamic>{
      'type': instance.type,
      'description': instance.description,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'medias': instance.medias,
    };

Mission _$MissionFromJson(Map<String, dynamic> json) => Mission(
  id: json['id'] as String,
  alertId: json['alertId'] as String?,
  operatorId: json['operatorId'] as String?,
  status: json['status'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  finishedAt: json['finishedAt'] == null
      ? null
      : DateTime.parse(json['finishedAt'] as String),
);

Map<String, dynamic> _$MissionToJson(Mission instance) => <String, dynamic>{
  'id': instance.id,
  'alertId': instance.alertId,
  'operatorId': instance.operatorId,
  'status': instance.status,
  'createdAt': instance.createdAt?.toIso8601String(),
  'finishedAt': instance.finishedAt?.toIso8601String(),
};

MissionLog _$MissionLogFromJson(Map<String, dynamic> json) => MissionLog(
  id: json['id'] as String,
  missionId: json['missionId'] as String,
  userId: json['userId'] as String,
  message: json['message'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$MissionLogToJson(MissionLog instance) =>
    <String, dynamic>{
      'id': instance.id,
      'missionId': instance.missionId,
      'userId': instance.userId,
      'message': instance.message,
      'createdAt': instance.createdAt.toIso8601String(),
    };

NotificationCount _$NotificationCountFromJson(Map<String, dynamic> json) =>
    NotificationCount(unreadCount: (json['unreadCount'] as num).toInt());

Map<String, dynamic> _$NotificationCountToJson(NotificationCount instance) =>
    <String, dynamic>{'unreadCount': instance.unreadCount};

ApiError _$ApiErrorFromJson(Map<String, dynamic> json) => ApiError(
  message: json['message'] as String,
  detail: json['detail'] as String?,
  statusCode: (json['statusCode'] as num?)?.toInt(),
);

Map<String, dynamic> _$ApiErrorToJson(ApiError instance) => <String, dynamic>{
  'message': instance.message,
  'detail': instance.detail,
  'statusCode': instance.statusCode,
};

ServerError _$ServerErrorFromJson(Map<String, dynamic> json) =>
    ServerError(message: json['message'] as String);

Map<String, dynamic> _$ServerErrorToJson(ServerError instance) =>
    <String, dynamic>{'message': instance.message};

TypeAlertNotFound _$TypeAlertNotFoundFromJson(Map<String, dynamic> json) =>
    TypeAlertNotFound(message: json['message'] as String);

Map<String, dynamic> _$TypeAlertNotFoundToJson(TypeAlertNotFound instance) =>
    <String, dynamic>{'message': instance.message};

TypeAlertCreateError _$TypeAlertCreateErrorFromJson(
  Map<String, dynamic> json,
) => TypeAlertCreateError(message: json['message'] as String);

Map<String, dynamic> _$TypeAlertCreateErrorToJson(
  TypeAlertCreateError instance,
) => <String, dynamic>{'message': instance.message};

TypeAlertUpdateError _$TypeAlertUpdateErrorFromJson(
  Map<String, dynamic> json,
) => TypeAlertUpdateError(message: json['message'] as String);

Map<String, dynamic> _$TypeAlertUpdateErrorToJson(
  TypeAlertUpdateError instance,
) => <String, dynamic>{'message': instance.message};

UpdateError _$UpdateErrorFromJson(Map<String, dynamic> json) =>
    UpdateError(message: json['message'] as String);

Map<String, dynamic> _$UpdateErrorToJson(UpdateError instance) =>
    <String, dynamic>{'message': instance.message};

LoginError _$LoginErrorFromJson(Map<String, dynamic> json) =>
    LoginError(message: json['message'] as String);

Map<String, dynamic> _$LoginErrorToJson(LoginError instance) =>
    <String, dynamic>{'message': instance.message};

SignupError _$SignupErrorFromJson(Map<String, dynamic> json) =>
    SignupError(message: json['message'] as String);

Map<String, dynamic> _$SignupErrorToJson(SignupError instance) =>
    <String, dynamic>{'message': instance.message};

GoogleLoginRequest _$GoogleLoginRequestFromJson(Map<String, dynamic> json) =>
    GoogleLoginRequest(idToken: json['idToken'] as String);

Map<String, dynamic> _$GoogleLoginRequestToJson(GoogleLoginRequest instance) =>
    <String, dynamic>{'idToken': instance.idToken};

GoogleLoginSuccess _$GoogleLoginSuccessFromJson(Map<String, dynamic> json) =>
    GoogleLoginSuccess(
      message: json['message'] as String,
      access: json['access'] as String,
      refresh: json['refresh'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GoogleLoginSuccessToJson(GoogleLoginSuccess instance) =>
    <String, dynamic>{
      'message': instance.message,
      'access': instance.access,
      'refresh': instance.refresh,
      'user': instance.user,
    };

GoogleLoginError _$GoogleLoginErrorFromJson(Map<String, dynamic> json) =>
    GoogleLoginError(message: json['message'] as String);

Map<String, dynamic> _$GoogleLoginErrorToJson(GoogleLoginError instance) =>
    <String, dynamic>{'message': instance.message};

SignupRequest _$SignupRequestFromJson(Map<String, dynamic> json) =>
    SignupRequest(
      email: json['email'] as String,
      password1: json['password1'] as String,
      password2: json['password2'] as String,
      firstname: json['firstname'] as String,
      lastname: json['lastname'] as String,
      middlename: json['middlename'] as String?,
      telephone: json['telephone'] as String?,
      role: json['role'] as String? ?? 'User',
    );

Map<String, dynamic> _$SignupRequestToJson(SignupRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password1': instance.password1,
      'password2': instance.password2,
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'middlename': instance.middlename,
      'telephone': instance.telephone,
      'role': instance.role,
    };

SignupSuccess _$SignupSuccessFromJson(Map<String, dynamic> json) =>
    SignupSuccess(message: json['message'] as String);

Map<String, dynamic> _$SignupSuccessToJson(SignupSuccess instance) =>
    <String, dynamic>{'message': instance.message};

RegisterRequest _$RegisterRequestFromJson(Map<String, dynamic> json) =>
    RegisterRequest(
      email: json['email'] as String,
      password: json['password'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$RegisterRequestToJson(RegisterRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phone': instance.phone,
    };

RegisterResponse _$RegisterResponseFromJson(Map<String, dynamic> json) =>
    RegisterResponse(
      message: json['message'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RegisterResponseToJson(RegisterResponse instance) =>
    <String, dynamic>{'message': instance.message, 'user': instance.user};

ChangePasswordRequest _$ChangePasswordRequestFromJson(
  Map<String, dynamic> json,
) => ChangePasswordRequest(
  oldPassword: json['oldPassword'] as String,
  newPassword: json['newPassword'] as String,
  confirmPassword: json['confirmPassword'] as String,
);

Map<String, dynamic> _$ChangePasswordRequestToJson(
  ChangePasswordRequest instance,
) => <String, dynamic>{
  'oldPassword': instance.oldPassword,
  'newPassword': instance.newPassword,
  'confirmPassword': instance.confirmPassword,
};

ResetPasswordRequest _$ResetPasswordRequestFromJson(
  Map<String, dynamic> json,
) => ResetPasswordRequest(email: json['email'] as String);

Map<String, dynamic> _$ResetPasswordRequestToJson(
  ResetPasswordRequest instance,
) => <String, dynamic>{'email': instance.email};

ResetPasswordConfirmRequest _$ResetPasswordConfirmRequestFromJson(
  Map<String, dynamic> json,
) => ResetPasswordConfirmRequest(
  uid: (json['uid'] as num).toInt(),
  token: json['token'] as String,
  newPassword: json['newPassword'] as String,
  confirmPassword: json['confirmPassword'] as String,
);

Map<String, dynamic> _$ResetPasswordConfirmRequestToJson(
  ResetPasswordConfirmRequest instance,
) => <String, dynamic>{
  'uid': instance.uid,
  'token': instance.token,
  'newPassword': instance.newPassword,
  'confirmPassword': instance.confirmPassword,
};
