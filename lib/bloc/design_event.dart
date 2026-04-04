part of 'design_bloc.dart';

@immutable
sealed class DesignEvent {}

class DesignFieldChangeEvent extends DesignEvent {
  final String fieldName; // Mandant
  final FieldAction fieldAction;

  DesignFieldChangeEvent({required this.fieldName, required this.fieldAction});
}
