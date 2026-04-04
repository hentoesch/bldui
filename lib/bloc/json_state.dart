part of 'json_bloc.dart';

@immutable
sealed class JsonState extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
final class JsonStateInitial extends JsonState {}

final class JsonDataReady extends JsonState {
  final json;
  JsonDataReady({required this.json});
  @override
  List<Object> get props => [json];
}

final class JsonFieldChange extends JsonState {
  final String fieldName;
  final FieldAction fieldAction;
  JsonFieldChange({required this.fieldName, required this.fieldAction});
  @override
  List<Object> get props => [fieldName, fieldAction];
}
