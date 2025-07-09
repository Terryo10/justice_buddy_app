part of 'lawyer_bloc.dart';

abstract class LawyerEvent extends Equatable {
  const LawyerEvent();

  @override
  List<Object?> get props => [];
}

class LoadLawyers extends LawyerEvent {
  final String? specialization;
  final String? city;
  final String? province;
  final bool? acceptingClients;
  final String? language;
  final String? search;
  final String? sortBy;
  final String? sortDirection;
  final int page;
  final int perPage;

  const LoadLawyers({
    this.specialization,
    this.city,
    this.province,
    this.acceptingClients,
    this.language,
    this.search,
    this.sortBy,
    this.sortDirection,
    this.page = 1,
    this.perPage = 15,
  });

  @override
  List<Object?> get props => [
    specialization,
    city,
    province,
    acceptingClients,
    language,
    search,
    sortBy,
    sortDirection,
    page,
    perPage,
  ];
}

class LoadLawyerBySlug extends LawyerEvent {
  final String slug;

  const LoadLawyerBySlug(this.slug);

  @override
  List<Object?> get props => [slug];
}

class LoadFeaturedLawyers extends LawyerEvent {}

class LoadLawyersBySpecialization extends LawyerEvent {
  final String specialization;

  const LoadLawyersBySpecialization(this.specialization);

  @override
  List<Object?> get props => [specialization];
}

class LoadSpecializations extends LawyerEvent {}

class LoadLocations extends LawyerEvent {}

class LoadNearbyLawyers extends LawyerEvent {
  final double latitude;
  final double longitude;
  final double radius;
  final String? specialization;
  final int limit;

  const LoadNearbyLawyers({
    required this.latitude,
    required this.longitude,
    this.radius = 50,
    this.specialization,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [
    latitude,
    longitude,
    radius,
    specialization,
    limit,
  ];
}

class SelectLawyer extends LawyerEvent {
  final LawyerModel lawyer;

  const SelectLawyer(this.lawyer);

  @override
  List<Object?> get props => [lawyer];
}

class ClearLawyerSelection extends LawyerEvent {}

class ResetLawyerState extends LawyerEvent {}
