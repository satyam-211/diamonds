import 'package:bloc/bloc.dart';
import 'package:diamonds/data/models/diamond.dart';
import 'package:diamonds/data/repositories/diamond_repository.dart';
import 'package:equatable/equatable.dart';

part 'diamond_event.dart';

part 'diamond_state.dart';

class DiamondBloc extends Bloc<DiamondEvent, DiamondState> {
  final DiamondRepository diamondRepository;

  DiamondBloc({required this.diamondRepository}) : super(DiamondInitial()) {
    on<DiamondLoadRequested>(_onDiamondLoadRequested);
    on<DiamondFilterOptionsRequested>(_onDiamondFilterOptionsRequested);
    on<DiamondFiltered>(_onDiamondFiltered);
    on<DiamondSorted>(_onDiamondSorted);
  }

  void _onDiamondLoadRequested(
      DiamondLoadRequested event, Emitter<DiamondState> emit) async {
    emit(DiamondLoading());
    try {
      final diamonds = diamondRepository.getAllDiamonds();
      final filterOptions = diamondRepository.getFilterOptions();
      emit(DiamondLoaded(
        allDiamonds: diamonds,
        filteredDiamonds: diamonds,
        filterOptions: filterOptions,
      ));
    } catch (e) {
      emit(DiamondError("Failed to load diamonds: ${e.toString()}"));
    }
  }

  void _onDiamondFilterOptionsRequested(
      DiamondFilterOptionsRequested event, Emitter<DiamondState> emit) async {
    if (state is DiamondLoaded) {
      final currentState = state as DiamondLoaded;
      try {
        final filterOptions = diamondRepository.getFilterOptions();
        emit(currentState.copyWith(filterOptions: filterOptions));
      } catch (e) {
        emit(DiamondError("Failed to load filter options: ${e.toString()}"));
      }
    }
  }

  void _onDiamondFiltered(
      DiamondFiltered event, Emitter<DiamondState> emit) async {
    if (state is DiamondLoaded) {
      final currentState = state as DiamondLoaded;
      final filtered = _applyFilters(
        currentState.allDiamonds,
        event.caratFrom,
        event.caratTo,
        event.lab,
        event.shape,
        event.color,
        event.clarity,
      );
      emit(currentState.copyWith(filteredDiamonds: filtered));
    }
  }

  void _onDiamondSorted(DiamondSorted event, Emitter<DiamondState> emit) {
    if (state is DiamondLoaded) {
      final currentState = state as DiamondLoaded;
      final sortedDiamonds = List<Diamond>.from(currentState.filteredDiamonds);

      switch (event.sortOption) {
        case SortOption.priceAsc:
          sortedDiamonds.sort((a, b) => a.finalAmount.compareTo(b.finalAmount));
          break;
        case SortOption.priceDesc:
          sortedDiamonds.sort((a, b) => b.finalAmount.compareTo(a.finalAmount));
          break;
        case SortOption.caratAsc:
          sortedDiamonds.sort((a, b) => a.carat.compareTo(b.carat));
          break;
        case SortOption.caratDesc:
          sortedDiamonds.sort((a, b) => b.carat.compareTo(a.carat));
          break;
      }

      emit(currentState.copyWith(
        filteredDiamonds: sortedDiamonds,
        currentSortOption: event.sortOption,
      ));
    }
  }

  List<Diamond> _applyFilters(
    List<Diamond> diamonds,
    double? caratFrom,
    double? caratTo,
    String? lab,
    String? shape,
    String? color,
    String? clarity,
  ) {
    return diamonds.where((diamond) {
      bool matchesCarat = true;
      if (caratFrom != null) {
        matchesCarat = matchesCarat && diamond.carat >= caratFrom;
      }
      if (caratTo != null) {
        matchesCarat = matchesCarat && diamond.carat <= caratTo;
      }

      bool matchesLab = lab == null || diamond.lab == lab;
      bool matchesShape = shape == null || diamond.shape == shape;
      bool matchesColor = color == null || diamond.color == color;
      bool matchesClarity = clarity == null || diamond.clarity == clarity;

      return matchesCarat &&
          matchesLab &&
          matchesShape &&
          matchesColor &&
          matchesClarity;
    }).toList();
  }
}
