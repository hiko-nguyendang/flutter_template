import 'package:json_annotation/json_annotation.dart';

import 'package:agree_n/app/data/models/share.model.dart';

part 'other_service.model.g.dart';

@JsonSerializable()
class PackagingModel {
  final int juteBagTypeId;
  final int packagingStatusId;
  final double quantityAvailable;
  final double price;
  final int priceUnitTypeId;
  final bool vop;

  final int measuringUnitTypeId;
  final double lengthOfBag;
  final double widthOfBag;
  final double weightOfBag;
  final String gradeType;
  final String treatment;
  final int bagTypeId;
  final String printing;
  final int noOfColors;
  final String stripes;
  final double moisture;
  final String extra;
  final String specialDocument;
  final String packing;
  final String loading;
  final String compliance;
  final String specialInstruction;

  PackagingModel({
    this.priceUnitTypeId,
    this.juteBagTypeId,
    this.packagingStatusId,
    this.quantityAvailable,
    this.price,
    this.vop,
    this.measuringUnitTypeId,
    this.lengthOfBag,
    this.widthOfBag,
    this.weightOfBag,
    this.gradeType,
    this.treatment,
    this.bagTypeId,
    this.printing,
    this.noOfColors,
    this.stripes,
    this.moisture,
    this.extra,
    this.specialDocument,
    this.packing,
    this.loading,
    this.compliance,
    this.specialInstruction,
  });

  factory PackagingModel.fromJson(Map<String, dynamic> json) =>
      _$PackagingModelFromJson(json);

  Map<String, dynamic> toJson() => _$PackagingModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TruckingModel {
  final int id;
  final int type;
  final String companyName;
  final double truckSize;
  final int truckSizeQuantityUnitTypeId;
  final double volumeAvailable;
  final int volumeQuantityUnitTypeId;
  final String truckNumber;
  final DateTime validityStart;
  final DateTime validityEnd;
  final List<RouteModel> routes;

  TruckingModel(
      {this.id,
      this.companyName,
      this.truckSize,
      this.truckNumber,
      this.volumeAvailable,
      this.validityStart,
      this.validityEnd,
      this.truckSizeQuantityUnitTypeId,
      this.type,
      this.routes,
      this.volumeQuantityUnitTypeId});

  factory TruckingModel.fromJson(Map<String, dynamic> json) =>
      _$TruckingModelFromJson(json);

  Map<String, dynamic> toJson() => _$TruckingModelToJson(this);
}

@JsonSerializable()
class RouteModel {
  final int sortOrder;
  final String originName;
  final String originCityName;
  final String originPlaceId;
  final String destinationName;
  final String destinationCityName;
  final String destinationPlaceId;
  final double distance;
  final double price;
  final int priceUnitTypeId;

  RouteModel(
      {this.originName,
      this.destinationName,
      this.distance,
      this.price,
      this.priceUnitTypeId,
      this.destinationPlaceId,
      this.originPlaceId,
      this.destinationCityName,
      this.originCityName,
      this.sortOrder});

  factory RouteModel.fromJson(Map<String, dynamic> json) =>
      _$RouteModelFromJson(json);

  Map<String, dynamic> toJson() => _$RouteModelToJson(this);
}

@JsonSerializable()
class MachineriesModel {
  final String machineryName;
  final String branchName;
  final int statusId;
  final int yearOfManufacture;
  final double price;
  final int priceUnitTypeId;

  MachineriesModel({
    this.machineryName,
    this.branchName,
    this.statusId,
    this.yearOfManufacture,
    this.price,
    this.priceUnitTypeId,
  });

  factory MachineriesModel.fromJson(Map<String, dynamic> json) =>
      _$MachineriesModelFromJson(json);

  Map<String, dynamic> toJson() => _$MachineriesModelToJson(this);
}

@JsonSerializable()
class OthersModel {
  final String productName;
  final String branchName;
  final String bagSize;
  final String composition;
  final double priceDelivered;
  final double priceWithoutCredit;
  final int currencyId;
  final String currency;
  final int packingUnitTypeId;

  OthersModel(
      {this.productName,
      this.branchName,
      this.bagSize,
      this.composition,
      this.priceDelivered,
      this.priceWithoutCredit,
      this.currencyId,
      this.currency,
      this.packingUnitTypeId});

  factory OthersModel.fromJson(Map<String, dynamic> json) =>
      _$OthersModelFromJson(json);

  Map<String, dynamic> toJson() => _$OthersModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class OtherServiceModel {
  final int offerId;
  final int tenantId;
  final int userId;
  final String tenantName;
  final int serviceTypeId;
  final bool isActive;
  final String comments;
  final List<String> urlImages;
  final TruckingModel trucking;
  final PackagingModel packaging;
  final MachineriesModel machinery;
  final OthersModel other;
  final DateTime createdDate;
  final DateTime modifiedDate;
  bool isFavorite;

  bool get commentHasMore {
    if (comments == null || comments.isEmpty) {
      return false;
    }
    return comments.length > 120;
  }

  OtherServiceModel(
      {this.offerId,
      this.tenantId,
      this.userId,
      this.tenantName,
      this.serviceTypeId,
      this.isActive,
      this.comments,
      this.urlImages,
      this.trucking,
      this.packaging,
      this.machinery,
      this.other,
      this.createdDate,
      this.modifiedDate,
      this.isFavorite,
      this.routeEndLocation,
      this.routeStartLocation,
      this.totalDistance,
      this.totalPrice,
      this.firstHalf,
      this.isMore = false,
      this.secondHalf,
      this.valueSlider});

  //UI only machinery
  @JsonKey(ignore: true)
  String firstHalf;
  @JsonKey(ignore: true)
  String secondHalf;
  @JsonKey(ignore: true)
  bool isMore;

  //UI only trucking
  @JsonKey(ignore: true)
  String routeStartLocation;
  @JsonKey(ignore: true)
  String routeEndLocation;
  @JsonKey(ignore: true)
  double totalDistance;
  @JsonKey(ignore: true)
  double totalPrice;
  @JsonKey(ignore: true)
  List<double> valueSlider;

  factory OtherServiceModel.fromJson(Map<String, dynamic> json) =>
      _$OtherServiceModelFromJson(json);

  Map<String, dynamic> toJson() => _$OtherServiceModelToJson(this);
}

@JsonSerializable()
class OtherServiceParam extends PaginationParam {
  int serviceTypeId;
  bool isGetFavoriteOffers;

  OtherServiceParam({
    this.isGetFavoriteOffers,
    this.serviceTypeId,
  });

  factory OtherServiceParam.fromJson(Map<String, dynamic> json) =>
      _$OtherServiceParamFromJson(json);

  Map<String, dynamic> toJson() => _$OtherServiceParamToJson(this);
}
