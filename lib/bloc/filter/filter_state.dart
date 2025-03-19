part of 'filter_bloc.dart';

sealed class FilterState extends Equatable {
  const FilterState();
}

final class FilterInitial extends FilterState {
  @override
  List<Object> get props => [];
}

class FilterLoading extends FilterState {
  @override
  List<Object?> get props => [];
}

class FilterLoaded extends FilterState {
  final double? caratFrom;
  final double? caratTo;
  final String? lab;
  final String? shape;
  final String? color;
  final String? clarity;
  final bool isApplied;

  const FilterLoaded({
    this.caratFrom,
    this.caratTo,
    this.lab,
    this.shape,
    this.color,
    this.clarity,
    this.isApplied = false,
  });

  FilterLoaded copyWith({
    double? caratFrom,
    double? caratTo,
    String? lab,
    String? shape,
    String? color,
    String? clarity,
    bool? isApplied,
  }) {
    return FilterLoaded(
      caratFrom: caratFrom ?? this.caratFrom,
      caratTo: caratTo ?? this.caratTo,
      lab: lab ?? this.lab,
      shape: shape ?? this.shape,
      color: color ?? this.color,
      clarity: clarity ?? this.clarity,
      isApplied: isApplied ?? this.isApplied,
    );
  }

  @override
  List<Object?> get props => [
    caratFrom,
    caratTo,
    lab,
    shape,
    color,
    clarity,
    isApplied,
  ];
}
