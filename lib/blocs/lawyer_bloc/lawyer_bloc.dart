import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:justice_buddy/models/lawyer_model.dart';
import 'package:justice_buddy/repositories/lawyer_repository/lawyer_repository.dart';

part 'lawyer_event.dart';
part 'lawyer_state.dart';

class LawyerBloc extends Bloc<LawyerEvent, LawyerState> {
  final LawyerRepository lawyerRepository;

  LawyerBloc({required this.lawyerRepository}) : super(LawyerInitial()) {
    on<LoadLawyers>(_onLoadLawyers);
    on<LoadLawyerBySlug>(_onLoadLawyerBySlug);
    on<LoadFeaturedLawyers>(_onLoadFeaturedLawyers);
    on<LoadLawyersBySpecialization>(_onLoadLawyersBySpecialization);
    on<LoadSpecializations>(_onLoadSpecializations);
    on<LoadLocations>(_onLoadLocations);
    on<LoadNearbyLawyers>(_onLoadNearbyLawyers);
    on<SelectLawyer>(_onSelectLawyer);
    on<ClearLawyerSelection>(_onClearLawyerSelection);
    on<ResetLawyerState>(_onResetLawyerState);
  }

  Future<void> _onLoadLawyers(
    LoadLawyers event,
    Emitter<LawyerState> emit,
  ) async {
    emit(LawyerLoading());
    try {
      final lawyers = await lawyerRepository.getLawyers(
        specialization: event.specialization,
        city: event.city,
        province: event.province,
        acceptingClients: event.acceptingClients,
        language: event.language,
        search: event.search,
        sortBy: event.sortBy,
        sortDirection: event.sortDirection,
        page: event.page,
        perPage: event.perPage,
      );
      emit(LawyersLoaded(lawyers: lawyers));
    } catch (error) {
      emit(LawyerError(message: error.toString()));
    }
  }

  Future<void> _onLoadLawyerBySlug(
    LoadLawyerBySlug event,
    Emitter<LawyerState> emit,
  ) async {
    emit(LawyerLoading());
    try {
      final lawyer = await lawyerRepository.getLawyerBySlug(event.slug);
      emit(LawyerDetailsLoaded(lawyer: lawyer));
    } catch (error) {
      emit(LawyerError(message: error.toString()));
    }
  }

  Future<void> _onLoadFeaturedLawyers(
    LoadFeaturedLawyers event,
    Emitter<LawyerState> emit,
  ) async {
    emit(LawyerLoading());
    try {
      final featuredLawyers = await lawyerRepository.getFeaturedLawyers();
      emit(FeaturedLawyersLoaded(featuredLawyers: featuredLawyers));
    } catch (error) {
      emit(LawyerError(message: error.toString()));
    }
  }

  Future<void> _onLoadLawyersBySpecialization(
    LoadLawyersBySpecialization event,
    Emitter<LawyerState> emit,
  ) async {
    emit(LawyerLoading());
    try {
      final lawyers = await lawyerRepository.getLawyersBySpecialization(
        event.specialization,
      );
      emit(LawyersLoaded(lawyers: lawyers));
    } catch (error) {
      emit(LawyerError(message: error.toString()));
    }
  }

  Future<void> _onLoadSpecializations(
    LoadSpecializations event,
    Emitter<LawyerState> emit,
  ) async {
    emit(LawyerLoading());
    try {
      final specializations = await lawyerRepository.getSpecializations();
      emit(SpecializationsLoaded(specializations: specializations));
    } catch (error) {
      emit(LawyerError(message: error.toString()));
    }
  }

  Future<void> _onLoadLocations(
    LoadLocations event,
    Emitter<LawyerState> emit,
  ) async {
    emit(LawyerLoading());
    try {
      final locations = await lawyerRepository.getLocations();
      emit(
        LocationsLoaded(
          cities: locations['cities'] ?? [],
          provinces: locations['provinces'] ?? [],
        ),
      );
    } catch (error) {
      emit(LawyerError(message: error.toString()));
    }
  }

  Future<void> _onLoadNearbyLawyers(
    LoadNearbyLawyers event,
    Emitter<LawyerState> emit,
  ) async {
    emit(LawyerLoading());
    try {
      final nearbyLawyers = await lawyerRepository.getNearbyLawyers(
        latitude: event.latitude,
        longitude: event.longitude,
        radius: event.radius,
        specialization: event.specialization,
        limit: event.limit,
      );
      emit(NearbyLawyersLoaded(nearbyLawyers: nearbyLawyers));
    } catch (error) {
      emit(LawyerError(message: error.toString()));
    }
  }

  void _onSelectLawyer(SelectLawyer event, Emitter<LawyerState> emit) {
    if (state is LawyersLoaded) {
      final currentState = state as LawyersLoaded;
      emit(currentState.copyWith(selectedLawyer: event.lawyer));
    }
  }

  void _onClearLawyerSelection(
    ClearLawyerSelection event,
    Emitter<LawyerState> emit,
  ) {
    if (state is LawyersLoaded) {
      final currentState = state as LawyersLoaded;
      emit(currentState.copyWith(selectedLawyer: null));
    }
  }

  void _onResetLawyerState(ResetLawyerState event, Emitter<LawyerState> emit) {
    emit(LawyerInitial());
  }
}
