part of 'diamond_bloc.dart';

sealed class DiamondState extends Equatable {
  const DiamondState();
}

final class DiamondInitial extends DiamondState {
  @override
  List<Object> get props => [];
}
