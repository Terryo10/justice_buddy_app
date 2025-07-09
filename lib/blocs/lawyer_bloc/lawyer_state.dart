part of 'lawyer_bloc.dart';

abstract class LawyerState extends Equatable {
  const LawyerState();

  @override
  List<Object?> get props => [];
}

class LawyerInitial extends LawyerState {}

class LawyerLoading extends LawyerState {}

class LawyersLoaded extends LawyerState {
  final List<LawyerModel> lawyers;
  final LawyerModel? selectedLawyer;

  const LawyersLoaded({required this.lawyers, this.selectedLawyer});

  LawyersLoaded copyWith({
    List<LawyerModel>? lawyers,
    LawyerModel? selectedLawyer,
  }) {
    return LawyersLoaded(
      lawyers: lawyers ?? this.lawyers,
      selectedLawyer: selectedLawyer,
    );
  }

  @override
  List<Object?> get props => [lawyers, selectedLawyer];
}

class LawyerDetailsLoaded extends LawyerState {
  final LawyerModel lawyer;

  const LawyerDetailsLoaded({required this.lawyer});

  @override
  List<Object?> get props => [lawyer];
}

class FeaturedLawyersLoaded extends LawyerState {
  final List<LawyerModel> featuredLawyers;

  const FeaturedLawyersLoaded({required this.featuredLawyers});

  @override
  List<Object?> get props => [featuredLawyers];
}

class SpecializationsLoaded extends LawyerState {
  final List<String> specializations;

  const SpecializationsLoaded({required this.specializations});

  @override
  List<Object?> get props => [specializations];
}

class LocationsLoaded extends LawyerState {
  final List<String> cities;
  final List<String> provinces;

  const LocationsLoaded({required this.cities, required this.provinces});

  @override
  List<Object?> get props => [cities, provinces];
}

class NearbyLawyersLoaded extends LawyerState {
  final List<LawyerModel> nearbyLawyers;

  const NearbyLawyersLoaded({required this.nearbyLawyers});

  @override
  List<Object?> get props => [nearbyLawyers];
}

class LawyerError extends LawyerState {
  final String message;

  const LawyerError({required this.message});

  @override
  List<Object?> get props => [message];
}
