import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'filter_event.dart';

part 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  FilterBloc() : super(FilterInitial()) {
    on<FilterUpdated>(_onFilterUpdated);
    on<FilterReset>(_onFilterReset);
    on<FilterApplied>(_onFilterApplied);
  }

  void _onFilterUpdated(FilterUpdated event, Emitter<FilterState> emit) {
    final currentState = state;
    if (currentState is FilterLoaded) {
      emit(currentState.copyWith(
        caratFrom: event.caratFrom,
        caratTo: event.caratTo,
        lab: event.lab,
        shape: event.shape,
        color: event.color,
        clarity: event.clarity,
      ));
    } else {
      emit(FilterLoaded(
        caratFrom: event.caratFrom,
        caratTo: event.caratTo,
        lab: event.lab,
        shape: event.shape,
        color: event.color,
        clarity: event.clarity,
      ));
    }
  }

  void _onFilterReset(FilterReset event, Emitter<FilterState> emit) {
    emit(const FilterLoaded());
  }

  void _onFilterApplied(FilterApplied event, Emitter<FilterState> emit) {
    final currentState = state;
    if (currentState is FilterLoaded) {
      emit(currentState.copyWith(isApplied: true));
    }
  }
}
