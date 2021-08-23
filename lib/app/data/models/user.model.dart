import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/settings/app_config.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.model.g.dart';

@JsonSerializable()
class UserModel {
  final int id;
  final String email;
  final String countryCode;
  final int roleId;
  final int countryId;
  final int tenantId;
  final List<String> permissions;
  String name;
  String phoneNumber;
  @JsonKey(defaultValue: AppConfig.DEFAULT_USER_AVATAR)
  String imageUrl;

  bool get isBuyer {
    return roleId == UserRoleEnum.Buyer;
  }

  bool get isSupplier {
    return roleId == UserRoleEnum.Supplier;
  }

  //Check user permission
  bool get hasChat {
    return permissions.contains(PermissionEnum.chat);
  }

  bool get hasOffer {
    return permissions.contains(PermissionEnum.offer);
  }

  bool get hasOpenContract {
    return permissions.contains(PermissionEnum.openContract);
  }

  bool get hasPastContract {
    return permissions.contains(PermissionEnum.pastContract);
  }

  bool get hasDirectory {
    return permissions.contains(PermissionEnum.directory);
  }

  bool get hasOtherService {
    return permissions.contains(PermissionEnum.otherService);
  }

  bool get hasCreateContract {
    return permissions.contains(PermissionEnum.createContract);
  }

  bool get hasFinalizeContract {
    return permissions.contains(PermissionEnum.finalizeContract);
  }

  bool get hasCreateOffer {
    return permissions.contains(PermissionEnum.createOffer);
  }

  bool get hasCreateRequest {
    return permissions.contains(PermissionEnum.createRequest);
  }

  bool get hasMarketNewsPostWidget {
    return permissions.contains(PermissionEnum.marketNewPost);
  }

  bool get hasMarketNewsWidget {
    return permissions.contains(PermissionEnum.marketNew);
  }

  bool get hasMarketPriceWidget {
    return permissions.contains(PermissionEnum.marketPriceWidget);
  }

  bool get hasCurrencyRateWidget {
    return permissions.contains(PermissionEnum.currencyRateWidget);
  }

  bool get hasWeatherWidget {
    return permissions.contains(PermissionEnum.weatherWidget);
  }

  bool get hasWidget {
    return permissions.contains(PermissionEnum.widget);
  }

  UserModel(
      {this.id,
      this.email,
      this.name,
      this.phoneNumber,
      this.imageUrl,
      this.roleId,
      this.countryId,
      this.tenantId,
      this.permissions,
      this.countryCode});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

@JsonSerializable()
class LoginResponseModel {
  UserModel userInfo;
  String accessToken;
  String refreshToken;
  int expiresIn;

  LoginResponseModel({
    this.userInfo,
    this.accessToken,
    this.refreshToken,
    this.expiresIn,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseModelToJson(this);
}

@JsonSerializable()
class RefreshTokenResponse {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;

  RefreshTokenResponse({
    this.accessToken,
    this.refreshToken,
    this.expiresIn,
  });

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshTokenResponseToJson(this);
}

@JsonSerializable()
class UpdateProfileParam {
  String imageUrl;
  String phoneNumber;

  UpdateProfileParam({this.imageUrl, this.phoneNumber});

  factory UpdateProfileParam.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileParamFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateProfileParamToJson(this);
}

@JsonSerializable()
class SupplierModel {
  int supplierId;
  String phoneNumber;
  String name;
  String email;
  String image;
  String firstName;
  String lastName;

  SupplierModel(
      {this.supplierId,
      this.name,
      this.phoneNumber,
      this.email,
      this.image,
      this.firstName,
      this.lastName});

  factory SupplierModel.fromJson(Map<String, dynamic> json) =>
      _$SupplierModelFromJson(json);

  Map<String, dynamic> toJson() => _$SupplierModelToJson(this);
}

@JsonSerializable()
class ResetPasswordParam {
  String passwordResetCode;
  String newPassword;

  ResetPasswordParam({this.newPassword, this.passwordResetCode});

  factory ResetPasswordParam.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordParamFromJson(json);

  Map<String, dynamic> toJson() => _$ResetPasswordParamToJson(this);
}
