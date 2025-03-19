part of 'diamond_bloc.dart';

enum SortOption {
  priceAsc,
  priceDesc,
  caratAsc,
  caratDesc,
}

sealed class DiamondEvent extends Equatable {}

class DiamondLoadRequested extends DiamondEvent {
  @override
  List<Object?> get props => [];
}

class DiamondFilterOptionsRequested extends DiamondEvent {
  @override
  List<Object?> get props => [];
}

class DiamondFiltered extends DiamondEvent {
  final double? caratFrom;
  final double? caratTo;
  final String? lab;
  final String? shape;
  final String? color;
  final String? clarity;

  DiamondFiltered({
    this.caratFrom,
    this.caratTo,
    this.lab,
    this.shape,
    this.color,
    this.clarity,
  });

  @override
  List<Object?> get props => [caratFrom,caratTo,lab,shape,color,clarity];
}

class DiamondSorted extends DiamondEvent {
  final SortOption sortOption;

  DiamondSorted(this.sortOption);

  @override
  List<Object?> get props => [sortOption];
}