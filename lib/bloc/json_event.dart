part of 'json_bloc.dart';

@immutable
sealed class JsonEvent {}

class JsonGetDataEvent extends JsonEvent {
  final String mnd; // Mandant
  final String app; // App
  final String wgt; // widget name ('client_list')

  JsonGetDataEvent({
    required this.mnd,
    required this.app,
    required this.wgt,
  });
}

enum EventType { INSERT, UPDATE }

class JsonPersistBufferedEvent extends JsonEvent {
  final EventType eventType;
  JsonPersistBufferedEvent({
    required this.eventType,
  });
}

class JsonPersistEvent extends JsonEvent {
  final EventType eventType;
  final dynamic model;
  JsonPersistEvent({required this.eventType, required this.model});
}

class JsonGetTableDataEvent extends JsonEvent {
  final String db; // Mandant

  JsonGetTableDataEvent({required this.db});
}

class JsonBufferModelEvent extends JsonEvent {
  final dynamic model; // Mandant

  JsonBufferModelEvent({required this.model});
}

class JsonFieldChangeEvent extends JsonEvent {
  final String fieldName; // Mandant
  final FieldAction fieldAction;

  JsonFieldChangeEvent({required this.fieldName, required this.fieldAction});
}
