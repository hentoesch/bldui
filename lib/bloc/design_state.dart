part of 'design_bloc.dart';

@immutable
sealed class DesignState {}

final class DesignInitial extends DesignState {}

final class DesignFieldChange extends DesignState {
  final String fieldName;
  final FieldAction fieldAction;
  DesignFieldChange({required this.fieldName, required this.fieldAction});
  @override
  List<Object> get props => [fieldName, fieldAction];
}
