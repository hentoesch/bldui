import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:uilib/data/data_service.dart';
import 'package:bldui/common/globals.dart' as glob;
import 'package:bldui/common/types.dart';

import 'package:equatable/equatable.dart';
import 'package:bldui/common/template.dart' as templ;

part 'json_event.dart';
part 'json_state.dart';

class JsonBloc extends Bloc<JsonEvent, JsonState> {
  var tables;
  var fields;
  var bufferdModel;
  var mnd;
  var app;
  var wgt;
  EventType eventType = EventType.UPDATE;
  JsonBloc() : super(JsonStateInitial()) {
    on<JsonGetDataEvent>((event, emit) async {
      // eg.: event.wgt 'client_list'
      var uri = '${glob.apiBase}/${event.mnd}/${event.app}/model/${event.wgt}';
      mnd = event.mnd;
      app = event.app;
      wgt = event.wgt;

      var json = await DataService(url: uri).getModel();
      if (json == null) {
        eventType = EventType.INSERT;
        if (wgt.endsWith('_list')) {
          json = templ.getTemplate(JsonTemplate.list);
        } else if (wgt.endsWith('_form')) {
          json = templ.getTemplate(JsonTemplate.form);
        }
      }

      bufferdModel = json;
      emit(JsonDataReady(json: json));
    });
    on<JsonPersistBufferedEvent>((event, emit) async {
      var respCode;

      var uri = '${glob.apiBase}/$mnd/$app/model/$wgt';

      if (eventType == EventType.INSERT) {
        respCode = await DataService(url: uri).postData(bufferdModel);
      } else {
        respCode = await DataService(url: uri).putData(bufferdModel);
      }
      var reloadUri = '${glob.apiBase}/admin?cmd=reload';
      var resp = await DataService(url: reloadUri).getRecord();

      emit(JsonDataReady(json: {"status": respCode == 200 ? "ok" : "bad"}));
    });
    on<JsonPersistEvent>((event, emit) async {
      var respCode;

      var uri = '${glob.apiBase}/$mnd/$app/model/$wgt';

      if (event.eventType == EventType.INSERT) {
        respCode = await DataService(url: uri).postData(event.model);
      } else {
        respCode = await DataService(url: uri).putData(event.model);
      }
      var reloadUri = '${glob.apiBase}/admin?cmd=reload';
      var resp = await DataService(url: reloadUri).getRecord();

      emit(JsonDataReady(json: {"status": respCode == 200 ? "ok" : "bad"}));
    });

    on<JsonGetTableDataEvent>((event, emit) async {
      // eg.: event.wgt 'client_list'
      var retval = {"status": "bad"};
      var uri = '${glob.apiBase}/admin?cmd=dbinfo&db=${event.db}';
      var json = await DataService(url: uri).getRecord();
      if (json != {}) {
        tables = json['tables'];
        fields = json['fields'];
        retval['status'] = "ok";
      }
      emit(JsonDataReady(json: retval));
    });
    on<JsonBufferModelEvent>((event, emit) async {
      bufferdModel = event.model;
    });
  }
}
