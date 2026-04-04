import 'package:flutter/material.dart';

class ModelFieldEdit extends StatefulWidget {
  dynamic model;
  String fieldName;
  double width = 128;

  /// the name of the field to edit
  ModelFieldEdit(
      {required this.model,
      required this.fieldName,
      this.width = 128,
      super.key});

  @override
  State<ModelFieldEdit> createState() => _ModelFieldEditState();
}

class _ModelFieldEditState extends State<ModelFieldEdit> {
  TextEditingController textController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textController =
        TextEditingController(text: widget.model[widget.fieldName]);
    // TODO: implement event handler
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: TextField(
        onChanged: (text) {
          widget.model[widget.fieldName] = text;
        },
        controller: textController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: '${widget.fieldName}',
          hintText: '${widget.fieldName}',
        ),
      ),
    );
  }
}
