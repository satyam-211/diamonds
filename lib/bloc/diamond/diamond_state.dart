part of 'diamond_bloc.dart';

sealed class DiamondState extends Equatable {
  const DiamondState();
}

final class DiamondInitial extends DiamondState {
  @override
  List<Object> get props => [];
}

class DiamondLoading extends DiamondState {
  @override
  List<Object?> get props => [];
}

class DiamondLoaded extends DiamondState {
  final List<Diamond> allDiamonds;
  final List<Diamond> filteredDiamonds;
  final SortOption? currentSortOption;
  final Map<String, List<String>>? filterOptions;

  const DiamondLoaded({
    required this.allDiamonds,
    required this.filteredDiamonds,
    this.currentSortOption,
    this.filterOptions,
  });

  DiamondLoaded copyWith({
    List<Diamond>? allDiamonds,
    List<Diamond>? filteredDiamonds,
    SortOption? currentSortOption,
    Map<String, List<String>>? filterOptions,
  }) {
    return DiamondLoaded(
      allDiamonds: allDiamonds ?? this.allDiamonds,
      filteredDiamonds: filteredDiamonds ?? this.filteredDiamonds,
      currentSortOption: currentSortOption ?? this.currentSortOption,
      filterOptions: filterOptions ?? this.filterOptions,
    );
  }

  @override
  List<Object?> get props => [allDiamonds, filteredDiamonds, currentSortOption, filterOptions];
}

class DiamondError extends DiamondState {
  final String message;

  const DiamondError(this.message);

  @override
  List<Object?> get props => [message];
}