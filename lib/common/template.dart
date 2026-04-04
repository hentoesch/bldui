import 'package:bldui/common/types.dart';

Map getTemplate(JsonTemplate jsonTemplate) {
  Map retval = {};
  switch (jsonTemplate) {
    case JsonTemplate.list:
      retval = _listTemplate;
      break;
    case JsonTemplate.form:
      retval = _formTemplate;
      break;
    case JsonTemplate.dataModelField:
      retval = _dataModelField;
      break;
    case JsonTemplate.dataModelTable:
      retval = _dataModelTable;
      break;
    case JsonTemplate.listColumn:
      retval = _listColumnTemplate;
      break;
    case JsonTemplate.formField:
      retval = _formFieldTemplate;
      break;
  }
  return retval;
}

///
/// LIST
///
var _listTemplate = {
  "baseFilter": null,
  "close": false,
  "dataModel": {
    "fields": [],
    "group": null,
    "keyField": null,
    "limit": null,
    "linkField": null,
    "order": "",
    "tables": [
      {
        "alias": "",
        "foreign_key": null,
        "key": "",
        "name": "",
        "type": "master"
      }
    ],
    "where": null
  },
  "filterFields": [],
  "host": "localhost",
  "listModel": {
    "close": null,
    "columnBorder": true,
    "cssClass": "row",
    "hasRecordPrompt": true,
    "headerHeight": 100,
    "height": 0,
    "modelHeight": 22,
    "paragraphs": [
      {
        "rows": [
          {"callbackRef": null, "colspan": "4", "columns": [], "style": null}
        ],
        "style": {"margin": "0px"}
      }
    ],
    "style": null,
    "width": 0,
    "withFilter": true,
    "withHeader": false,
    "withSearchInput": false
  },
  "port": "6109"
};

///
/// FORM
///
var _formTemplate = {
  "close": true,
  "dataModel": {
    "fields": [],
    "group": null,
    "keyField": null,
    "limit": null,
    "linkField": null,
    "order": null,
    "tables": [],
    "where": null
  },
  "formModel": {
    "buttons": null,
    "close": null,
    "colPx": 50,
    "cols": 8,
    "controls": null,
    "fields": [],
    "isModal": true,
    "rows": 3,
    "title": "sim"
  },
  "host": "localhost",
  "port": "6109",
  "user": "john"
};
// var _groupTemplate = {
//   "dataModel": {
//     "fields": [],
//     "group": null,
//     "keyField": null,
//     "limit": null,
//     "linkField": null,
//     "order": null,
//     "tables": [],
//     "where": null
//   },
//   "childType": "list"
// };

var _dataModelField = {
  "alias": "",
  "changeAllowed": "ALL",
  "defaultValue": "0",
  "name": "fld",
  "nameAs": "",
  "type": "C"
};
var _dataModelTable = {
  "alias": "xxx",
  "foreign_key": null,
  "key": "_id",
  "name": "tab",
  "type": "master"
};
var _listColumnTemplate = {
  "callbackRef": null,
  "clickEvent": null,
  "colspan": "1",
  "doc": null,
  "filterType": "MATCH",
  "hasFilter": true,
  "height": "16px",
  "label": "label",
  "name": "",
  "presetFilter": "",
  "rowspan": "1",
  "style": null,
  "width": "180px"
};

var _formFieldTemplate = {
  "bound": true,
  "changeAllowed": "ALL",
  "col": 4,
  "colspan": "2",
  "dataType": "C",
  "domObject": null,
  "floatingLabel": true,
  "hidden": false,
  "initValue": "",
  "inputType": "NGINPUT",
  "itemProvider": null,
  "items": null,
  "label": "sim_pin",
  "locked": false,
  "multiRows": 5,
  "name": "sim_pin",
  "row": 1,
  "rowspan": "1",
  "style": {"width": "206px"},
  "syncFields": null,
  "tabindex": 2,
  "textField": "sim_pin",
  "validatorParam": null,
  "validatorRef": null
};
