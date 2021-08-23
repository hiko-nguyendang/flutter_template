// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return UserModel(
    id: json['id'] as int,
    email: json['email'] as String,
    name: json['name'] as String,
    phoneNumber: json['phoneNumber'] as String,
    imageUrl: json['imageUrl'] as String ??
        'https://agreenapp.blob.core.windows.net/uploads/images/avatar-default.png',
    roleId: json['roleId'] as int,
    countryId: json['countryId'] as int,
    tenantId: json['tenantId'] as int,
    permissions:
        (json['permissions'] as List)?.map((e) => e as String)?.toList(),
    countryCode: json['countryCode'] as String,
  );
}

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'countryCode': instance.countryCode,
      'roleId': instance.roleId,
      'countryId': instance.countryId,
      'tenantId': instance.tenantId,
      'permissions': instance.permissions,
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'imageUrl': instance.imageUrl,
    };

LoginResponseModel _$LoginResponseModelFromJson(Map<String, dynamic> json) {
  return LoginResponseModel(
    userInfo: json['userInfo'] == null
        ? null
        : UserModel.fromJson(json['userInfo'] as Map<String, dynamic>),
    accessToken: json['accessToken'] as String,
    refreshToken: json['refreshToken'] as String,
    expiresIn: json['expiresIn'] as int,
  );
}

Map<String, dynamic> _$LoginResponseModelToJson(LoginResponseModel instance) =>
    <String, dynamic>{
      'userInfo': instance.userInfo,
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'expiresIn': instance.expiresIn,
    };

RefreshTokenResponse _$RefreshTokenResponseFromJson(Map<String, dynamic> json) {
  return RefreshTokenResponse(
    accessToken: json['accessToken'] as String,
    refreshToken: json['refreshToken'] as String,
    expiresIn: json['expiresIn'] as int,
  );
}

Map<String, dynamic> _$RefreshTokenResponseToJson(
        RefreshTokenResponse instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'expiresIn': instance.expiresIn,
    };

UpdateProfileParam _$UpdateProfileParamFromJson(Map<String, dynamic> json) {
  return UpdateProfileParam(
    imageUrl: json['imageUrl'] as String,
    phoneNumber: json['phoneNumber'] as String,
  );
}

Map<String, dynamic> _$UpdateProfileParamToJson(UpdateProfileParam instance) =>
    <String, dynamic>{
      'imageUrl': instance.imageUrl,
      'phoneNumber': instance.phoneNumber,
    };

SupplierModel _$SupplierModelFromJson(Map<String, dynamic> json) {
  return SupplierModel(
    supplierId: json['supplierId'] as int,
    name: json['name'] as String,
    phoneNumber: json['phoneNumber'] as String,
    email: json['email'] as String,
    image: json['image'] as String,
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
  );
}

Map<String, dynamic> _$SupplierModelToJson(SupplierModel instance) =>
    <String, dynamic>{
      'supplierId': instance.supplierId,
      'phoneNumber': instance.phoneNumber,
      'name': instance.name,
      'email': instance.email,
      'image': instance.image,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
    };

ResetPasswordParam _$ResetPasswordParamFromJson(Map<String, dynamic> json) {
  return ResetPasswordParam(
    newPassword: json['newPassword'] as String,
    passwordResetCode: json['passwordResetCode'] as String,
  );
}

Map<String, dynamic> _$ResetPasswordParamToJson(ResetPasswordParam instance) =>
    <String, dynamic>{
      'passwordResetCode': instance.passwordResetCode,
      'newPassword': instance.newPassword,
    };
