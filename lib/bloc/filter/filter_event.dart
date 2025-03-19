part of 'filter_bloc.dart';

sealed class FilterEvent extends Equatable {
  const FilterEvent();
}
class FilterUpdated extends FilterEvent {
  final double? caratFrom;
  final double? caratTo;
  final String? lab;
  final String? shape;
  final String? color;
  final String? clarity;

  const FilterUpdated({
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

class FilterReset extends FilterEvent {
  @override
  List<Object?> get props => [];
}

class FilterApplied extends FilterEvent {
  @override
  List<Object?> get props => [];
}
